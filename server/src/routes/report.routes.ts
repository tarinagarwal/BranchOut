import { Router } from "express";
import { ReportController } from "../controllers/report.controller";
import { authMiddleware } from "../middleware/auth.middleware";

const router = Router();
const reportController = new ReportController();

router.post("/", authMiddleware, reportController.createReport);
router.post("/block/:userId", authMiddleware, reportController.blockUser);

export default router;
