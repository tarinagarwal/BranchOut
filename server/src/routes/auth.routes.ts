import { Router } from "express";
import passport from "passport";
import { AuthController } from "../controllers/auth.controller";
import { authMiddleware } from "../middleware/auth.middleware";

const router = Router();
const authController = new AuthController();

router.get(
  "/google",
  passport.authenticate("google", { scope: ["profile", "email"] })
);

router.get(
  "/google/callback",
  passport.authenticate("google", { session: false }),
  authController.googleCallback
);

router.get("/me", authMiddleware, authController.getMe);
router.post("/logout", authController.logout);

export default router;
