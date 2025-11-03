import { Response, NextFunction } from "express";
import { AuthRequest } from "./auth.middleware";
import { PrismaClient } from "@prisma/client";

const prisma = new PrismaClient();

// List of admin user IDs (in production, store this in database)
const ADMIN_USERS = process.env.ADMIN_USER_IDS?.split(",") || [];

export const adminMiddleware = async (
  req: AuthRequest,
  res: Response,
  next: NextFunction
) => {
  try {
    const userId = req.userId;

    if (!userId) {
      return res.status(401).json({ error: "Unauthorized" });
    }

    // Check if user is admin
    if (!ADMIN_USERS.includes(userId)) {
      return res.status(403).json({ error: "Admin access required" });
    }

    next();
  } catch (error) {
    return res.status(500).json({ error: "Internal server error" });
  }
};
