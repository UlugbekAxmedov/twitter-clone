import 'package:flutter/material.dart';
import 'package:flutter_clone_project/services/posts.dart';

class Add extends StatefulWidget {
  const Add({Key? key}) : super(key: key);

  @override
  _AddState createState() => _AddState();
}

class _AddState extends State<Add> {
  final PostService _postService = PostService();

  String tweet = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add tweets'),
        actions: [
          ElevatedButton(
              onPressed: () async {
                _postService.savePost(tweet);
                Navigator.pop(context);
              },
              child: const Text('Tweet'))
        ],
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 50),
        child: Form(
          child: TextFormField(
            decoration: InputDecoration(
              hintText: 'Create your awesome tweet',
              icon: const Icon(Icons.message),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10))),
            onChanged: (val) {
              setState(() {
                tweet = val;
              });
            },
          ),
        ),
      ),
    );
  }
}
