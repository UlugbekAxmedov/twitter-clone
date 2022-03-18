import 'package:flutter/material.dart';
import 'package:flutter_clone_project/screens/home/notifications/all.dart';
import 'package:flutter_clone_project/screens/home/notifications/mentions.dart';

class Notifications extends StatefulWidget {
  const Notifications({Key? key}) : super(key: key);

  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  int _index = 0;
  List<Widget> _notofications = [
    All(),
    Mentions(),
  ];

  void _onTab(int currentIndex) {
    setState(() {
      _index = currentIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
            appBar: TabBar(
              onTap: (index) => {
                _onTab(index)
              },
            labelColor: Colors.blue,
            unselectedLabelColor: Colors.black,
            tabs: [
              Tab(
                child: Text(
                  'All',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ),
              Tab(
                child: Text('Mentions',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              ),
            ],
          ),
          body: _notofications[_index],
        ));
  }
}
