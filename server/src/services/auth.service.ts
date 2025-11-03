import { PrismaClient } from "@prisma/client";
import jwt from "jsonwebtoken";
import { config } from "../config";

const prisma = new PrismaClient();

export class AuthService {
  async findOrCreateUser(profile: any) {
    let user = await prisma.user.findUnique({
      where: { email: profile.emails[0].value },
    });

    if (!user) {
      user = await prisma.user.create({
        data: {
          email: profile.emails[0].value,
          name: profile.displayName,
          profilePhoto: profile.photos?.[0]?.value,
          experience: "Mid",
          techStack: [],
          lookingFor: [],
        },
      });
    }

    return user;
  }

  generateToken(userId: string): string {
    return jwt.sign({ userId }, config.jwt.secret, {
      expiresIn: config.jwt.expiresIn,
    });
  }

  async getUserById(userId: string) {
    return await prisma.user.findUnique({
      where: { id: userId },
      include: {
        projects: true,
      },
    });
  }
}
