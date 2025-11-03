import { Router } from "express";
import { UploadController } from "../controllers/upload.controller";
import { authMiddleware } from "../middleware/auth.middleware";
import multer from "multer";

const router = Router();
const uploadController = new UploadController();
const upload = multer({ storage: multer.memoryStorage() });

router.post(
  "/image",
  authMiddleware,
  upload.single("file"),
  uploadController.uploadImage
);

router.post(
  "/images",
  authMiddleware,
  upload.array("files", 5),
  uploadController.uploadImages
);

router.delete("/image/:key", authMiddleware, uploadController.deleteImage);

export default router;
