import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/user.dart';
import '../../services/auth.dart';
import '../../services/user.dart';

class Drawers extends StatefulWidget {
  const Drawers({Key? key}) : super(key: key);

  @override
  _DrawersState createState() => _DrawersState();
}

class _DrawersState extends State<Drawers> {
  final UserService _userService = UserService();
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    final Object? uid = ModalRoute.of(context)?.settings.arguments;
    return StreamProvider.value(
      value: _userService.getUserInfo(uid),
      initialData: null,
      child: ListView(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Provider.of<UserModel?>(context)?.profileImageUrl !=
                            null
                        ? CircleAvatar(
                            radius: 30,
                            backgroundImage: NetworkImage(
                                Provider.of<UserModel>(context)
                                    .profileImageUrl!),
                          )
                        : const Icon(
                            Icons.person,
                            size: 50,
                          ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
                child: Provider.of<UserModel?>(context)?.name != null ? Text(
                  Provider.of<UserModel>(context).name,
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ) : const Text('Null'),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  '@pixsellz',
                  style: TextStyle(fontSize: 16),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
                child: Row(
                  children: const [
                    Text('216 Following'),
                    SizedBox(
                      width: 10,
                    ),
                    Text('117 Followers'),
                  ],
                ),
              ),
              const Divider(
                thickness: 1,
              ),
              ListTile(
                onTap: () {
                  Navigator.pushNamed(context, '/profile',
                      arguments: FirebaseAuth.instance.currentUser?.uid);
                },
                leading: const Icon(Icons.person),
                title: const Text('Profile'),
              ),
              const ListTile(
                leading: Icon(Icons.menu_rounded),
                title: Text('Lists'),
              ),
              const ListTile(
                leading: Icon(Icons.question_answer),
                title: Text('Topics'),
              ),
              const ListTile(
                leading: Icon(Icons.bookmark),
                title: Text('Bookmarks'),
              ),
              const ListTile(
                leading: Icon(Icons.storm),
                title: Text('Moments'),
              ),
              const Divider(
                thickness: 1,
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                child: Text('Settings and Privacy'),
              ),
              const SizedBox(
                height: 10,
              ),
              const Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 16,
                ),
                child: Text('Help Center'),
              ),
              Align(
                  alignment: Alignment.bottomRight,
                  child: IconButton(
                      onPressed: () {
                        _authService.signOut();
                      },
                      icon: const Icon(Icons.logout))),
            ],
          ),
        ],
      ),
    );
  }
}
