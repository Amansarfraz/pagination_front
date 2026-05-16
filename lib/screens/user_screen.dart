// // lib/screens/user_screen.dart

// import 'package:flutter/material.dart';

// import '../models/user_model.dart';
// import '../services/api_service.dart';
// import '../widgets/user_tile.dart';
// //
// class UserScreen extends StatefulWidget {
//   const UserScreen({super.key});

//   @override
//   State<UserScreen> createState() => _UserScreenState();
// }

// class _UserScreenState extends State<UserScreen> {
//   List<UserModel> users = [];

//   int page = 1;

//   bool isLoading = false;

//   bool hasMoreData = true;

//   final ScrollController scrollController = ScrollController();

//   @override
//   void initState() {
//     super.initState();

//     fetchUsers();

//     scrollController.addListener(() {
//       if (scrollController.position.pixels ==
//           scrollController.position.maxScrollExtent) {
//         fetchUsers();
//       }
//     });
//   }

//   Future<void> fetchUsers() async {
//     if (isLoading || !hasMoreData) return;

//     setState(() {
//       isLoading = true;
//     });

//     try {
//       List<UserModel> newUsers = await ApiService.getUsers(page);

//       if (newUsers.isEmpty) {
//         hasMoreData = false;
//       } else {
//         page++;

//         users.addAll(newUsers);
//       }
//     } catch (e) {
//       debugPrint(e.toString());
//     }

//     setState(() {
//       isLoading = false;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Pagination")),

//       body: ListView.builder(
//         controller: scrollController,

//         itemCount: users.length + 1,

//         itemBuilder: (context, index) {
//           if (index < users.length) {
//             return UserTile(user: users[index]);
//           }

//           if (hasMoreData) {
//             return const Padding(
//               padding: EdgeInsets.all(20),

//               child: Center(child: CircularProgressIndicator()),
//             );
//           }

//           return const Padding(
//             padding: EdgeInsets.all(20),

//             child: Center(child: Text("No More Data")),
//           );
//         },
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';

import '../models/user_model.dart';
import '../services/api_service.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({super.key});

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  List<UserModel> users = [];

  int currentPage = 1;

  int totalPages = 1;

  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    fetchUsers(currentPage);
  }

  Future<void> fetchUsers(int page) async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await ApiService.getUsers(page);

      setState(() {
        users = response["users"];

        totalPages = response["total_pages"];

        currentPage = page;
      });
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

      body: Column(
        children: [
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: users.length,

                    itemBuilder: (context, index) {
                      final user = users[index];

                      return Card(
                        margin: const EdgeInsets.all(10),

                        child: ListTile(
                          leading: CircleAvatar(child: Text(user.name[0])),

                          title: Text(user.name),

                          subtitle: Text(user.email),
                        ),
                      );
                    },
                  ),
          ),

          Padding(
            padding: const EdgeInsets.all(10),

            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,

              children: [
                IconButton(
                  onPressed: currentPage > 1
                      ? () {
                          fetchUsers(currentPage - 1);
                        }
                      : null,

                  icon: const Icon(Icons.arrow_back),
                ),

                Wrap(
                  spacing: 5,

                  children: List.generate(totalPages, (index) {
                    int page = index + 1;

                    bool isActive = currentPage == page;

                    return GestureDetector(
                      onTap: () {
                        fetchUsers(page);
                      },

                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),

                        decoration: BoxDecoration(
                          color: isActive ? Colors.blue : Colors.grey.shade300,

                          borderRadius: BorderRadius.circular(8),
                        ),

                        child: Text(
                          "$page",

                          style: TextStyle(
                            color: isActive ? Colors.white : Colors.black,
                          ),
                        ),
                      ),
                    );
                  }),
                ),

                IconButton(
                  onPressed: currentPage < totalPages
                      ? () {
                          fetchUsers(currentPage + 1);
                        }
                      : null,

                  icon: const Icon(Icons.arrow_forward),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
