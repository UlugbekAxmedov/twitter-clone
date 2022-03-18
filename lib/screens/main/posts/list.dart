import 'package:flutter/material.dart';
import 'package:flutter_clone_project/models/post.dart';
import 'package:flutter_clone_project/services/posts.dart';
import 'package:flutter_clone_project/services/user.dart';
import 'package:provider/provider.dart';

import '../../../models/user.dart';

class ListPosts extends StatefulWidget {
  const ListPosts({Key? key}) : super(key: key);

  @override
  _ListPostsState createState() => _ListPostsState();
}

class _ListPostsState extends State<ListPosts> {
  final UserService _userService = UserService();
  final PostService _postService = PostService();

  @override
  Widget build(BuildContext context) {
    List<PostModel> posts = Provider.of<List<PostModel>?>(context) ?? [];
    return ListView.builder(
        itemCount: posts.length,
        itemBuilder: (context, index) {
          final post = posts[index];
          return StreamBuilder(
              stream: _userService.getUserInfo(post.creator),
              builder:
                  (BuildContext context, AsyncSnapshot<UserModel> snapshotUser) {
                if (!snapshotUser.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return StreamBuilder(
                    stream: _postService.getCurrentUserLike(post),
                    builder: (BuildContext context,
                        AsyncSnapshot<bool> snapshotLike) {
                      if (!snapshotLike.hasData) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      return ListTile(
                        title: Padding(
                          padding: const EdgeInsets.fromLTRB(0, 15, 0, 15),
                          child: Row(
                            children: [
                              snapshotUser.data?.profileImageUrl != null
                                  ? CircleAvatar(
                                      radius: 20,
                                      backgroundImage: NetworkImage(
                                          snapshotUser.data!.profileImageUrl!),
                                    )
                                  : const Icon(
                                      Icons.person,
                                      size: 40,
                                    ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(snapshotUser.data!.name),
                              ),
                            ],
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(post.text),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Text(post.timestamp.toDate().toString()),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  IconButton(
                                      onPressed: () {
                                        _postService.likePost(post, snapshotLike.data!);
                                      },
                                      icon: Icon(
                                        snapshotLike.data! ?
                                        Icons.favorite : Icons.favorite_border,
                                        color: Colors.blue,
                                        size: 30.0,
                                      ))
                                ],
                              ),
                            ),
                            const Divider(),
                          ],
                        ),
                      );
                    });
              });
        });
  }
}
