import { PrismaClient } from "@prisma/client";

const prisma = new PrismaClient();

export class UserService {
  async getProfile(userId: string) {
    return await prisma.user.findUnique({
      where: { id: userId },
      include: {
        projects: true,
      },
    });
  }

  async updateProfile(userId: string, data: any) {
    return await prisma.user.update({
      where: { id: userId },
      data,
    });
  }

  async deleteAccount(userId: string) {
    return await prisma.user.delete({
      where: { id: userId },
    });
  }

  async getDiscoverProfiles(userId: string, filters: any = {}) {
    const swipedUserIds = await prisma.swipe.findMany({
      where: { swiperId: userId },
      select: { swipedUserId: true },
    });

    const excludeIds = [userId, ...swipedUserIds.map((s) => s.swipedUserId)];

    return await prisma.user.findMany({
      where: {
        id: { notIn: excludeIds },
        ...(filters.experience && { experience: filters.experience }),
        ...(filters.techStack && { techStack: { hasSome: filters.techStack } }),
        ...(filters.lookingFor && {
          lookingFor: { hasSome: filters.lookingFor },
        }),
      },
      include: {
        projects: {
          take: 3,
        },
      },
      take: 20,
    });
  }
}
