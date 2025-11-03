import { Router } from "express";
import { SwipeController } from "../controllers/swipe.controller";
import { authMiddleware } from "../middleware/auth.middleware";

const router = Router();
const swipeController = new SwipeController();

router.post("/", authMiddleware, swipeController.createSwipe);
router.get("/matches", authMiddleware, swipeController.getMatches);

export default router;
