import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_clone_project/models/user.dart';

class AuthService {


  FirebaseAuth auth = FirebaseAuth.instance;

  UserModel? _userFromFirebaseUser(User? user){
    return user != null ? UserModel(id: user.uid, name: user.uid, profileImageUrl: user.uid, bannerImageUrl: user.uid, email: user.uid) : null;
  }

  Stream<UserModel?> get user{
    return auth.authStateChanges().map(_userFromFirebaseUser);
  }

  Future signUp(email, password) async {
    try {
      UserCredential user = await auth.createUserWithEmailAndPassword(email: email, password: password);

      await FirebaseFirestore.instance.collection('users').doc(user.user!.uid).set({
        'name': email,
        'email': email,
      });
      _userFromFirebaseUser(user.user);

    } on FirebaseAuthException catch (e) {
      print(e);
    } catch (e) {
      print(e);
    }
  }

  Future signIn(email, password) async {
    try {
      User user = await auth.signInWithEmailAndPassword(email: email, password: password) as User;

      _userFromFirebaseUser(user);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'week-password') {
        print('The password provided is too week');
      } else if (e.code == 'email-already-in-use') {
        print('The email is already registered');
      }
    } catch (e) {
      print(e);
    }
  }

  Future signOut() async {
    try{
      return await auth.signOut();
    } catch (e) {
      print(e.toString());
    }
  }

}