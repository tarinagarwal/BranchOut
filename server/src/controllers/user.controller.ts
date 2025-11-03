import { Response } from "express";
import { UserService } from "../services/user.service";
import { AuthRequest } from "../middleware/auth.middleware";

const userService = new UserService();

export class UserController {
  async getProfile(req: AuthRequest, res: Response) {
    try {
      const userId = req.params.id || req.userId!;
      const user = await userService.getProfile(userId);
      res.json(user);
    } catch (error) {
      res.status(500).json({ error: "Failed to fetch profile" });
    }
  }

  async updateProfile(req: AuthRequest, res: Response) {
    try {
      const user = await userService.updateProfile(req.userId!, req.body);
      res.json(user);
    } catch (error) {
      res.status(500).json({ error: "Failed to update profile" });
    }
  }

  async deleteAccount(req: AuthRequest, res: Response) {
    try {
      await userService.deleteAccount(req.userId!);
      res.json({ message: "Account deleted successfully" });
    } catch (error) {
      res.status(500).json({ error: "Failed to delete account" });
    }
  }

  async getDiscoverProfiles(req: AuthRequest, res: Response) {
    try {
      const filters = req.query;
      const profiles = await userService.getDiscoverProfiles(
        req.userId!,
        filters
      );
      res.json(profiles);
    } catch (error) {
      res.status(500).json({ error: "Failed to fetch profiles" });
    }
  }
}
