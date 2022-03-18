import 'package:flutter/material.dart';
import 'package:flutter_clone_project/models/user.dart';
import 'package:provider/provider.dart';

class ListUsers extends StatefulWidget {
  const ListUsers({Key? key}) : super(key: key);

  @override
  _ListUsersState createState() => _ListUsersState();
}

class _ListUsersState extends State<ListUsers> {
  @override
  Widget build(BuildContext context) {
    final users = Provider.of<List<UserModel>?>(context);
    return ListView.builder(
        shrinkWrap: true,
        itemCount: users?.length ?? 0,
        itemBuilder: (context, index) {
          final user = users?[index];
          return InkWell(
            onTap: () => Navigator.pushNamed(context, '/profile', arguments: user?.id),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Provider.of<List<UserModel>?>(context)?[index].profileImageUrl != ''
                          ? CircleAvatar(
                              backgroundImage: NetworkImage(user!.profileImageUrl!),
                              radius: 20,
                            )
                          : const Icon(
                              Icons.person,
                              size: 30,
                            ),
                      const SizedBox(width: 10,),
                      Provider.of<List<UserModel>?>(context)?[index] != null ? Text(user!.name) : const Text('NULL'),
                    ],
                  ),
                ),
                const Divider(
                  thickness: 1,
                )
              ],
            ),
          );
        });
  }
}
