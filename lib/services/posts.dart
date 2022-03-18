import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_clone_project/models/post.dart';
import 'package:flutter_clone_project/services/user.dart';
import 'package:quiver/iterables.dart';

class PostService {
  Future savePost(text) async {
    await FirebaseFirestore.instance.collection("posts").add({
      'text': text,
      'creator': FirebaseAuth.instance.currentUser!.uid,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  Future likePost(PostModel post, bool current) async {
    if (current) {
      await FirebaseFirestore.instance
          .collection("posts")
          .doc(post.id)
          .collection('likes')
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .delete();
    }
    if (!current) {
      await FirebaseFirestore.instance
          .collection("posts")
          .doc(post.id)
          .collection('likes')
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .set({});
    }
  }

  List<PostModel> postListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return PostModel(
          id: doc.id,
          text: (doc.data() as Map)['text'] ?? '',
          creator: (doc.data() as Map)['creator'] ?? '',
          timestamp: (doc.data() as Map)['timestamp'] ?? 0);
    }).toList();
  }

  Stream<bool> getCurrentUserLike(PostModel post){
     return FirebaseFirestore.instance
        .collection("posts")
        .doc(post.id)
        .collection('likes')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .snapshots()
        .map((snapshot) {
          return snapshot.exists;
    });

  }

  Stream<List<PostModel>> getPostByUser(uid) {
    return FirebaseFirestore.instance
        .collection('posts')
        .where('creator', isEqualTo: uid)
        .snapshots()
        .map(postListFromSnapshot);
  }

  Future<List<PostModel>> getFeed() async {
    List<String> usersFollowing = await UserService()
        .getUserFollowing(FirebaseAuth.instance.currentUser?.uid);
    var splitUsersFollowing = partition<dynamic>(usersFollowing, 10);
    inspect(splitUsersFollowing);

    List<PostModel> feedList = [];
    for (int i = 0; i < splitUsersFollowing.length; i++) {
      inspect(splitUsersFollowing.elementAt(i));
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('posts')
          .where('creator', whereIn: splitUsersFollowing.elementAt(i))
          .orderBy('timestamp', descending: true)
          .get();
      feedList.addAll(postListFromSnapshot(querySnapshot));
    }
    feedList.sort((a, b) {
      var adate = a.timestamp;
      var bdate = b.timestamp;
      return bdate.compareTo(adate);
    });
    return feedList;
  }
}
