import { Response } from "express";
import { SwipeService } from "../services/swipe.service";
import { AuthRequest } from "../middleware/auth.middleware";

const swipeService = new SwipeService();

export class SwipeController {
  async createSwipe(req: AuthRequest, res: Response) {
    try {
      const { swipedUserId, direction } = req.body;
      const result = await swipeService.createSwipe(
        req.userId!,
        swipedUserId,
        direction
      );
      res.json(result);
    } catch (error) {
      res.status(500).json({ error: "Failed to create swipe" });
    }
  }

  async getMatches(req: AuthRequest, res: Response) {
    try {
      const matches = await swipeService.getMatches(req.userId!);
      res.json(matches);
    } catch (error) {
      res.status(500).json({ error: "Failed to fetch matches" });
    }
  }
}
