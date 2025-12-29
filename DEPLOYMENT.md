# AJdraw Deployment Guide

Complete guide for deploying AJdraw to production.

## Backend Deployment on Render

### Step 1: Prepare Repository

1. Create a GitHub repository with the backend folder:
   ```
   your-repo/
     ajdraw-backend/
       package.json
       server.js
       src/
       README.md
   ```

2. Ensure `.gitignore` includes:
   ```
   node_modules/
   .env
   .env.local
   ```

### Step 2: Deploy to Render

1. Go to https://render.com and sign in

2. Click "New +" and select "Web Service"

3. Connect your GitHub repository

4. Configure the service:
   - **Name**: ajdraw-backend
   - **Environment**: Node
   - **Build Command**: `npm install`
   - **Start Command**: `npm start`
   - **Plan**: Free (or paid for better uptime)

5. Add Environment Variables:
   - `NODE_ENV`: `production`
   - `PORT`: `3000`

6. Click "Create Web Service"

7. Your backend will be available at:
   ```
   https://your-app.onrender.com
   ```

### Step 3: Update Frontend

1. Update the server URL in Flutter:

   **lib/screens/connect_screen.dart:**
   ```dart
   roomService = RoomService(baseUrl: 'https://your-app.onrender.com');
   ```

   **lib/screens/drawing_screen.dart:**
   ```dart
   socketService.connect('https://your-app.onrender.com');
   ```

2. Rebuild the APK with the new URL

## Frontend: Building APK for Distribution

### Step 1: Configure App

1. Edit `pubspec.yaml`:
   ```yaml
   name: ajdraw
   description: Real-time collaborative drawing
   version: 1.0.0+1
   ```

2. Update Flutter to latest stable:
   ```bash
   flutter upgrade
   ```

### Step 2: Build Release APK

```bash
# For maximum compatibility
flutter build apk --split-per-abi

# Or single APK
flutter build apk --release
```

### Step 3: Sign APK (Optional but Recommended)

1. Create keystore:
   ```bash
   keytool -genkey -v -keystore ~/key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias key
   ```

2. Sign the APK:
   ```bash
   jarsigner -verbose -sigalg SHA1withRSA -digestalg SHA1 \
     -keystore ~/key.jks build/app/outputs/flutter-apk/app-release.apk key
   ```

### Step 4: Distribute

Generated APK location:
```
build/app/outputs/flutter-apk/app-release.apk
```

Options:
- Share via Google Drive
- Upload to GitHub Releases
- Distribute via Firebase App Distribution
- Upload to Google Play Store

## Architecture Diagram

```
┌─────────────────────────────────┐
│         Flutter App              │
│     (Multiple Devices)           │
│  Connect → Join Room Code        │
└──────────┬──────────────────────┘
           │ WebSocket + REST
           │
┌──────────▼──────────────────────┐
│    AJdraw Backend (Render)       │
│                                  │
│  Express + Socket.IO             │
│  ├─ /api/room/create            │
│  ├─ /api/room/join              │
│  └─ WebSocket Events:           │
│     ├─ join_room                │
│     ├─ draw_point               │
│     ├─ broadcast_point          │
│     └─ clear_canvas             │
│                                  │
│  RoomManager                     │
│  ├─ Room creation               │
│  ├─ User tracking               │
│  └─ Canvas state                │
│                                  │
│  DrawManager                     │
│  └─ Drawing state sync          │
└──────────────────────────────────┘
```

## Real-time Flow

### Scenario: Two Users Drawing Together

1. **User A Creates Room**
   - Calls `POST /api/room/create`
   - Receives 6-digit code (e.g., 123456)
   - WebSocket connects and joins room

2. **User B Joins Room**
   - Enters code 123456
   - Calls `POST /api/room/join`
   - WebSocket connects and emits `join_room`
   - Receives existing canvas state via `load_canvas`

3. **User A Draws a Line**
   - Touch movement emitted as `draw_point`
   - Backend stores in room canvas
   - Broadcasts via `broadcast_point` to all users
   - User B's canvas updates instantly

4. **User B Draws**
   - Same process happens
   - User A sees the drawing immediately

5. **Clear Canvas**
   - Either user clicks Clear
   - Emits `clear_canvas` to backend
   - Backend clears room state
   - Broadcasts `canvas_cleared` to all users
   - Both canvases clear instantly

## Troubleshooting

### Backend Won't Start

**Error: Cannot find module 'socket.io'**
- Solution: Run `npm install` in backend directory

**Port 3000 already in use**
- Solution: Change PORT in `.env` or kill process on port 3000

### Socket Connection Fails

**WebSocket connection timeout**
- Check backend is running and accessible
- Verify CORS is enabled in Socket.IO config
- Check firewall rules

**Connection works locally but not in production**
- Update frontend to use production URL
- Ensure Render domain is correct
- Check browser console for CORS errors

### Drawing Not Syncing

**Other user's drawings don't appear**
- Check WebSocket connection is established
- Verify both users are in same room code
- Check network connectivity

**Delay in sync**
- This is normal on slower networks
- Large stroke width = more data = more latency
- Consider reducing max stroke width if needed

## Performance Tips

- **Backend**: Render free tier has sleep after inactivity. Use paid plan for persistent servers
- **Socket.IO**: Connection limits ~ 5,000 concurrent users per Render instance
- **Canvas**: Storing 1000+ draw points may cause lag. Consider clearing periodically
- **Mobile**: Drawing quality depends on device performance

## Security Notes

- Room codes are random 6-digit numbers (1 in 900,000 collision chance)
- No authentication - anyone with code can join
- For production: Consider adding user authentication
- No data persistence - clearing browser/app clears data

## Next Steps

- Add user names/avatars
- Implement persistent drawing storage
- Add drawing export to PNG/PDF
- Multi-room support with user list
- Drawing tools (eraser, shapes, text)
- Undo/redo history
