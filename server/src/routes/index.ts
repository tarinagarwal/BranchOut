import { Router } from "express";
import authRoutes from "./auth.routes";
import userRoutes from "./user.routes";
import swipeRoutes from "./swipe.routes";
import messageRoutes from "./message.routes";
import githubRoutes from "./github.routes";

const router = Router();

router.use("/auth", authRoutes);
router.use("/users", userRoutes);
router.use("/swipes", swipeRoutes);
router.use("/messages", messageRoutes);
router.use("/github", githubRoutes);

export default router;
