// lib/widgets/user_tile.dart

import 'package:flutter/material.dart';

import '../models/user_model.dart';

class UserTile extends StatelessWidget {
  final UserModel user;

  const UserTile({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),

      child: ListTile(
        leading: CircleAvatar(child: Text(user.name[0])),

        title: Text(user.name),

        subtitle: Text(user.email),
      ),
    );
  }
}
