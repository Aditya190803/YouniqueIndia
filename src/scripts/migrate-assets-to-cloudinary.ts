import 'dotenv/config';
import path from 'node:path';
import { S3Client, ListObjectsV2Command, GetObjectCommand, _Object, ListObjectsV2CommandOutput } from '@aws-sdk/client-s3';
import { v2 as cloudinary } from 'cloudinary';
import { Readable } from 'node:stream';

type ResourceType = 'image' | 'video' | 'raw';

const imageExts = new Set(['jpg', 'jpeg', 'png', 'gif', 'webp', 'svg', 'tiff', 'avif']);
const videoExts = new Set(['mp4', 'webm', 'mov', 'ogv']);

function getResourceTypeFromExtension(ext: string): ResourceType {
  if (imageExts.has(ext)) return 'image';
  if (videoExts.has(ext)) return 'video';
  return 'raw';
}

function toPublicId(key: string, folder?: string): { publicId: string; resourceType: ResourceType } {
  const normalized = key.replace(/^\/+/, '').replace(/\\/g, '/');
  const ext = path.extname(normalized).replace(/^\./, '').toLowerCase();
  const baseId = path.join(path.dirname(normalized), path.basename(normalized, path.extname(normalized)));
  const publicId = folder ? `${folder.replace(/\/+$/,'')}/${baseId}` : baseId;
  const resourceType = getResourceTypeFromExtension(ext);
  return { publicId: publicId.replace(/\\/g, '/'), resourceType };
}

async function uploadToCloudinary(bodyStream: Readable, publicId: string, resourceType: ResourceType): Promise<void> {
  await new Promise<void>((resolve, reject) => {
    const upload = cloudinary.uploader.upload_stream(
      { public_id: publicId, resource_type: resourceType, overwrite: false },
      (err) => {
        if (err) return reject(err);
        resolve();
      },
    );
    bodyStream.pipe(upload);
  });
}

async function migrate(): Promise<void> {
  const required = [
    'AWS_S3_BUCKET',
    'AWS_REGION',
    'CLOUDINARY_CLOUD_NAME',
    'CLOUDINARY_API_KEY',
    'CLOUDINARY_API_SECRET',
  ] as const;
  for (const v of required) {
    if (!process.env[v]) throw new Error(`Missing required env var: ${v}`);
  }

  const bucket = process.env.AWS_S3_BUCKET!;
  const region = process.env.AWS_REGION!;
  const folder = process.env.CLOUDINARY_FOLDER;

  const s3 = new S3Client({ region });
  cloudinary.config({
    cloud_name: process.env.CLOUDINARY_CLOUD_NAME!,
    api_key: process.env.CLOUDINARY_API_KEY!,
    api_secret: process.env.CLOUDINARY_API_SECRET!,
    secure: true,
  });

  let continuationToken: string | undefined = undefined;
  let total = 0;
  let uploaded = 0;
  let skipped = 0;

  console.log(`Starting migration from s3://${bucket} (region=${region}) to Cloudinary (folder=${folder ?? '(none)'}).`);

  do {
    const list: ListObjectsV2CommandOutput = await s3.send(
      new ListObjectsV2Command({ Bucket: bucket, ContinuationToken: continuationToken }),
    );
    continuationToken = list.IsTruncated ? list.NextContinuationToken : undefined;
    const contents: _Object[] = list.Contents ?? [];
    for (const obj of contents) {
      const key = obj.Key;
      if (!key) continue;
      total++;
      // Normalize any backslashes from S3 keys and skip generated/cache/source prefixes
      const normalizedKey = key.replace(/\\/g, '/');
      if (
        normalizedKey.startsWith('cache/') ||
        normalizedKey.startsWith('preview/') ||
        normalizedKey.startsWith('source/')
      ) {
        skipped++;
        continue; // cache files will be regenerated on demand
      }
      const { publicId, resourceType } = toPublicId(normalizedKey, folder);
      try {
        // Skip if already present
        await cloudinary.api.resource(publicId, { resource_type: resourceType });
        skipped++;
        continue;
      } catch {
        // Not found, proceed to upload
      }
      const get = await s3.send(new GetObjectCommand({ Bucket: bucket, Key: key }));
      const body = get.Body as Readable | undefined;
      if (!body) {
        console.warn(`No body for ${key}, skipping`);
        skipped++;
        continue;
      }
      await uploadToCloudinary(body, publicId, resourceType);
      uploaded++;
      console.log(`Uploaded: ${key} -> ${publicId}`);
    }
  } while (continuationToken);

  console.log(`Done. Processed=${total}, Uploaded=${uploaded}, Skipped=${skipped}`);
}

migrate().catch((e) => {
  console.error(e);
  process.exit(1);
});


