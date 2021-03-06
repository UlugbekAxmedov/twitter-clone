import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_clone_project/services/user.dart';
import 'package:image_picker/image_picker.dart';

class Edit extends StatefulWidget {
  const Edit({Key? key}) : super(key: key);

  @override
  _EditState createState() => _EditState();
}

class _EditState extends State<Edit> {

  final UserService _userService = UserService();
  File? _profileImage;
  File? _bannerImage;
  final picker = ImagePicker();
  String name = '';

  Future getImage(int type) async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null && type == 0) {
        _profileImage = File(pickedFile.path);
      }
      if (pickedFile != null && type == 1) {
        _bannerImage = File(pickedFile.path);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(actions: [
        FlatButton(onPressed: () async {
          await _userService.updateProfile(_bannerImage!, _profileImage!, name);
          Navigator.pop(context);
        }, child: const Text('save'))
      ],),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 50),
        child: Form(
          child: Column(
            children: [
              FlatButton(
                  onPressed: () => getImage(0),
                  child: _profileImage == null
                      ? const Icon(Icons.person)
                      : Image.file(
                          _profileImage!,
                          height: 80,
                        )),
              FlatButton(
                  onPressed: () => getImage(1),
                  child: _bannerImage == null
                      ? const Icon(Icons.person)
                      : Image.file(
                    _bannerImage!,
                    height: 80,
                  )),
              TextFormField(
                onChanged: (val) => setState(() {
                  name = val;
                }),
              )
            ],
          ),
        ),
      ),
    );
  }
}
