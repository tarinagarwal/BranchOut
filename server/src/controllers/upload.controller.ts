import { Response } from "express";
import { UploadService } from "../services/upload.service";
import { AuthRequest } from "../middleware/auth.middleware";

const uploadService = new UploadService();

export class UploadController {
  async uploadImage(req: AuthRequest, res: Response) {
    try {
      if (!req.file) {
        return res.status(400).json({ error: "No file provided" });
      }

      const file = new File([req.file.buffer], req.file.originalname, {
        type: req.file.mimetype,
      });

      const url = await uploadService.uploadFile(file);
      res.json({ url });
    } catch (error: any) {
      res.status(500).json({ error: error.message });
    }
  }

  async uploadImages(req: AuthRequest, res: Response) {
    try {
      if (!req.files || !Array.isArray(req.files)) {
        return res.status(400).json({ error: "No files provided" });
      }

      const files = req.files.map(
        (file) =>
          new File([file.buffer], file.originalname, {
            type: file.mimetype,
          })
      );

      const urls = await uploadService.uploadFiles(files);
      res.json({ urls });
    } catch (error: any) {
      res.status(500).json({ error: error.message });
    }
  }

  async deleteImage(req: AuthRequest, res: Response) {
    try {
      const { key } = req.params;
      await uploadService.deleteFile(key);
      res.json({ message: "File deleted successfully" });
    } catch (error: any) {
      res.status(500).json({ error: error.message });
    }
  }
}
