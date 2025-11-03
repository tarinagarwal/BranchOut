import { Router } from "express";
import { AdminController } from "../controllers/admin.controller";
import { authMiddleware } from "../middleware/auth.middleware";
import { adminMiddleware } from "../middleware/admin.middleware";

const router = Router();
const adminController = new AdminController();

// All admin routes require auth + admin role
router.use(authMiddleware, adminMiddleware);

router.get("/reports", adminController.getReports);
router.put("/reports/:id", adminController.updateReport);
router.put("/users/:id/ban", adminController.banUser);
router.put("/users/:id/unban", adminController.unbanUser);
router.get("/analytics", adminController.getAnalytics);
router.get("/users", adminController.getUsers);

export default router;
