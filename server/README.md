# BranchOut Backend

Node.js + Express + TypeScript backend for BranchOut developer matching platform.

## Setup

1. Install dependencies:

```bash
npm install
```

2. Configure environment:

```bash
cp .env.example .env
# Edit .env with your configuration
```

3. Setup database:

```bash
npm run prisma:generate
npm run prisma:migrate
```

4. Start server:

```bash
npm run dev
```

## Scripts

- `npm run dev` - Start development server with hot reload
- `npm run build` - Build TypeScript to JavaScript
- `npm start` - Start production server
- `npm run prisma:generate` - Generate Prisma client
- `npm run prisma:migrate` - Run database migrations

## Project Structure

```
src/
├── config/          # Configuration files
├── controllers/     # Request handlers
├── middleware/      # Express middleware
├── routes/          # API routes
├── services/        # Business logic
├── utils/           # Utility functions
└── server.ts        # Main server file
```
