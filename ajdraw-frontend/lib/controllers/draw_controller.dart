import 'package:flutter/material.dart';
import '../models/draw_point.dart';

class DrawController extends ChangeNotifier {
  List<DrawPoint> points = [];
  Color selectedColor = Color(0xFFFF6B9D);
  double strokeWidth = 4.0;
  String roomCode = '';
  int connectedUsers = 0;

  void setRoomCode(String code) {
    roomCode = code;
    notifyListeners();
  }

  void addPoint(DrawPoint point) {
    points.add(point);
    notifyListeners();
  }

  void clearCanvas() {
    points.clear();
    notifyListeners();
  }

  void setColor(Color color) {
    selectedColor = color;
    notifyListeners();
  }

  void setStrokeWidth(double width) {
    strokeWidth = width;
    notifyListeners();
  }

  void setConnectedUsers(int count) {
    connectedUsers = count;
    notifyListeners();
  }

  String colorToString(Color color) {
    return '${color.value.toRadixString(16).padLeft(8, '0')}';
  }

  Color stringToColor(String colorString) {
    return Color(int.parse('ff$colorString', radix: 16));
  }
}
