
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Messages extends StatelessWidget {
  const Messages({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: CupertinoSearchTextField(
          decoration: BoxDecoration(color: Color(0xFFE7ECF0),borderRadius: BorderRadius.circular(25)),
        ),
      ),
      body: ListView.builder(
        itemCount: 15,
          itemBuilder: (context, index) {
        return ListTile(
          title: Text('Account 1'),
        );
      }),
    );
  }
}
