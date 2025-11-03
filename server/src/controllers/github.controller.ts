import { Response } from "express";
import { GitHubService } from "../services/github.service";
import { AuthRequest } from "../middleware/auth.middleware";
import { PrismaClient } from "@prisma/client";

const githubService = new GitHubService();
const prisma = new PrismaClient();

export class GitHubController {
  async syncGitHubStats(req: AuthRequest, res: Response) {
    try {
      const { username } = req.body;

      if (!username) {
        return res.status(400).json({ error: "GitHub username is required" });
      }

      // Verify GitHub user exists
      const isValid = await githubService.verifyUser(username);
      if (!isValid) {
        return res.status(404).json({ error: "GitHub user not found" });
      }

      // Fetch stats
      const stats = await githubService.getUserStats(username);

      // Update user profile
      const user = await prisma.user.update({
        where: { id: req.userId! },
        data: {
          githubUsername: username,
          githubStats: stats,
        },
      });

      res.json({
        message: "GitHub stats synced successfully",
        stats,
      });
    } catch (error: any) {
      res.status(500).json({ error: error.message });
    }
  }

  async getGitHubStats(req: AuthRequest, res: Response) {
    try {
      const { username } = req.params;

      const stats = await githubService.getUserStats(username);
      res.json(stats);
    } catch (error: any) {
      res.status(500).json({ error: error.message });
    }
  }
}
