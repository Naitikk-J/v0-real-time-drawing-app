import 'package:socket_io_client/socket_io_client.dart' as IO;
import '../models/draw_point.dart';

class SocketService {
  static final SocketService _instance = SocketService._internal();

  late IO.Socket socket;
  bool isConnected = false;

  factory SocketService() {
    return _instance;
  }

  SocketService._internal();

  void connect(String serverUrl) {
    socket = IO.io(
      serverUrl,
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect()
          .build(),
    );

    socket.onConnect((_) {
      print('Connected to server');
      isConnected = true;
    });

    socket.onDisconnect((_) {
      print('Disconnected from server');
      isConnected = false;
    });

    socket.onError((error) {
      print('Socket error: $error');
    });

    socket.connect();
  }

  void joinRoom(String code) {
    socket.emit('join_room', {'code': code});
  }

  void sendDrawPoint(DrawPoint point) {
    socket.emit('draw_point', {
      'roomCode': point.room,
      'point': {
        'x': point.x,
        'y': point.y,
        'color': point.color,
        'stroke': point.stroke,
      }
    });
  }

  void clearCanvas(String roomCode) {
    socket.emit('clear_canvas', {'roomCode': roomCode});
  }

  void onBroadcastPoint(Function(DrawPoint) callback) {
    socket.on('broadcast_point', (data) {
      final point = DrawPoint(
        x: data['point']['x'],
        y: data['point']['y'],
        color: data['point']['color'],
        stroke: data['point']['stroke'],
        room: '', // Will be set in the controller
      );
      callback(point);
    });
  }

  void onLoadCanvas(Function(List<DrawPoint>) callback) {
    socket.on('load_canvas', (data) {
      List<DrawPoint> canvas = [];
      for (var item in data['canvas'] ?? []) {
        canvas.add(DrawPoint(
          x: item['x'],
          y: item['y'],
          color: item['color'],
          stroke: item['stroke'],
          room: '',
        ));
      }
      callback(canvas);
    });
  }

  void onCanvasCleared(Function() callback) {
    socket.on('canvas_cleared', (_) {
      callback();
    });
  }

  void onUserJoined(Function(int) callback) {
    socket.on('user_joined', (data) {
      callback(data['totalUsers']);
    });
  }

  void onError(Function(String) callback) {
    socket.on('error', (data) {
      callback(data['message']);
    });
  }

  void disconnect() {
    socket.disconnect();
  }
}
