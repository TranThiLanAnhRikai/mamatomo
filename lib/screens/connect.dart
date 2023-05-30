import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class User {
  final String name;
  final String introduction;
  final String gender;

  User({
    required this.name,
    required this.introduction,
    required this.gender,
  });
}

class UserListPage extends StatefulWidget {
  @override
  _UserListPageState createState() => _UserListPageState();
}

class _UserListPageState extends State<UserListPage> {
  late List<User> userList = [];

  @override
  void initState() {
    super.initState();
    fetchUserList();
  }

  Future<void> fetchUserList() async {
    final response = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/users'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      setState(() {
        userList = data.map((item) {
          debugPrint(item['name']);
          return User(
            name: item['name'],
            introduction: item['email'],
            gender: item['gender'],
          );
        }).toList();
      });
    } else {
      throw Exception('Failed to fetch user list');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User List'),
      ),
      body: userList.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: userList.length,
        itemBuilder: (context, index) {
          final user = userList[index];
          return ListTile(
            leading: CircleAvatar(
              radius: 30,
              child: Text(user.gender == 'female' ? '♀' : '♂'),
            ),
            title: Text(user.name),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    if (user.gender == 'male') Icon(Icons.male),
                    if (user.gender == 'female') Icon(Icons.female),
                    if (user.gender == 'female') Icon(Icons.pregnant_woman),
                  ],
                ),
                Text(user.introduction),
              ],
            ),
          );
        },
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(home: UserListPage()));
}
