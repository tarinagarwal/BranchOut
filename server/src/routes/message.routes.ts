import { Router } from "express";
import { MessageController } from "../controllers/message.controller";
import { authMiddleware } from "../middleware/auth.middleware";

const router = Router();
const messageController = new MessageController();

router.get("/:matchId", authMiddleware, messageController.getMessages);
router.post("/", authMiddleware, messageController.sendMessage);
router.put("/:id/read", authMiddleware, messageController.markAsRead);

export default router;
