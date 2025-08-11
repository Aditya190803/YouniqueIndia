import type { AssetStorageStrategy } from '@vendure/core';
import type { Request } from 'express';
import { Readable } from 'node:stream';
import path from 'node:path';
import { v2 as cloudinary, UploadApiResponse } from 'cloudinary';

export interface CloudinaryConfig {
  cloudName: string;
  apiKey: string;
  apiSecret: string;
  /** Optional folder prefix to namespace all assets, e.g. "vendure" */
  folder?: string;
  /** Whether to use secure URLs (https). Defaults to true. */
  secure?: boolean;
}

/**
 * Returns a configured instance of the CloudinaryAssetStorageStrategy which can then be passed to
 * the AssetServerPlugin `storageStrategyFactory` property.
 */
export function configureCloudinaryAssetStorage(cloudinaryConfig: CloudinaryConfig) {
  return () => new CloudinaryAssetStorageStrategy(cloudinaryConfig);
}

class CloudinaryAssetStorageStrategy implements AssetStorageStrategy {
  private readonly cloudName: string;
  private readonly apiKey: string;
  private readonly apiSecret: string;
  private readonly rootFolder: string;
  private readonly secure: boolean;

  constructor(config: CloudinaryConfig) {
    this.cloudName = config.cloudName;
    this.apiKey = config.apiKey;
    this.apiSecret = config.apiSecret;
    this.rootFolder = (config.folder || '').replace(/^\/+|\/+$/g, '');
    this.secure = config.secure ?? true;
  }

  async init(): Promise<void> {
    cloudinary.config({
      cloud_name: this.cloudName,
      api_key: this.apiKey,
      api_secret: this.apiSecret,
      secure: this.secure,
    });
  }

  destroy?(): void | Promise<void> {}

  async writeFileFromBuffer(fileName: string, data: Buffer): Promise<string> {
    const { publicId, resourceType } = this.toPublicIdAndResourceType(fileName);
    const uploadResult = await new Promise<UploadApiResponse>((resolve, reject) => {
      const uploadStream = cloudinary.uploader.upload_stream(
        {
          public_id: publicId,
          resource_type: resourceType,
          overwrite: true,
          folder: undefined, // public_id already contains folder path
        },
        (error, result) => {
          if (error || !result) return reject(error);
          resolve(result);
        },
      );
      Readable.from(data).pipe(uploadStream);
    });
    // Return identifier matching input (folder + filename)
    return this.normalizeIdentifier(fileName);
  }

  async writeFileFromStream(fileName: string, data: Readable): Promise<string> {
    const { publicId, resourceType } = this.toPublicIdAndResourceType(fileName);
    await new Promise<UploadApiResponse>((resolve, reject) => {
      const uploadStream = cloudinary.uploader.upload_stream(
        {
          public_id: publicId,
          resource_type: resourceType,
          overwrite: true,
          folder: undefined,
        },
        (error, result) => {
          if (error || !result) return reject(error);
          resolve(result);
        },
      );
      data.pipe(uploadStream);
    });
    return this.normalizeIdentifier(fileName);
  }

  async readFileToBuffer(identifier: string): Promise<Buffer> {
    const url = this.buildDeliveryUrl(identifier);
    const res = await fetch(url);
    if (!res.ok) {
      throw new Error(`Cloudinary fetch failed (${res.status}) for ${url}`);
    }
    const arrayBuffer = await res.arrayBuffer();
    return Buffer.from(arrayBuffer);
  }

  async readFileToStream(identifier: string): Promise<Readable> {
    const url = this.buildDeliveryUrl(identifier);
    const res = await fetch(url);
    if (!res.ok || !res.body) {
      // Fallback to empty stream
      return new Readable({
        read() {
          this.push(null);
        },
      });
    }
    // Convert Web ReadableStream to Node Readable
    return Readable.fromWeb(res.body as any);
  }

  async deleteFile(identifier: string): Promise<void> {
    const { publicId, resourceType } = this.toPublicIdAndResourceType(identifier);
    await cloudinary.uploader.destroy(publicId, { resource_type: resourceType, invalidate: true });
  }

  async fileExists(fileName: string): Promise<boolean> {
    try {
      const { publicId, resourceType } = this.toPublicIdAndResourceType(fileName);
      // A lightweight way is HEAD the delivery URL
      const url = this.buildDeliveryUrl(fileName);
      const res = await fetch(url, { method: 'HEAD' });
      if (res.ok) return true;
      // If HEAD not allowed, fall back to Admin API metadata lookup
      await cloudinary.api.resource(publicId, { resource_type: resourceType, max_results: 1 });
      return true;
    } catch {
      return false;
    }
  }

  toAbsoluteUrl(request: Request, identifier: string): string {
    return this.buildDeliveryUrl(identifier);
  }

  private buildDeliveryUrl(identifier: string): string {
    const normalized = this.normalizeIdentifier(identifier);
    // normalized like: cache/abc.jpg or foo/bar.png
    const ext = path.extname(normalized).replace(/^\./, '');
    const publicId = this.joinWithRoot(path.join(path.dirname(normalized), path.basename(normalized, path.extname(normalized))));
    const resourceType = this.getResourceTypeFromExtension(ext);
    return cloudinary.url(publicId, {
      secure: this.secure,
      resource_type: resourceType,
      type: 'upload',
      format: ext || undefined,
    });
  }

  private toPublicIdAndResourceType(fileName: string): { publicId: string; resourceType: 'image' | 'video' | 'raw' } {
    const normalized = this.normalizeIdentifier(fileName);
    const ext = path.extname(normalized).replace(/^\./, '').toLowerCase();
    const baseId = path.join(path.dirname(normalized), path.basename(normalized, path.extname(normalized)));
    const publicId = this.joinWithRoot(baseId);
    const resourceType = this.getResourceTypeFromExtension(ext);
    return { publicId, resourceType };
  }

  private getResourceTypeFromExtension(ext: string): 'image' | 'video' | 'raw' {
    const imageExts = new Set(['jpg', 'jpeg', 'png', 'gif', 'webp', 'svg', 'tiff', 'avif']);
    const videoExts = new Set(['mp4', 'webm', 'mov', 'ogv']);
    if (imageExts.has(ext)) return 'image';
    if (videoExts.has(ext)) return 'video';
    return 'raw';
  }

  private normalizeIdentifier(identifier: string): string {
    return identifier.replace(/^\/+/, '').replace(/\\/g, '/');
  }

  private joinWithRoot(p: string): string {
    const clean = p.replace(/^\/+/, '');
    return this.rootFolder ? `${this.rootFolder}/${clean}` : clean;
  }
}


