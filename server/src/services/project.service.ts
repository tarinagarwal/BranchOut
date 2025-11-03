import { PrismaClient } from "@prisma/client";

const prisma = new PrismaClient();

export class ProjectService {
  async getUserProjects(userId: string) {
    return await prisma.project.findMany({
      where: { userId },
      orderBy: { createdAt: "desc" },
    });
  }

  async createProject(userId: string, data: any) {
    return await prisma.project.create({
      data: {
        userId,
        title: data.title,
        description: data.description,
        githubLink: data.githubLink,
        screenshot: data.screenshot,
        techStack: data.techStack || [],
      },
    });
  }

  async updateProject(projectId: string, userId: string, data: any) {
    // Verify ownership
    const project = await prisma.project.findUnique({
      where: { id: projectId },
    });

    if (!project || project.userId !== userId) {
      throw new Error("Project not found or unauthorized");
    }

    return await prisma.project.update({
      where: { id: projectId },
      data: {
        title: data.title,
        description: data.description,
        githubLink: data.githubLink,
        screenshot: data.screenshot,
        techStack: data.techStack,
      },
    });
  }

  async deleteProject(projectId: string, userId: string) {
    // Verify ownership
    const project = await prisma.project.findUnique({
      where: { id: projectId },
    });

    if (!project || project.userId !== userId) {
      throw new Error("Project not found or unauthorized");
    }

    await prisma.project.delete({
      where: { id: projectId },
    });
  }

  async getMarketplaceProjects(userId: string) {
    // Get user to check premium status
    const user = await prisma.user.findUnique({
      where: { id: userId },
    });

    if (!user?.isPremium) {
      throw new Error("Premium subscription required");
    }

    return await prisma.projectPost.findMany({
      where: {
        userId: { not: userId },
      },
      include: {
        user: {
          select: {
            id: true,
            name: true,
            profilePhoto: true,
            experience: true,
            techStack: true,
          },
        },
        interests: {
          where: { userId },
        },
      },
      orderBy: { createdAt: "desc" },
    });
  }

  async createMarketplaceProject(userId: string, data: any) {
    // Check premium status
    const user = await prisma.user.findUnique({
      where: { id: userId },
    });

    if (!user?.isPremium) {
      throw new Error("Premium subscription required");
    }

    return await prisma.projectPost.create({
      data: {
        userId,
        title: data.title,
        description: data.description,
        techNeeded: data.techNeeded || [],
        timeCommitment: data.timeCommitment,
      },
    });
  }

  async expressInterest(projectId: string, userId: string) {
    // Check if already interested
    const existing = await prisma.projectInterest.findUnique({
      where: {
        projectId_userId: {
          projectId,
          userId,
        },
      },
    });

    if (existing) {
      throw new Error("Already expressed interest");
    }

    return await prisma.projectInterest.create({
      data: {
        projectId,
        userId,
      },
    });
  }

  async getInterestedUsers(projectId: string, ownerId: string) {
    // Verify ownership
    const project = await prisma.projectPost.findUnique({
      where: { id: projectId },
    });

    if (!project || project.userId !== ownerId) {
      throw new Error("Project not found or unauthorized");
    }

    return await prisma.projectInterest.findMany({
      where: { projectId },
      include: {
        user: {
          select: {
            id: true,
            name: true,
            profilePhoto: true,
            bio: true,
            experience: true,
            techStack: true,
          },
        },
      },
    });
  }
}
