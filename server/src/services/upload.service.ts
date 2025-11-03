import { UTApi } from "uploadthing/server";
import { config } from "../config";

export class UploadService {
  private utapi: UTApi;

  constructor() {
    this.utapi = new UTApi({
      apiKey: config.uploadthing.secret,
    });
  }

  async uploadFile(file: File): Promise<string> {
    try {
      const response = await this.utapi.uploadFiles(file);
      if (response.data) {
        return response.data.url;
      }
      throw new Error("Upload failed");
    } catch (error: any) {
      throw new Error(`Failed to upload file: ${error.message}`);
    }
  }

  async deleteFile(fileKey: string): Promise<void> {
    try {
      await this.utapi.deleteFiles(fileKey);
    } catch (error: any) {
      throw new Error(`Failed to delete file: ${error.message}`);
    }
  }

  async uploadFiles(files: File[]): Promise<string[]> {
    try {
      const response = await this.utapi.uploadFiles(files);
      if (response.data) {
        return response.data.map((file: any) => file.url);
      }
      throw new Error("Upload failed");
    } catch (error: any) {
      throw new Error(`Failed to upload files: ${error.message}`);
    }
  }
}
