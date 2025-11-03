import { Router } from "express";
import { PremiumController } from "../controllers/premium.controller";
import { authMiddleware } from "../middleware/auth.middleware";

const router = Router();
const premiumController = new PremiumController();

router.post("/subscribe", authMiddleware, premiumController.subscribe);
router.get("/status", authMiddleware, premiumController.getStatus);
router.post("/cancel", authMiddleware, premiumController.cancel);
router.post("/webhook", premiumController.webhook);

export default router;
