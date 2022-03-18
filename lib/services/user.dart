import 'dart:collection';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_clone_project/models/user.dart';
import 'package:flutter_clone_project/services/utils.dart';

class UserService {
  UtilsService _utilsService = UtilsService();

  List<UserModel> _userListFromQuerySnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return UserModel(
        id: doc.id,
        name: (doc.data() as Map)['name'] ?? '',
        profileImageUrl: (doc.data() as Map)['profilerImageUrl'] ?? '',
        bannerImageUrl: (doc.data() as Map)['bannerImageUrl'] ?? '',
        email: (doc.data() as Map)['email'] ?? '',
      );
    }).toList();
  }

  UserModel _userFromFirebaseSnapshot(DocumentSnapshot? snapshot) {
    return snapshot != null
        ? UserModel(
            id: snapshot.id,
            bannerImageUrl: (snapshot.data() as Map)['bannerImageUrl'],
            profileImageUrl: (snapshot.data() as Map)['profilerImageUrl'],
            name: (snapshot.data() as Map)['name'].toString(),
            email: (snapshot.data() as Map)['email'].toString())
        : null as UserModel;
  }

  Stream<UserModel> getUserInfo(uid) {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .snapshots()
        .map(_userFromFirebaseSnapshot);
  }

  Future<List<String>> getUserFollowing(uid) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('following')
        .get();
    final users = querySnapshot.docs.map((doc) => doc.id).toList();
    return users;
  }

  Stream<List<UserModel>> queryByName(search) {
    return FirebaseFirestore.instance
        .collection('users')
        .orderBy('name')
        .startAt([search])
        .endAt([search + '\uf8ff'])
        .limit(20)
        .snapshots()
        .map(_userListFromQuerySnapshot);
  }

  Stream<bool?> isFollowing(uid, otherId) {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('following')
        .doc(otherId)
        .snapshots()
        .map((snapshot) {
      return snapshot.exists;
    });
  }

  Future<void> followUser(uid) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .collection('following')
        .doc(uid)
        .set({});

    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('followers')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .set({});
  }

  Future<void> unFollowUser(uid) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .collection('following')
        .doc(uid)
        .delete();

    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('followers')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .delete();
  }

  Future<void> updateProfile(
      File? _bannerImage, File? _profileImage, String userName) async {
    String? bannerImageUrl = '';
    String? profileImageUrl = '';

    if (_bannerImage != null) {
      // save the image to storage
      bannerImageUrl = (await _utilsService
          .uploadFile(_bannerImage,
              'user/profile/${FirebaseAuth.instance.currentUser?.uid}/banner')
          .whenComplete(() => String));
    }
    if (_profileImage != null) {
      // save the image to storage
      profileImageUrl = (await _utilsService
          .uploadFile(_profileImage,
              'user/profile/${FirebaseAuth.instance.currentUser?.uid}/profile')
          .whenComplete(() => String));
    }

    Map<String, Object> data = HashMap();
    if (userName != '') data['name'] = userName;
    if (bannerImageUrl != null) data['bannerImageUrl'] = bannerImageUrl;
    if (profileImageUrl != null) data['profilerImageUrl'] = profileImageUrl;

    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update(data);
  }
}
