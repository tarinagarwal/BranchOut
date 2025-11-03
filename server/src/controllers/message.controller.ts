import { Response } from "express";
import { MessageService } from "../services/message.service";
import { AuthRequest } from "../middleware/auth.middleware";

const messageService = new MessageService();

export class MessageController {
  async getMessages(req: AuthRequest, res: Response) {
    try {
      const { matchId } = req.params;
      const messages = await messageService.getMessages(matchId);
      res.json(messages);
    } catch (error) {
      res.status(500).json({ error: "Failed to fetch messages" });
    }
  }

  async sendMessage(req: AuthRequest, res: Response) {
    try {
      const { matchId, receiverId, content, type } = req.body;
      const message = await messageService.sendMessage(
        matchId,
        req.userId!,
        receiverId,
        content,
        type
      );
      res.json(message);
    } catch (error) {
      res.status(500).json({ error: "Failed to send message" });
    }
  }

  async markAsRead(req: AuthRequest, res: Response) {
    try {
      const { id } = req.params;
      const message = await messageService.markAsRead(id);
      res.json(message);
    } catch (error) {
      res.status(500).json({ error: "Failed to mark message as read" });
    }
  }
}
