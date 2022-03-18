import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clone_project/models/user.dart';
import 'package:flutter_clone_project/screens/home/feed.dart';
import 'package:flutter_clone_project/screens/home/search.dart';
import 'package:provider/provider.dart';
import '../../services/user.dart';
import 'drawer.dart';
import 'messages.dart';
import 'notifications.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final UserService _userService = UserService();
  int _currentIndex = 0;
  final List<Widget> _childrens = [
    const Feed(),
    const Search(),
    const Notifications(),
    const Messages(),
  ];

  void onTabPressed(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final Object? uid = ModalRoute.of(context)?.settings.arguments;
    return StreamProvider.value(
      value: _userService.getUserInfo(uid),
      initialData: null,
      child: Scaffold(
        appBar: AppBar(
          leading: Builder(
            builder: (context) {
              return FlatButton(
                onPressed: () => Scaffold.of(context).openDrawer(),
                child: Provider.of<UserModel?>(context)?.profileImageUrl !=
                    null ? CircleAvatar(
                  radius: 25,
                  backgroundImage: NetworkImage(
                      Provider.of<UserModel>(context).profileImageUrl!),
                ) : const Icon(Icons.person, size: 25, color: Colors.blue,),
              );
            }
          ),
          iconTheme: const IconThemeData(color: Colors.blue),
          backgroundColor: Colors.white,
          title: _currentIndex == 2
              ? const Text(
                  'Notifications',
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                )
              : _currentIndex == 3
                  ? const Text(
                      'Messages',
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    )
                  : const CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 12.0,
                      child: Image(
                        image: AssetImage('assets/images/img.png'),
                      )),
          centerTitle: true,
          actions: [
            _currentIndex == 0
                ? const Icon(
                    Icons.star_border,
                    color: Colors.blue,
                    size: 30,
                  )
                : IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.settings,
                      color: Colors.blue,
                    )),
          ],
        ),
        drawer: const Drawer(
          semanticLabel: 'Nimadir',
          child: Drawers(),
        ),
        body: _childrens[_currentIndex],
        floatingActionButton: _currentIndex == 3
            ? FloatingActionButton(
                child: const Icon(Icons.mail), onPressed: () {})
            : FloatingActionButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/add');
                },
                child: const Icon(Icons.add),
              ),
        bottomNavigationBar: SizedBox(
          height: 80,
          child: BottomNavigationBar(
            showSelectedLabels: false,
            showUnselectedLabels: false,
            selectedIconTheme:
                const IconThemeData(color: Color(0xFF4C9EEB), size: 30),
            unselectedIconTheme: const IconThemeData(color: Color(0xFF687684)),
            currentIndex: _currentIndex,
            onTap: onTabPressed,
            items: const [
              BottomNavigationBarItem(
                label: 'home',
                icon: Icon(
                  Icons.home_outlined,
                ),
              ),
              BottomNavigationBarItem(
                  label: 'search',
                  icon: Icon(
                    Icons.search,
                  )),
              BottomNavigationBarItem(
                  label: 'notification',
                  icon: Icon(
                    Icons.notifications_outlined,
                  )),
              BottomNavigationBarItem(
                  label: 'message',
                  icon: Icon(
                    Icons.email_outlined,
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
