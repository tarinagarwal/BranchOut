import { PrismaClient } from "@prisma/client";

const prisma = new PrismaClient();

export class ReportService {
  async createReport(
    reporterId: string,
    reportedUserId: string,
    reason: string,
    description?: string
  ) {
    // Check if already reported
    const existing = await prisma.report.findFirst({
      where: {
        reporterId,
        reportedUserId,
        status: "pending",
      },
    });

    if (existing) {
      throw new Error("You have already reported this user");
    }

    return await prisma.report.create({
      data: {
        reporterId,
        reportedUserId,
        reason,
        description,
      },
    });
  }

  async blockUser(userId: string, blockedUserId: string) {
    // Deactivate any matches between these users
    await prisma.match.updateMany({
      where: {
        OR: [
          { user1Id: userId, user2Id: blockedUserId },
          { user1Id: blockedUserId, user2Id: userId },
        ],
      },
      data: {
        isActive: false,
      },
    });

    // In production, add a 'blocked_users' table
    // For now, just deactivate matches
  }
}
