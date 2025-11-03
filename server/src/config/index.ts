import dotenv from "dotenv";

dotenv.config();

export const config = {
  port: process.env.PORT || 3000,
  nodeEnv: process.env.NODE_ENV || "development",
  databaseUrl: process.env.DATABASE_URL!,
  jwt: {
    secret: process.env.JWT_SECRET!,
    expiresIn: process.env.JWT_EXPIRES_IN || "7d",
  },
  google: {
    clientId: process.env.GOOGLE_CLIENT_ID!,
    clientSecret: process.env.GOOGLE_CLIENT_SECRET!,
    callbackUrl: process.env.GOOGLE_CALLBACK_URL!,
  },
  frontendUrl: process.env.FRONTEND_URL || "http://localhost:3000",
  uploadthing: {
    secret: process.env.UPLOADTHING_SECRET!,
    appId: process.env.UPLOADTHING_APP_ID!,
  },
  github: {
    token: process.env.GITHUB_TOKEN!,
  },
  polar: {
    apiKey: process.env.POLAR_API_KEY!,
    webhookSecret: process.env.POLAR_WEBHOOK_SECRET!,
  },
  socket: {
    corsOrigin: process.env.SOCKET_CORS_ORIGIN || "http://localhost:3000",
  },
};
