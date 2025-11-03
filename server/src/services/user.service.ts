import { PrismaClient } from "@prisma/client";
import { CompatibilityService } from "./compatibility.service";

const prisma = new PrismaClient();
const compatibilityService = new CompatibilityService();

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
    // Get current user
    const currentUser = await prisma.user.findUnique({
      where: { id: userId },
    });

    if (!currentUser) {
      throw new Error("User not found");
    }

    // Check and reset swipe limit if needed
    await this.checkAndResetSwipeLimit(currentUser);

    if (currentUser.swipesLeft <= 0 && !currentUser.isPremium) {
      throw new Error(
        "Daily swipe limit reached. Upgrade to premium for unlimited swipes."
      );
    }

    const swipedUserIds = await prisma.swipe.findMany({
      where: { swiperId: userId },
      select: { swipedUserId: true },
    });

    const excludeIds = [
      userId,
      ...swipedUserIds.map((s: any) => s.swipedUserId),
    ];

    // Build filter conditions
    const whereConditions: any = {
      id: { notIn: excludeIds },
    };

    if (filters.experience) {
      whereConditions.experience = filters.experience;
    }

    if (filters.techStack) {
      const techArray = Array.isArray(filters.techStack)
        ? filters.techStack
        : filters.techStack.split(",");
      whereConditions.techStack = { hasSome: techArray };
    }

    if (filters.lookingFor) {
      const lookingForArray = Array.isArray(filters.lookingFor)
        ? filters.lookingFor
        : filters.lookingFor.split(",");
      whereConditions.lookingFor = { hasSome: lookingForArray };
    }

    if (filters.location) {
      whereConditions.location = {
        contains: filters.location,
        mode: "insensitive",
      };
    }

    const profiles = await prisma.user.findMany({
      where: whereConditions,
      include: {
        projects: {
          take: 3,
        },
      },
      take: 20,
    });

    // Calculate compatibility scores
    const profilesWithScores = profiles.map((profile) => ({
      ...profile,
      compatibilityScore: compatibilityService.calculateCompatibilityScore(
        currentUser.techStack,
        profile.techStack,
        currentUser.lookingFor,
        profile.lookingFor
      ),
    }));

    // Sort by compatibility score
    profilesWithScores.sort(
      (a, b) => b.compatibilityScore - a.compatibilityScore
    );

    return profilesWithScores;
  }

  private async checkAndResetSwipeLimit(user: any) {
    const now = new Date();
    const lastReset = new Date(user.lastSwipeReset);
    const hoursSinceReset =
      (now.getTime() - lastReset.getTime()) / (1000 * 60 * 60);

    // Reset if 24 hours have passed
    if (hoursSinceReset >= 24) {
      await prisma.user.update({
        where: { id: user.id },
        data: {
          swipesLeft: 50,
          lastSwipeReset: now,
        },
      });
    }
  }

  async checkAndResetSuperLikes(userId: string) {
    const user = await prisma.user.findUnique({
      where: { id: userId },
    });

    if (!user) return;

    const now = new Date();
    const lastReset = new Date(user.lastSuperLikeReset);
    const hoursSinceReset =
      (now.getTime() - lastReset.getTime()) / (1000 * 60 * 60);

    // Reset if 24 hours have passed
    if (hoursSinceReset >= 24) {
      await prisma.user.update({
        where: { id: userId },
        data: {
          superLikesLeft: 3,
          lastSuperLikeReset: now,
        },
      });
    }
  }
}
