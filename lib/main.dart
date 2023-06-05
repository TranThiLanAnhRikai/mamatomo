import 'package:flutter/material.dart';
import 'package:mamatomo/screens/splash.dart';
import 'package:mamatomo/screens/momprofile.dart';
import 'package:mamatomo/screens/signin.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mamatomo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.red,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Signin(),
    );
  }
}