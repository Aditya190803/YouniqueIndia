import { AssetStorageStrategy } from '@vendure/core';
import { ReadStream } from 'fs';
import { v2 as cloudinary } from 'cloudinary';
import https from 'https';

cloudinary.config({
    cloud_name: process.env.CLOUDINARY_CLOUD_NAME,
    api_key: process.env.CLOUDINARY_API_KEY,
    api_secret: process.env.CLOUDINARY_API_SECRET,
});

export class CloudinaryAssetStorageStrategy implements AssetStorageStrategy {
    private sanitizeFileName(fileName: string): string {
        // Remove any path, keep only the base filename, and replace spaces with dashes
        return fileName.replace(/^.*[\\\/]/, '').replace(/\s+/g, '-');
    }

    /**
     * Helper to generate a Cloudinary preview URL (with transformation for thumbnail)
     */
    public static getPreviewUrl(secureUrl: string): string {
        if (!secureUrl.includes('cloudinary.com')) return secureUrl;
        return secureUrl.replace('/upload/', '/upload/c_thumb,w_200,h_200/');
    }

    async writeFileFromStream(fileName: string, stream: ReadStream): Promise<string> {
        const cleanFileName = this.sanitizeFileName(fileName);
        return new Promise((resolve, reject) => {
            const uploadStream = cloudinary.uploader.upload_stream(
                { public_id: `vendure-assets/${cleanFileName}`, resource_type: 'auto' },
                (error, result) => {
                    if (error) return reject(error);
                    if (!result || !result.secure_url) return reject(new Error('No Cloudinary URL returned'));
                    resolve(result.secure_url);
                }
            );
            stream.pipe(uploadStream);
        });
    }

    async writeFileFromBuffer(fileName: string, buffer: Buffer): Promise<string> {
        const cleanFileName = this.sanitizeFileName(fileName);
        return new Promise((resolve, reject) => {
            cloudinary.uploader.upload_stream(
                { public_id: `vendure-assets/${cleanFileName}`, resource_type: 'auto' },
                (error, result) => {
                    if (error) return reject(error);
                    if (!result || !result.secure_url) return reject(new Error('No Cloudinary URL returned'));
                    resolve(result.secure_url);
                }
            ).end(buffer);
        });
    }

    // Prevent Vendure from trying to serve Cloudinary assets via /assets/
    async readFileToStream(identifier: string): Promise<ReadStream> {
        throw new Error('Direct file streaming from Cloudinary is not supported. Use the Cloudinary URL directly.');
    }

    async readFileToBuffer(identifier: string): Promise<Buffer> {
        throw new Error('Direct file buffer access from Cloudinary is not supported. Use the Cloudinary URL directly.');
    }

    async deleteFile(identifier: string): Promise<void> {
        // identifier is the Cloudinary URL; extract public_id
        const match = identifier.match(/vendure-assets\/([^./]+)(\.[^.]+)?/);
        const publicId = match ? `vendure-assets/${match[1]}` : identifier;
        await cloudinary.uploader.destroy(publicId, { resource_type: 'auto' });
    }

    async fileExists(identifier: string): Promise<boolean> {
        try {
            const match = identifier.match(/vendure-assets\/([^./]+)(\.[^.]+)?/);
            const publicId = match ? `vendure-assets/${match[1]}` : identifier;
            await cloudinary.api.resource(publicId, { resource_type: 'auto' });
            return true;
        } catch {
            return false;
        }
    }

    // Always return the direct Cloudinary URL for the asset
    toAbsoluteUrl(identifier: string): string {
        return identifier;
    }
} 