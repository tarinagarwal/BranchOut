import { Router } from "express";
import { UserController } from "../controllers/user.controller";
import { authMiddleware } from "../middleware/auth.middleware";

const router = Router();
const userController = new UserController();

router.get("/profile/:id", authMiddleware, userController.getProfile);
router.put("/profile", authMiddleware, userController.updateProfile);
router.delete("/account", authMiddleware, userController.deleteAccount);
router.get("/discover", authMiddleware, userController.getDiscoverProfiles);

export default router;
