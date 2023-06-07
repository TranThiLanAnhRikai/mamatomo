import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'dart:developer';
import 'package:mamatomo/screens/connect.dart';

import 'package:mamatomo/constants/gender.dart';
import 'package:mamatomo/constants/color.dart';
import 'package:mamatomo/screens/messages.dart';
import 'package:mamatomo/screens/momprofile.dart';
import 'package:mamatomo/screens/posts.dart';
import 'package:mamatomo/screens/me.dart';

// void main() {
//   runApp(MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: Home(responseBody),
//     );
//   }
// }

class Home extends StatefulWidget {
  final Map<String, dynamic> responseBody;
  Home({required this.responseBody});
  @override
  _HomeState createState() => _HomeState(responseBody);
}

class _HomeState extends State<Home> {
  final Map<String, dynamic> responseBody;
  _HomeState(this.responseBody);
  int currentIndex = 0;
  late List<Widget> pages;
  late List<String> titles;

  @override
  void initState() {
    super.initState();
    pages = [Me(responseBody: responseBody,), Messages(), Connect(), Posts()];
    titles = ["Me", "Messages", "Connect", "Posts"];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[currentIndex],

      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.black,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: titles[currentIndex],
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message),
            label: titles[currentIndex],
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.people),
              label: titles[currentIndex],
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.post_add),
              label: titles[currentIndex],
          ),

        ],
        type: BottomNavigationBarType.shifting,
        currentIndex: currentIndex,
        onTap: (value) {
          setState(() {
            currentIndex = value;
          });
        },
      ),
    );
  }
}