# AJdraw Backend

Real-time collaborative drawing backend built with Node.js, Express, and Socket.IO.

## Installation

```bash
npm install
```

## Environment Setup

Copy `.env.example` to `.env` and configure:

```
PORT=3000
NODE_ENV=development
```

## Running

**Development:**
```bash
npm run dev
```

**Production:**
```bash
npm start
```

## API Endpoints

### POST /api/room/create
Creates a new drawing room and returns a 6-digit code.

**Response:**
```json
{
  "success": true,
  "code": "123456"
}
```

### POST /api/room/join
Validates if a room exists.

**Request:**
```json
{
  "code": "123456"
}
```

**Response:**
```json
{
  "success": true,
  "code": "123456"
}
```

## WebSocket Events

### Client → Server

- **join_room**: `{ code: string }`
- **draw_point**: `{ roomCode: string, point: { x, y, color, stroke } }`
- **clear_canvas**: `{ roomCode: string }`

### Server → Client

- **load_canvas**: `{ canvas: [] }` - Initial canvas state
- **broadcast_point**: `{ point, userId }` - New draw point
- **canvas_cleared**: `{}` - Canvas was cleared
- **user_joined**: `{ userId, totalUsers }` - User joined

## Deployment on Render

1. Connect GitHub repository to Render
2. Create new Web Service
3. Set Build Command: `npm install`
4. Set Start Command: `npm start`
5. Add environment variables
6. Deploy

Your backend will be available at `https://your-app.onrender.com`

## Architecture

- **server.js**: Express & Socket.IO initialization
- **roomManager.js**: Room lifecycle management
- **drawManager.js**: Drawing state management
- **socket.js**: WebSocket event handlers
- **roomRoutes.js**: REST API routes
