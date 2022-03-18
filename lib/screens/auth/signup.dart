import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clone_project/services/auth.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final AuthService _authService = AuthService();
  String email = '';
  String password = '';
  bool isLogedIn = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 8,
        title: const Text('Authorization'),
        centerTitle: true,
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
        child: Form(
            child: Column(
          children: [
            const Text(
              'Twitter',
              style: TextStyle(fontSize: 50, color: Colors.blue),
            ),
            const SizedBox(
              height: 50,
            ),
            TextFormField(
              decoration: InputDecoration(
                  hintText: 'Input your email',
                  prefixIcon: const Icon(Icons.email),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10))),
              onChanged: (val) => setState(() {
                email = val;
              }),
            ),
            const SizedBox(
              height: 10,
            ),
            TextFormField(
              obscureText: true,
              decoration: InputDecoration(
                  hintText: 'Input your password',
                  prefixIcon: const Icon(Icons.password),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10))),
              onChanged: (val) => setState(() {
                password = val;
              }),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: ElevatedButton(
                  onPressed: () async => {
                        if (isLogedIn)
                          {
                            _authService.signIn(email, password),
                          }
                        else
                          {
                            _authService.signUp(email, password),
                          }
                      },
                  child: isLogedIn ? const Text('Sign in') : const Text('Register')),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: TextButton(
                onPressed: () {
                  setState(() {
                    isLogedIn = !isLogedIn;
                  });
                }, child: isLogedIn ? const Text('Not registered yet? Register!') : const Text('Already registered? Log in!'),
              ),
            ),
          ],
        )),
      ),
    );
  }
}
