import { PrismaClient } from "@prisma/client";

const prisma = new PrismaClient();

export class AdminService {
  async getReports(status?: string) {
    return await prisma.report.findMany({
      where: status ? { status } : undefined,
      include: {
        reporter: {
          select: {
            id: true,
            name: true,
            email: true,
          },
        },
        reportedUser: {
          select: {
            id: true,
            name: true,
            email: true,
          },
        },
      },
      orderBy: { createdAt: "desc" },
    });
  }

  async updateReport(reportId: string, status: string, notes?: string) {
    return await prisma.report.update({
      where: { id: reportId },
      data: {
        status,
        resolvedAt: status === "resolved" ? new Date() : null,
      },
    });
  }

  async banUser(userId: string, reason: string) {
    // In production, add a 'banned' field to User model
    // For now, deactivate the user
    await prisma.user.update({
      where: { id: userId },
      data: {
        availability: "Banned",
      },
    });

    // Delete all active matches
    await prisma.match.updateMany({
      where: {
        OR: [{ user1Id: userId }, { user2Id: userId }],
      },
      data: {
        isActive: false,
      },
    });
  }

  async unbanUser(userId: string) {
    await prisma.user.update({
      where: { id: userId },
      data: {
        availability: "Active",
      },
    });
  }

  async getAnalytics() {
    const [
      totalUsers,
      activeUsers,
      premiumUsers,
      totalMatches,
      totalMessages,
      totalSwipes,
    ] = await Promise.all([
      prisma.user.count(),
      prisma.user.count({
        where: {
          updatedAt: {
            gte: new Date(Date.now() - 7 * 24 * 60 * 60 * 1000),
          },
        },
      }),
      prisma.user.count({ where: { isPremium: true } }),
      prisma.match.count(),
      prisma.message.count(),
      prisma.swipe.count(),
    ]);

    // Get user growth (last 30 days)
    const thirtyDaysAgo = new Date(Date.now() - 30 * 24 * 60 * 60 * 1000);
    const newUsers = await prisma.user.count({
      where: {
        createdAt: {
          gte: thirtyDaysAgo,
        },
      },
    });

    // Get top tech stacks
    const users = await prisma.user.findMany({
      select: { techStack: true },
    });
    const techCount: { [key: string]: number } = {};
    users.forEach((user) => {
      user.techStack.forEach((tech) => {
        techCount[tech] = (techCount[tech] || 0) + 1;
      });
    });
    const topTech = Object.entries(techCount)
      .sort((a, b) => b[1] - a[1])
      .slice(0, 10)
      .map(([tech, count]) => ({ tech, count }));

    return {
      totalUsers,
      activeUsers,
      premiumUsers,
      totalMatches,
      totalMessages,
      totalSwipes,
      newUsers,
      topTech,
      matchRate: totalUsers > 0 ? (totalMatches / totalUsers) * 100 : 0,
    };
  }

  async getUsers(page: number = 1, limit: number = 50) {
    const skip = (page - 1) * limit;

    const [users, total] = await Promise.all([
      prisma.user.findMany({
        skip,
        take: limit,
        orderBy: { createdAt: "desc" },
        select: {
          id: true,
          name: true,
          email: true,
          experience: true,
          isPremium: true,
          availability: true,
          createdAt: true,
          _count: {
            select: {
              swipesGiven: true,
              matchesAsUser1: true,
              matchesAsUser2: true,
            },
          },
        },
      }),
      prisma.user.count(),
    ]);

    return {
      users,
      total,
      page,
      pages: Math.ceil(total / limit),
    };
  }
}
