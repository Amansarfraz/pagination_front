// // lib/services/api_service.dart

// import 'dart:convert';

// import 'package:http/http.dart' as http;

// import '../models/user_model.dart';

// class ApiService {
//   // Android Emulator
//   static const String baseUrl = "http://127.0.0.1:8000";

//   // Physical Device
//   // static const String baseUrl = "http://YOUR_IP:8000";

//   static Future<List<UserModel>> getUsers(int page) async {
//     final response = await http.get(
//       Uri.parse("$baseUrl/users?page=$page&limit=10"),
//     );

//     if (response.statusCode == 200) {
//       final data = jsonDecode(response.body);

//       List users = data["data"];

//       return users.map((e) => UserModel.fromJson(e)).toList();
//     } else {
//       throw Exception("Failed to load users");
//     }
//   }
// }

// lib/services/api_service.dart

import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/user_model.dart';

class ApiService {
  // ================================
  // ANDROID EMULATOR
  // ================================
  static const String baseUrl = "http://10.0.2.2:8000";

  // ================================
  // PHYSICAL DEVICE
  // ================================
  // static const String baseUrl = "http://192.168.1.5:8000";

  // ================================
  // GET USERS WITH PAGINATION
  // ================================
  static Future<List<UserModel>> getUsers(int page) async {
    try {
      final response = await http.get(
        Uri.parse("$baseUrl/users?page=$page&limit=10"),
      );

      // DEBUG PRINT
      print("STATUS CODE : ${response.statusCode}");
      print("RESPONSE : ${response.body}");

      if (response.statusCode == 200) {
        final decodedData = jsonDecode(response.body);

        // Backend response:
        // {
        //   "page":1,
        //   "limit":10,
        //   "total_users":100,
        //   "data":[]
        // }

        List usersData = decodedData["data"];

        return usersData.map((user) => UserModel.fromJson(user)).toList();
      } else {
        throw Exception("Server Error : ${response.statusCode}");
      }
    } catch (e) {
      print("API ERROR : $e");

      throw Exception("Failed to fetch users");
    }
  }
}
