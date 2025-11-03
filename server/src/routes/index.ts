import { Router } from "express";
import authRoutes from "./auth.routes";
import userRoutes from "./user.routes";
import swipeRoutes from "./swipe.routes";
import messageRoutes from "./message.routes";
import githubRoutes from "./github.routes";
import uploadRoutes from "./upload.routes";
import premiumRoutes from "./premium.routes";
import projectRoutes from "./project.routes";
import adminRoutes from "./admin.routes";
import reportRoutes from "./report.routes";

const router = Router();

router.use("/auth", authRoutes);
router.use("/users", userRoutes);
router.use("/swipes", swipeRoutes);
router.use("/messages", messageRoutes);
router.use("/github", githubRoutes);
router.use("/upload", uploadRoutes);
router.use("/premium", premiumRoutes);
router.use("/projects", projectRoutes);
router.use("/admin", adminRoutes);
router.use("/reports", reportRoutes);

export default router;
