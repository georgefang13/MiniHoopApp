import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mini_hoop_app/models/user.dart';

class StatsService {
  Future<List<User>> fetchAllUserStats() async {
    var response = await http.get(
      Uri.parse('http://18.232.148.171:5050/api/all_user_stats'),
    );

    print('Status Code: ${response.statusCode}');
    print('Response Body: ${response.body}');

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      print("data received $response");
      return data.map((json) => User.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load user stats');
    }
  }
}
