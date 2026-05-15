// lib/services/api_service.dart

import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/user_model.dart';

class ApiService {
  // Android Emulator
  static const String baseUrl = "http://10.0.2.2:8000";

  // Physical Device
  // static const String baseUrl = "http://YOUR_IP:8000";

  static Future<List<UserModel>> getUsers(int page) async {
    final response = await http.get(
      Uri.parse("$baseUrl/users?page=$page&limit=10"),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      List users = data["data"];

      return users.map((e) => UserModel.fromJson(e)).toList();
    } else {
      throw Exception("Failed to load users");
    }
  }
}
