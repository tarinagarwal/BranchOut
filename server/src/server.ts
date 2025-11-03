import express from "express";
import cors from "cors";
import helmet from "helmet";
import morgan from "morgan";
import { createServer } from "http";
import { Server } from "socket.io";
import passport from "passport";
import { Strategy as GoogleStrategy } from "passport-google-oauth20";
import rateLimit from "express-rate-limit";
import { config } from "./config";
import routes from "./routes";
import { errorMiddleware } from "./middleware/error.middleware";
import { AuthService } from "./services/auth.service";
import { logger } from "./utils/logger";

const app = express();
const httpServer = createServer(app);
const io = new Server(httpServer, {
  cors: {
    origin: config.socket.corsOrigin,
    methods: ["GET", "POST"],
  },
});

const authService = new AuthService();

// Middleware
app.use(helmet());
app.use(cors({ origin: config.frontendUrl }));
app.use(morgan("combined"));
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// Rate limiting
const limiter = rateLimit({
  windowMs: 15 * 60 * 1000, // 15 minutes
  max: 100, // limit each IP to 100 requests per windowMs
});
app.use("/api", limiter);

// Passport configuration
passport.use(
  new GoogleStrategy(
    {
      clientID: config.google.clientId,
      clientSecret: config.google.clientSecret,
      callbackURL: config.google.callbackUrl,
    },
    async (accessToken, refreshToken, profile, done) => {
      try {
        const user = await authService.findOrCreateUser(profile);
        done(null, user);
      } catch (error) {
        done(error, undefined);
      }
    }
  )
);

app.use(passport.initialize());

// Routes
app.get("/health", (req, res) => {
  res.json({ status: "ok", timestamp: new Date().toISOString() });
});

app.use("/api", routes);

// Error handling
app.use(errorMiddleware);

// Socket.io
io.on("connection", (socket) => {
  logger.info(`User connected: ${socket.id}`);

  socket.on("join-match", (matchId: string) => {
    socket.join(matchId);
    logger.info(`User ${socket.id} joined match ${matchId}`);
  });

  socket.on("send-message", (data) => {
    io.to(data.matchId).emit("receive-message", data);
  });

  socket.on("typing-start", (data) => {
    socket.to(data.matchId).emit("user-typing", { userId: data.userId });
  });

  socket.on("typing-stop", (data) => {
    socket
      .to(data.matchId)
      .emit("user-stopped-typing", { userId: data.userId });
  });

  socket.on("disconnect", () => {
    logger.info(`User disconnected: ${socket.id}`);
  });
});

// Start server
httpServer.listen(config.port, () => {
  logger.info(`Server running on port ${config.port}`);
  logger.info(`Environment: ${config.nodeEnv}`);
});

export { app, io };
