import { Response } from "express";
import { ProjectService } from "../services/project.service";
import { AuthRequest } from "../middleware/auth.middleware";

const projectService = new ProjectService();

export class ProjectController {
  async getMyProjects(req: AuthRequest, res: Response) {
    try {
      const projects = await projectService.getUserProjects(req.userId!);
      res.json(projects);
    } catch (error: any) {
      res.status(500).json({ error: error.message });
    }
  }

  async createProject(req: AuthRequest, res: Response) {
    try {
      const project = await projectService.createProject(req.userId!, req.body);
      res.json(project);
    } catch (error: any) {
      res.status(500).json({ error: error.message });
    }
  }

  async updateProject(req: AuthRequest, res: Response) {
    try {
      const project = await projectService.updateProject(
        req.params.id,
        req.userId!,
        req.body
      );
      res.json(project);
    } catch (error: any) {
      res.status(500).json({ error: error.message });
    }
  }

  async deleteProject(req: AuthRequest, res: Response) {
    try {
      await projectService.deleteProject(req.params.id, req.userId!);
      res.json({ message: "Project deleted successfully" });
    } catch (error: any) {
      res.status(500).json({ error: error.message });
    }
  }

  async getMarketplaceProjects(req: AuthRequest, res: Response) {
    try {
      const projects = await projectService.getMarketplaceProjects(req.userId!);
      res.json(projects);
    } catch (error: any) {
      res.status(500).json({ error: error.message });
    }
  }

  async createMarketplaceProject(req: AuthRequest, res: Response) {
    try {
      const project = await projectService.createMarketplaceProject(
        req.userId!,
        req.body
      );
      res.json(project);
    } catch (error: any) {
      res.status(500).json({ error: error.message });
    }
  }

  async expressInterest(req: AuthRequest, res: Response) {
    try {
      const interest = await projectService.expressInterest(
        req.params.id,
        req.userId!
      );
      res.json(interest);
    } catch (error: any) {
      res.status(500).json({ error: error.message });
    }
  }

  async getInterestedUsers(req: AuthRequest, res: Response) {
    try {
      const users = await projectService.getInterestedUsers(
        req.params.id,
        req.userId!
      );
      res.json(users);
    } catch (error: any) {
      res.status(500).json({ error: error.message });
    }
  }
}
