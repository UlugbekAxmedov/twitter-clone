import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clone_project/screens/main/posts/list.dart';
import 'package:flutter_clone_project/screens/main/profile/listusers.dart';
import 'package:flutter_clone_project/services/user.dart';
import 'package:provider/provider.dart';

class Search extends StatefulWidget {
  const Search({Key? key}) : super(key: key);

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final UserService _userService = UserService();
  String search = '';

  @override
  Widget build(BuildContext context) {
    return StreamProvider.value(
      value: _userService.queryByName(search),
      initialData: null,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: CupertinoSearchTextField(
              placeholder: 'Search users',
              onChanged: (val) => setState(() {
                search = val;
              }),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: const Color(0xFFE7ECF0),
                  borderRadius: BorderRadius.circular(25)),
            ),
          ),
          const Expanded(child: ListUsers()),
        ],
      ),
    );
  }
}
