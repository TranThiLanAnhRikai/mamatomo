import 'package:flutter/material.dart';
import 'package:mamatomo/models/user.dart';
import 'package:mamatomo/screens/momprofile.dart';
import 'package:mamatomo/models/child.dart';
import 'package:mamatomo/constants/gender.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'dart:developer';
import 'dart:async';
import 'dart:io';
import 'package:http_parser/http_parser.dart';
import 'package:mamatomo/constants/color.dart';

class Home extends StatelessWidget {
  final Map<String, dynamic> user;

  Home({required this.user});

  @override
  Widget build(BuildContext context) {
    return _HomeState(user: user);
  }
}

class _HomeState extends StatelessWidget {
  final Map<String, dynamic> user;

  _HomeState({required this.user});

  @override
  Widget build(BuildContext context) {
    // Implement the UI for the Home screen
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: Column(
        children: [
          // Text('User ID: ${user['id']}'),
          // Text('Username: ${user['name']}'),
          // Text(user['hobbies']),
          // Text(user['image_path']),
          // Text(user['children']),
          // Display other user information
        ],
      ),
    );
  }
}
