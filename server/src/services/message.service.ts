import { PrismaClient } from "@prisma/client";

const prisma = new PrismaClient();

export class MessageService {
  async getMessages(matchId: string) {
    return await prisma.message.findMany({
      where: { matchId },
      orderBy: { createdAt: "asc" },
      include: {
        sender: {
          select: {
            id: true,
            name: true,
            profilePhoto: true,
          },
        },
      },
    });
  }

  async sendMessage(
    matchId: string,
    senderId: string,
    receiverId: string,
    content: string,
    type: string = "text"
  ) {
    return await prisma.message.create({
      data: {
        matchId,
        senderId,
        receiverId,
        content,
        type,
      },
      include: {
        sender: {
          select: {
            id: true,
            name: true,
            profilePhoto: true,
          },
        },
      },
    });
  }

  async markAsRead(messageId: string) {
    return await prisma.message.update({
      where: { id: messageId },
      data: { isRead: true },
    });
  }
}
