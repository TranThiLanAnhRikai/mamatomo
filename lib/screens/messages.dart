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
import 'package:intl/intl.dart';

class Messages extends StatefulWidget {
  @override
  _MessagesState createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Posts'),
      ),
      body: Center(
        child: Text('Posts Screen'),
      ),
    );
  }
}
