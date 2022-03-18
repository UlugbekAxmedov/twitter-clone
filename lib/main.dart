import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clone_project/screens/wrapper.dart';
import 'package:flutter_clone_project/services/auth.dart';
import 'package:provider/provider.dart';
import 'models/user.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Initialize FlutterFire:
      future: _initialization,
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          //return SomethingWentWrong();
        }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
        //  UserModel userModel = UserModel(snapshot.data.toString());
          return StreamProvider<UserModel?>.value(
            value: AuthService().user,
            initialData: null,
            child: const MaterialApp(
                debugShowCheckedModeBanner: false,
                home: Wrapper()),
          );
        }

        // Otherwise, show something whilst waiting for initialization to complete
        return const Loading();
      },
    );
  }
}

class Loading extends StatelessWidget {
  const Loading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: SafeArea(
          child: SizedBox(
            width: 60,
            height: 60,
            child: Text('nimadir'),
          ),
        ),
      ),
    );
  }
}
