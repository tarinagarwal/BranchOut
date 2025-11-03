import { Response } from "express";
import { AdminService } from "../services/admin.service";
import { AuthRequest } from "../middleware/auth.middleware";

const adminService = new AdminService();

export class AdminController {
  async getReports(req: AuthRequest, res: Response) {
    try {
      const { status } = req.query;
      const reports = await adminService.getReports(status as string);
      res.json(reports);
    } catch (error: any) {
      res.status(500).json({ error: error.message });
    }
  }

  async updateReport(req: AuthRequest, res: Response) {
    try {
      const { id } = req.params;
      const { status, notes } = req.body;
      const report = await adminService.updateReport(id, status, notes);
      res.json(report);
    } catch (error: any) {
      res.status(500).json({ error: error.message });
    }
  }

  async banUser(req: AuthRequest, res: Response) {
    try {
      const { id } = req.params;
      const { reason } = req.body;
      await adminService.banUser(id, reason);
      res.json({ message: "User banned successfully" });
    } catch (error: any) {
      res.status(500).json({ error: error.message });
    }
  }

  async unbanUser(req: AuthRequest, res: Response) {
    try {
      const { id } = req.params;
      await adminService.unbanUser(id);
      res.json({ message: "User unbanned successfully" });
    } catch (error: any) {
      res.status(500).json({ error: error.message });
    }
  }

  async getAnalytics(req: AuthRequest, res: Response) {
    try {
      const analytics = await adminService.getAnalytics();
      res.json(analytics);
    } catch (error: any) {
      res.status(500).json({ error: error.message });
    }
  }

  async getUsers(req: AuthRequest, res: Response) {
    try {
      const page = parseInt(req.query.page as string) || 1;
      const limit = parseInt(req.query.limit as string) || 50;
      const users = await adminService.getUsers(page, limit);
      res.json(users);
    } catch (error: any) {
      res.status(500).json({ error: error.message });
    }
  }
}
