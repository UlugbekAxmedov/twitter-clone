import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clone_project/models/user.dart';
import 'package:flutter_clone_project/services/posts.dart';
import 'package:flutter_clone_project/services/user.dart';
import 'package:provider/provider.dart';

import '../posts/list.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final PostService _postService = PostService();
  final UserService _userService = UserService();

  @override
  Widget build(BuildContext context) {
    final Object? uid = ModalRoute.of(context)?.settings.arguments;
    return MultiProvider(
        providers: [
          StreamProvider.value(
              value: _userService.isFollowing(
                  FirebaseAuth.instance.currentUser?.uid, uid),
              initialData: null),
          StreamProvider.value(
              value: _postService.getPostByUser(uid), initialData: null),
          StreamProvider.value(
              value: _userService.getUserInfo(uid), initialData: null),
        ],
        child: Scaffold(
          body: DefaultTabController(
            length: 2,
            child: NestedScrollView(
              headerSliverBuilder: (context, _) {
                return [
                  SliverAppBar(
                    floating: false,
                    pinned: true,
                    expandedHeight: 120,
                    flexibleSpace: FlexibleSpaceBar(
                      background: Provider.of<UserModel?>(context)
                                  ?.bannerImageUrl !=
                              null
                          ? Image.network(
                              Provider.of<UserModel>(context).bannerImageUrl!,
                              fit: BoxFit.cover,
                            )
                          : null,
                    ),
                  ),
                  SliverList(
                      delegate: SliverChildListDelegate([
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 20),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Provider.of<UserModel?>(context)
                                          ?.profileImageUrl !=
                                      null
                                  ? CircleAvatar(
                                      backgroundImage: NetworkImage(
                                          Provider.of<UserModel>(context)
                                              .profileImageUrl!),
                                      radius: 30,
                                    )
                                  : const Icon(
                                      Icons.person,
                                      size: 50,
                                    ),
                              if (FirebaseAuth.instance.currentUser?.uid == uid)
                                TextButton(
                                    onPressed: () {
                                      Navigator.pushNamed(context, '/edit');
                                    },
                                    child: const Text('Edit Profile'))
                              else if (FirebaseAuth.instance.currentUser?.uid !=
                                      uid &&
                                  !(Provider.of<bool?>(context) ?? false))
                                TextButton(
                                    onPressed: () {
                                      _userService.followUser(uid);
                                    },
                                    child: const Text(
                                      'Follow',
                                      style: TextStyle(fontSize: 20),
                                    ))
                              else if (FirebaseAuth.instance.currentUser?.uid !=
                                      uid &&
                                 (Provider.of<bool?>(context) ?? false))
                                TextButton(
                                    onPressed: () {
                                      _userService.unFollowUser(uid);
                                    },
                                    child: const Text(
                                      'Unfollow',
                                      style: TextStyle(fontSize: 20),
                                    )),
                            ],
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child:
                                  Provider.of<UserModel?>(context)?.name != null
                                      ? Text(
                                          Provider.of<UserModel>(context).name,
                                          style: const TextStyle(fontSize: 24),
                                        )
                                      : const Text('NULL'),
                            ),
                          )
                        ],
                      ),
                    )
                  ]))
                ];
              },
              body: const ListPosts(),
            ),
          ),
        ));
  }
}
