import 'package:http/http.dart' as http;
import 'dart:convert';

class RoomService {
  final String baseUrl;

  RoomService({required this.baseUrl});

  Future<String?> createRoom() async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/room/create'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['code'];
      }
      return null;
    } catch (e) {
      print('Error creating room: $e');
      return null;
    }
  }

  Future<bool> joinRoom(String code) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/room/join'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'code': code}),
      );

      return response.statusCode == 200;
    } catch (e) {
      print('Error joining room: $e');
      return false;
    }
  }
}
