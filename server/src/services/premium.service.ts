import { PrismaClient } from "@prisma/client";
import { config } from "../config";

const prisma = new PrismaClient();

export class PremiumService {
  async createSubscription(userId: string, plan: string) {
    // TODO: Integrate with Polar.sh API
    // For now, just update user to premium
    const expiresAt = new Date();
    if (plan === "monthly") {
      expiresAt.setMonth(expiresAt.getMonth() + 1);
    } else if (plan === "yearly") {
      expiresAt.setFullYear(expiresAt.getFullYear() + 1);
    }

    const user = await prisma.user.update({
      where: { id: userId },
      data: {
        isPremium: true,
        premiumExpiresAt: expiresAt,
      },
    });

    return {
      success: true,
      user,
      message: "Premium subscription activated",
    };
  }

  async getSubscriptionStatus(userId: string) {
    const user = await prisma.user.findUnique({
      where: { id: userId },
      select: {
        isPremium: true,
        premiumExpiresAt: true,
      },
    });

    if (!user) {
      throw new Error("User not found");
    }

    // Check if premium expired
    if (user.isPremium && user.premiumExpiresAt) {
      const now = new Date();
      if (now > user.premiumExpiresAt) {
        await prisma.user.update({
          where: { id: userId },
          data: {
            isPremium: false,
            premiumExpiresAt: null,
          },
        });
        return {
          isPremium: false,
          expiresAt: null,
        };
      }
    }

    return {
      isPremium: user.isPremium,
      expiresAt: user.premiumExpiresAt,
    };
  }

  async cancelSubscription(userId: string) {
    await prisma.user.update({
      where: { id: userId },
      data: {
        isPremium: false,
        premiumExpiresAt: null,
      },
    });
  }

  async handleWebhook(event: any) {
    // TODO: Handle Polar.sh webhook events
    // - subscription.created
    // - subscription.updated
    // - subscription.cancelled
    // - payment.succeeded
    // - payment.failed
    console.log("Webhook received:", event);
  }
}
