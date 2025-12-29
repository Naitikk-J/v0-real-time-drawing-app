# AJdraw Frontend - Flutter

Real-time collaborative drawing app built with Flutter.

## Prerequisites

- Flutter 3.0+
- Android Studio or Visual Studio Code with Flutter extension
- An AJdraw backend running (Node.js server)

## Setup

1. **Install dependencies:**
   ```bash
   flutter pub get
   ```

2. **Configure server URL:**
   
   Open `lib/screens/connect_screen.dart` and `lib/screens/drawing_screen.dart`
   
   Update the server URL to match your backend:
   ```dart
   roomService = RoomService(baseUrl: 'http://YOUR_SERVER_URL:3000');
   socketService.connect('http://YOUR_SERVER_URL:3000');
   ```

   For local development:
   - Use `http://10.0.2.2:3000` for Android emulator
   - Use `http://localhost:3000` for physical devices on same network

3. **Run the app:**
   ```bash
   flutter run
   ```

## Building APK

**Debug APK:**
```bash
flutter build apk
```

**Release APK:**
```bash
flutter build apk --release
```

The APK will be generated in `build/app/outputs/flutter-apk/app-release.apk`

## Features

- **Create Room**: Start a new collaborative drawing session
- **Join Room**: Enter a 6-digit code to join an existing room
- **Real-time Sync**: All drawings sync instantly between devices
- **Color Picker**: 10 beautiful colors to choose from
- **Stroke Width**: Adjust brush size with a slider
- **Clear Canvas**: Erase everything for all users
- **Undo**: Remove the last stroke
- **User Count**: See how many people are drawing

## Architecture

- **main.dart**: App entry point with Provider setup
- **screens/**: ConnectScreen (room selection), DrawingScreen (collaborative canvas)
- **controllers/**: DrawController (state management)
- **services/**: SocketService (WebSocket), RoomService (REST API)
- **widgets/**: Reusable UI components (CanvasPainter, ColorPicker, etc.)
- **models/**: DrawPoint data model
- **theme/**: App theme and colors

## Troubleshooting

**Can't connect to backend:**
- Check the server URL in the code
- Ensure backend is running
- Check firewall settings

**Drawing not syncing:**
- Check Socket.IO connection status
- Verify room code is correct
- Restart the app

**APK build fails:**
- Run `flutter clean`
- Update Flutter: `flutter upgrade`
- Check Android SDK setup: `flutter doctor`
