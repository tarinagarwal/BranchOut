import { Router } from "express";
import { GitHubController } from "../controllers/github.controller";
import { authMiddleware } from "../middleware/auth.middleware";

const router = Router();
const githubController = new GitHubController();

router.post("/sync", authMiddleware, githubController.syncGitHubStats);
router.get("/stats/:username", authMiddleware, githubController.getGitHubStats);

export default router;
