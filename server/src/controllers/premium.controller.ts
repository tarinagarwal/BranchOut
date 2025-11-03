import { Request, Response } from "express";
import { PremiumService } from "../services/premium.service";
import { AuthRequest } from "../middleware/auth.middleware";

const premiumService = new PremiumService();

export class PremiumController {
  async subscribe(req: AuthRequest, res: Response) {
    try {
      const { plan } = req.body; // 'monthly' or 'yearly'
      const result = await premiumService.createSubscription(req.userId!, plan);
      res.json(result);
    } catch (error: any) {
      res.status(500).json({ error: error.message });
    }
  }

  async getStatus(req: AuthRequest, res: Response) {
    try {
      const status = await premiumService.getSubscriptionStatus(req.userId!);
      res.json(status);
    } catch (error: any) {
      res.status(500).json({ error: error.message });
    }
  }

  async cancel(req: AuthRequest, res: Response) {
    try {
      await premiumService.cancelSubscription(req.userId!);
      res.json({ message: "Subscription cancelled successfully" });
    } catch (error: any) {
      res.status(500).json({ error: error.message });
    }
  }

  async webhook(req: Request, res: Response) {
    try {
      // Handle Polar.sh webhook
      const event = req.body;
      await premiumService.handleWebhook(event);
      res.json({ received: true });
    } catch (error: any) {
      res.status(500).json({ error: error.message });
    }
  }
}
