import 'package:flutter/material.dart';
import 'package:flutter_clone_project/models/user.dart';
import 'package:flutter_clone_project/screens/auth/signup.dart';
import 'package:flutter_clone_project/screens/home/homescreen.dart';
import 'package:flutter_clone_project/screens/main/posts/add.dart';
import 'package:flutter_clone_project/screens/main/profile/edit.dart';
import 'package:provider/provider.dart';

import 'main/profile/profile.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserModel?>(context);
    if (user == null) {
      return const SignUp();
    }
    // show main routes
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/' : (context) => const HomeScreen(),
        '/add': (context) => const Add(),
        '/profile': (context) => const Profile(),
        '/edit': (context) => const Edit(),
       },
    );
  }
}
