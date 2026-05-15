// lib/screens/user_screen.dart

import 'package:flutter/material.dart';

import '../models/user_model.dart';
import '../services/api_service.dart';
import '../widgets/user_tile.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({super.key});

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  List<UserModel> users = [];

  int page = 1;

  bool isLoading = false;

  bool hasMoreData = true;

  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    fetchUsers();

    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        fetchUsers();
      }
    });
  }

  Future<void> fetchUsers() async {
    if (isLoading || !hasMoreData) return;

    setState(() {
      isLoading = true;
    });

    try {
      List<UserModel> newUsers = await ApiService.getUsers(page);

      if (newUsers.isEmpty) {
        hasMoreData = false;
      } else {
        page++;

        users.addAll(newUsers);
      }
    } catch (e) {
      debugPrint(e.toString());
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Pagination")),

      body: ListView.builder(
        controller: scrollController,

        itemCount: users.length + 1,

        itemBuilder: (context, index) {
          if (index < users.length) {
            return UserTile(user: users[index]);
          }

          if (hasMoreData) {
            return const Padding(
              padding: EdgeInsets.all(20),

              child: Center(child: CircularProgressIndicator()),
            );
          }

          return const Padding(
            padding: EdgeInsets.all(20),

            child: Center(child: Text("No More Data")),
          );
        },
      ),
    );
  }
}
