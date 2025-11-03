import { PrismaClient } from "@prisma/client";
import { CompatibilityService } from "./compatibility.service";

const prisma = new PrismaClient();
const compatibilityService = new CompatibilityService();

export class SwipeService {
  async createSwipe(swiperId: string, swipedUserId: string, direction: string) {
    // Get swiper user
    const swiper = await prisma.user.findUnique({
      where: { id: swiperId },
    });

    if (!swiper) {
      throw new Error("User not found");
    }

    // Check swipe limits
    if (!swiper.isPremium && swiper.swipesLeft <= 0) {
      throw new Error("Daily swipe limit reached");
    }

    // Check super like limits
    if (direction === "up" && !swiper.isPremium && swiper.superLikesLeft <= 0) {
      throw new Error("Daily super like limit reached");
    }

    // Create swipe
    const swipe = await prisma.swipe.create({
      data: {
        swiperId,
        swipedUserId,
        direction,
      },
    });

    // Decrement swipe count
    if (!swiper.isPremium) {
      await prisma.user.update({
        where: { id: swiperId },
        data: {
          swipesLeft: { decrement: 1 },
          ...(direction === "up" && { superLikesLeft: { decrement: 1 } }),
        },
      });
    }

    // Check for match if direction is 'right' or 'up'
    if (direction === "right" || direction === "up") {
      const reverseSwipe = await prisma.swipe.findFirst({
        where: {
          swiperId: swipedUserId,
          swipedUserId: swiperId,
          direction: { in: ["right", "up"] },
        },
      });

      if (reverseSwipe) {
        // Get both users for match details
        const [user1, user2] = await Promise.all([
          prisma.user.findUnique({ where: { id: swiperId } }),
          prisma.user.findUnique({ where: { id: swipedUserId } }),
        ]);

        if (!user1 || !user2) {
          return { swipe, match: null };
        }

        // Create match
        const match = await prisma.match.create({
          data: {
            user1Id: swiperId,
            user2Id: swipedUserId,
          },
          include: {
            user1: true,
            user2: true,
          },
        });

        // Generate match details
        const sharedTech = user1.techStack.filter((tech) =>
          user2.techStack.includes(tech)
        );
        const sharedGoals = user1.lookingFor.filter((goal) =>
          user2.lookingFor.includes(goal)
        );
        const icebreakers = compatibilityService.generateIcebreakers(
          sharedTech,
          sharedGoals
        );

        return {
          swipe,
          match: {
            ...match,
            sharedTech,
            sharedGoals,
            icebreakers,
          },
        };
      }
    }

    return { swipe, match: null };
  }

  async getMatches(userId: string) {
    return await prisma.match.findMany({
      where: {
        OR: [{ user1Id: userId }, { user2Id: userId }],
        isActive: true,
      },
      include: {
        user1: {
          select: {
            id: true,
            name: true,
            profilePhoto: true,
            bio: true,
            techStack: true,
            experience: true,
          },
        },
        user2: {
          select: {
            id: true,
            name: true,
            profilePhoto: true,
            bio: true,
            techStack: true,
            experience: true,
          },
        },
      },
    });
  }
}
