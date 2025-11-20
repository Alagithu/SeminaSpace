import 'package:curved_labeled_navigation_bar/curved_navigation_bar.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/chatPage.dart';
import 'package:flutter_application_1/homePage.dart';
import 'package:flutter_application_1/profilePage.dart';
import 'package:flutter_application_1/searchPage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.purple),
      ),
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _page = 0;

  List<Widget> list = [HomePage(), SearchPage(), ChatPage(), ProfilePage()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("SeminaSpace"),
        backgroundColor: Color.fromRGBO(234, 218, 240, 1),
      ),
      backgroundColor: Color.fromRGBO(234, 218, 240, 1),
      body: IndexedStack(index: _page, children: list),

      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Color.fromRGBO(234, 218, 240, 1),
        index: _page,
        items: [
          CurvedNavigationBarItem(
            child: Icon(Icons.home_outlined),
            label: "Home",
          ),
          CurvedNavigationBarItem(child: Icon(Icons.search), label: "Search"),
          CurvedNavigationBarItem(child: Icon(Icons.message), label: "Chat"),
          CurvedNavigationBarItem(
            child: Icon(Icons.perm_identity),
            label: "Profile",
          ),
        ],

        onTap: (index) {
          setState(() {
            _page = index; // ✔ Change de page sans Navigator.push
          });
        },
      ),
    );
  }
}
