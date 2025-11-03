import { Response } from "express";
import { ReportService } from "../services/report.service";
import { AuthRequest } from "../middleware/auth.middleware";

const reportService = new ReportService();

export class ReportController {
  async createReport(req: AuthRequest, res: Response) {
    try {
      const { reportedUserId, reason, description } = req.body;
      const report = await reportService.createReport(
        req.userId!,
        reportedUserId,
        reason,
        description
      );
      res.json(report);
    } catch (error: any) {
      res.status(500).json({ error: error.message });
    }
  }

  async blockUser(req: AuthRequest, res: Response) {
    try {
      const { userId } = req.params;
      await reportService.blockUser(req.userId!, userId);
      res.json({ message: "User blocked successfully" });
    } catch (error: any) {
      res.status(500).json({ error: error.message });
    }
  }
}
