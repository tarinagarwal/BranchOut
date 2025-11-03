import { Router } from "express";
import { ProjectController } from "../controllers/project.controller";
import { authMiddleware } from "../middleware/auth.middleware";

const router = Router();
const projectController = new ProjectController();

// User projects
router.get("/my", authMiddleware, projectController.getMyProjects);
router.post("/", authMiddleware, projectController.createProject);
router.put("/:id", authMiddleware, projectController.updateProject);
router.delete("/:id", authMiddleware, projectController.deleteProject);

// Project marketplace (premium)
router.get(
  "/marketplace",
  authMiddleware,
  projectController.getMarketplaceProjects
);
router.post(
  "/marketplace",
  authMiddleware,
  projectController.createMarketplaceProject
);
router.post(
  "/marketplace/:id/interest",
  authMiddleware,
  projectController.expressInterest
);
router.get(
  "/marketplace/:id/interested",
  authMiddleware,
  projectController.getInterestedUsers
);

export default router;
