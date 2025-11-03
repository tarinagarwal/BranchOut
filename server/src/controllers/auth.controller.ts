import { Request, Response } from "express";
import { AuthService } from "../services/auth.service";
import { AuthRequest } from "../middleware/auth.middleware";

const authService = new AuthService();

export class AuthController {
  async googleCallback(req: Request, res: Response) {
    try {
      const user = req.user as any;
      const token = authService.generateToken(user.id);

      res.redirect(`${process.env.FRONTEND_URL}/auth/callback?token=${token}`);
    } catch (error) {
      res.status(500).json({ error: "Authentication failed" });
    }
  }

  async getMe(req: AuthRequest, res: Response) {
    try {
      const user = await authService.getUserById(req.userId!);
      res.json(user);
    } catch (error) {
      res.status(500).json({ error: "Failed to fetch user" });
    }
  }

  async logout(req: Request, res: Response) {
    res.json({ message: "Logged out successfully" });
  }
}
