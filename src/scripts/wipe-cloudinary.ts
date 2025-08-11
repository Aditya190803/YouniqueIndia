import 'dotenv/config';
import { v2 as cloudinary } from 'cloudinary';

async function wipe(): Promise<void> {
  const required = ['CLOUDINARY_CLOUD_NAME', 'CLOUDINARY_API_KEY', 'CLOUDINARY_API_SECRET'] as const;
  for (const v of required) {
    if (!process.env[v]) throw new Error(`Missing required env var: ${v}`);
  }
  const folder = process.env.CLOUDINARY_FOLDER?.replace(/^\/+|\/+$/g, '');

  cloudinary.config({
    cloud_name: process.env.CLOUDINARY_CLOUD_NAME!,
    api_key: process.env.CLOUDINARY_API_KEY!,
    api_secret: process.env.CLOUDINARY_API_SECRET!,
    secure: true,
  });

  const resourceTypes: Array<'image' | 'video' | 'raw'> = ['image', 'video', 'raw'];
  if (folder && folder.length > 0) {
    const prefix = `${folder}/`;
    console.log(`Deleting all Cloudinary resources by prefix: ${prefix}`);
    for (const type of resourceTypes) {
      await cloudinary.api.delete_resources_by_prefix(prefix, { resource_type: type });
    }
    // Attempt to delete folder tree (best-effort)
    try {
      // Delete nested sub-folders first
      const stack: string[] = [folder];
      while (stack.length) {
        const current = stack.pop()!;
        const subs = await cloudinary.api.sub_folders(current).catch(() => ({ folders: [] as any[] }));
        for (const f of subs.folders ?? []) {
          stack.push(f.path);
        }
        try {
          await cloudinary.api.delete_folder(current);
          console.log(`Deleted folder: ${current}`);
        } catch {
          // ignore
        }
      }
    } catch {
      // ignore
    }
  } else {
    console.log('Deleting ALL Cloudinary resources (image, video, raw)');
    for (const type of resourceTypes) {
      await cloudinary.api.delete_all_resources({ resource_type: type });
    }
  }
  console.log('Cloudinary wipe complete.');
}

wipe().catch((e) => {
  console.error(e);
  process.exit(1);
});


