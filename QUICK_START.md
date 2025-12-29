# AJdraw Quick Start Guide

Get AJdraw running in 5 minutes.

## Local Development

### Backend Setup

```bash
cd ajdraw-backend

# Install dependencies
npm install

# Start server
npm start
```

Server runs at `http://localhost:3000`

### Frontend Setup

```bash
cd ajdraw-frontend

# Install dependencies
flutter pub get

# Run on Android emulator or physical device
flutter run
```

## Create & Join Room Flow

### Create Room
1. Open AJdraw app
2. Tap "Create Room" button
3. Get 6-digit code (e.g., 123456)
4. Share code with friend
5. Start drawing!

### Join Room
1. Open AJdraw app
2. Tap "Join Room"
3. Enter 6-digit code
4. Tap "Join"
5. Canvas syncs automatically!

## Example Room Codes

All 6-digit codes work the same way:
- User A creates room: Gets code 234567
- User B enters 234567: Joins immediately
- Drawings sync in real-time
- Room auto-deletes when last user leaves

## Testing Locally

### Test on Two Devices

1. Get your computer's local IP:
   ```bash
   # Mac/Linux
   ifconfig | grep "inet "
   
   # Windows
   ipconfig
   ```

2. Update Flutter app URLs:
   - Use `http://YOUR_IP:3000` instead of localhost

3. Run backend on computer:
   ```bash
   npm start
   ```

4. Run Flutter on two devices pointing to same IP

5. Create room on device 1, join on device 2

## Build APK

```bash
flutter build apk --release
```

APK at: `build/app/outputs/flutter-apk/app-release.apk`

## Full Deployment

See DEPLOYMENT.md for Render setup and production deployment.
