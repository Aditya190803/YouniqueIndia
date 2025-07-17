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

    async readFileToStream(identifier: string): Promise<ReadStream> {
        throw new Error('Direct file streaming from Cloudinary is not supported. Use the URL instead.');
    }

    async readFileToBuffer(identifier: string): Promise<Buffer> {
        // Fetch the file from the Cloudinary URL and return as Buffer
        return new Promise((resolve, reject) => {
            https.get(identifier, (res) => {
                const data: Buffer[] = [];
                res.on('data', (chunk) => data.push(chunk));
                res.on('end', () => resolve(Buffer.concat(data)));
                res.on('error', reject);
            }).on('error', reject);
        });
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

    toAbsoluteUrl(identifier: string): string {
        // identifier is the Cloudinary URL
        return identifier;
    }
} 