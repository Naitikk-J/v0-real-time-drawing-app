class DrawPoint {
  final double x;
  final double y;
  final String color;
  final double stroke;
  final String room;

  DrawPoint({
    required this.x,
    required this.y,
    required this.color,
    required this.stroke,
    required this.room,
  });

  Map<String, dynamic> toJson() {
    return {
      'x': x,
      'y': y,
      'color': color,
      'stroke': stroke,
      'room': room,
    };
  }

  factory DrawPoint.fromJson(Map<String, dynamic> json) {
    return DrawPoint(
      x: json['x'],
      y: json['y'],
      color: json['color'],
      stroke: json['stroke'],
      room: json['room'],
    );
  }
}
