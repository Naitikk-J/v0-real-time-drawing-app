import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/draw_controller.dart';
import '../services/socket_service.dart';
import '../models/draw_point.dart';
import '../widgets/canvas_painter.dart';
import '../widgets/color_picker.dart';
import '../widgets/stroke_slider.dart';
import '../widgets/tool_button.dart';
import '../theme/style.dart';

class DrawingScreen extends StatefulWidget {
  final String roomCode;

  const DrawingScreen({Key? key, required this.roomCode}) : super(key: key);

  @override
  State<DrawingScreen> createState() => _DrawingScreenState();
}

class _DrawingScreenState extends State<DrawingScreen> {
  late SocketService socketService;
  late DrawController drawController;

  @override
  void initState() {
    super.initState();
    socketService = SocketService();
    drawController = context.read<DrawController>();

    initializeSocket();
  }

  void initializeSocket() {
    socketService.connect('http://localhost:3000');

    socketService.onBroadcastPoint((point) {
      drawController.addPoint(DrawPoint(
        x: point.x,
        y: point.y,
        color: point.color,
        stroke: point.stroke,
        room: widget.roomCode,
      ));
    });

    socketService.onLoadCanvas((canvas) {
      for (var point in canvas) {
        drawController.addPoint(DrawPoint(
          x: point.x,
          y: point.y,
          color: point.color,
          stroke: point.stroke,
          room: widget.roomCode,
        ));
      }
    });

    socketService.onCanvasCleared(() {
      drawController.clearCanvas();
    });

    socketService.onUserJoined((count) {
      drawController.setConnectedUsers(count);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Connected users: $count')),
      );
    });

    socketService.onError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $error')),
      );
    });

    socketService.joinRoom(widget.roomCode);
  }

  void onPanUpdate(DragUpdateDetails details) {
    final point = DrawPoint(
      x: details.localPosition.dx,
      y: details.localPosition.dy,
      color: drawController.colorToString(drawController.selectedColor),
      stroke: drawController.strokeWidth,
      room: widget.roomCode,
    );

    drawController.addPoint(point);
    socketService.sendDrawPoint(point);
  }

  void clearCanvas() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Canvas?'),
        content: const Text('This will clear the canvas for everyone.'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              drawController.clearCanvas();
              socketService.clearCanvas(widget.roomCode);
              Navigator.pop(context);
            },
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        socketService.disconnect();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('AJdraw | Room ${widget.roomCode}'),
          elevation: 4,
          actions: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Center(
                child: Consumer<DrawController>(
                  builder: (context, controller, _) => Text(
                    '👥 ${controller.connectedUsers}',
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ),
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: Consumer<DrawController>(
                builder: (context, controller, _) => GestureDetector(
                  onPanUpdate: onPanUpdate,
                  child: Container(
                    color: AppTheme.backgroundColor,
                    padding: const EdgeInsets.all(16),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      elevation: 8,
                      color: Colors.white,
                      child: CustomPaint(
                        painter: CanvasPainter(points: controller.points),
                        child: Container(),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Column(
                spacing: 16,
                children: [
                  Consumer<DrawController>(
                    builder: (context, controller, _) => ColorPicker(
                      selectedColor: controller.selectedColor,
                      onColorSelected: (color) => controller.setColor(color),
                    ),
                  ),
                  Consumer<DrawController>(
                    builder: (context, controller, _) => StrokeSlider(
                      strokeWidth: controller.strokeWidth,
                      onStrokeChanged: (width) =>
                          controller.setStrokeWidth(width),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ToolButton(
                        emoji: '🧹',
                        label: 'Clear',
                        onPressed: clearCanvas,
                        backgroundColor: Color(0xFFE76F51),
                      ),
                      ToolButton(
                        emoji: '↩️',
                        label: 'Undo',
                        onPressed: () {
                          final controller =
                              context.read<DrawController>();
                          if (controller.points.isNotEmpty) {
                            controller.points.removeLast();
                            controller.notifyListeners();
                          }
                        },
                        backgroundColor: Color(0xFFF4A261),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    socketService.disconnect();
    super.dispose();
  }
}
