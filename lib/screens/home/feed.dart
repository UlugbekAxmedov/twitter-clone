
import 'package:flutter/material.dart';
import 'package:flutter_clone_project/screens/main/posts/list.dart';
import 'package:flutter_clone_project/services/posts.dart';
import 'package:provider/provider.dart';

class Feed extends StatefulWidget {
  const Feed({Key? key}) : super(key: key);

  @override
  State<Feed> createState() => _FeedState();
}

class _FeedState extends State<Feed> {
  PostService _postService = PostService();
  @override
  Widget build(BuildContext context) {
    return FutureProvider.value(
        value: _postService.getFeed(),
        initialData: null,
        child: Scaffold(
        body: ListPosts(),
    ),
    );
  }
}
