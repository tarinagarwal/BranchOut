import { PrismaClient } from "@prisma/client";

const prisma = new PrismaClient();

export class SwipeService {
  async createSwipe(swiperId: string, swipedUserId: string, direction: string) {
    const swipe = await prisma.swipe.create({
      data: {
        swiperId,
        swipedUserId,
        direction,
      },
    });

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
        // Create match
        const match = await prisma.match.create({
          data: {
            user1Id: swiperId,
            user2Id: swipedUserId,
          },
        });
        return { swipe, match };
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
