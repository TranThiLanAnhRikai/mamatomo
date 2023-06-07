import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'dart:developer';
import 'package:mamatomo/screens/connect.dart';

import 'package:mamatomo/constants/gender.dart';
import 'package:mamatomo/constants/color.dart';
import 'package:mamatomo/screens/edit_profile.dart';
import 'package:mamatomo/screens/messages.dart';
import 'package:mamatomo/screens/momprofile.dart';
import 'package:mamatomo/screens/posts.dart';
import 'package:mamatomo/screens/splash.dart';


class Me extends StatefulWidget {
  final Map<String, dynamic> responseBody;

  Me({required this.responseBody});

  @override
  _MeState createState() => _MeState(responseBody);
}

class _MeState extends State<Me> {
  final Map<String, dynamic> responseBody;

  _MeState(this.responseBody);

  String? imagePath;
  String dailyMessage = '';
  int currentIndex = 0;
  String? message_image_path;


  String calculateAge(DateTime birthday) {
    final now = DateTime.now();
    final difference = now.difference(birthday);

    if (difference.isNegative) {
      // Future birthday
      return '${-difference.inDays} ${-difference.inDays > 1 ? 'days' : 'day'}';
    } else {
      final years = difference.inDays ~/ 365;
      final months = (difference.inDays % 365) ~/ 30;

      if (years > 0 && months > 0) {
        return '$years ${years > 1 ? 'years' : 'year'} $months ${months > 1
            ? 'months'
            : 'month'}';
      } else if (years > 0) {
        return '$years ${years > 1 ? 'years' : 'year'}';
      } else {
        return '$months ${months > 1 ? 'months' : 'month'}';
      }
    }
  }

  @override
  void initState() {
    super.initState();
    // Make the API call when the widget is initialized
    fetchDailyMessage();
  }

  void navigateToScreen(String route) {
    Navigator.pushNamed(context, route);
  }

  Future<void> fetchDailyMessage() async {
    final children = responseBody["children"];
    final childBirthdayStr = children?.isNotEmpty == true
        ? children![0]['birthday']
        : null;

    final childBirthday = childBirthdayStr != null ? DateTime.parse(
        childBirthdayStr) : null;
    final difference = childBirthday != null ? childBirthday.difference(
        DateTime.now()) : null;
    final daysUntilBirthday = difference != null && difference.isNegative
        ? -difference!.inDays
        : difference!.inDays;

    final url = Uri.parse('http://localhost:8000/get_daily_message');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'days': -180}),
    );

    final jsonResponse = jsonDecode(response.body);
    final String message = jsonResponse['message'];
    final String? message_image = jsonResponse['image_path'] as String?;
    final imageUrl = message_image;
    final messageImagePath = imageUrl;
    debugPrint(messageImagePath);
    setState(() {
      dailyMessage = message;
    });
  }

  @override
  Widget build(BuildContext context) {
    final imageFileName = responseBody['image_path'] as String;
    final fileUrl = imageFileName;
    imagePath = fileUrl;

    final String? username = responseBody['name'];

    return Container(
      color: Colors.white, // Set the background color if needed
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () {
                      // Handle the settings button tap
                      Navigator.of(context).pushAndRemoveUntil(
                        // the new route
                        MaterialPageRoute(
                          builder: (BuildContext context) => EditProfile(responseBody: responseBody,),


                          // this function should return true when we're done removing routes
                          // but because we want to remove all other screens, we make it
                          // always return false
                        ),
                            (Route route) => false,
                      );
                    },
                    icon: Icon(Icons.settings, color: Colors
                        .blue), // Set the color of the settings icon
                  ),
                  IconButton(
                    onPressed: () {
                      // Handle the logout button tap
                      // Navigate to the main screen
                      Navigator.of(context).pushAndRemoveUntil(
                        // the new route
                        MaterialPageRoute(
                          builder: (BuildContext context) => Splash(),
                        ),
                            (Route route) => false,
                      );
                    },
                    icon: Icon(Icons.logout),
                  ),
                ],
              ),
              SizedBox(height: 10),
              if (username != null)
                Row(
                  children: [
                    CircleAvatar(
                      backgroundImage: imagePath != null ? NetworkImage(
                          imagePath!) : null,
                      radius: 30,
                    ),
                    SizedBox(width: 16),
                    Text(
                      username,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              SizedBox(height: 10),
              if (responseBody['children'] != null)
                for (var child in responseBody['children'])
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            child['name'],
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: 5),
                          if (child['gender_id'] != Gender.Expecting.index)
                            Icon(
                              child['gender_id'] == Gender.Boy.index ? Icons
                                  .male : Icons.female,
                              size: 16,
                            ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Text(
                        calculateAge(DateTime.parse(child['birthday'])),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
              SizedBox(height: 10),
              Center(
                child: Text(
                  'Message of the day',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
              ),
              SizedBox(height: 10),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: BorderSide(
                    color: Colors.pink,
                    width: 2.0,
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    dailyMessage,
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
              if(message_image_path != null)
                Image(image:  NetworkImage(message_image_path!)),
            ],
          ),
        ),
      ),
    );
  }
}

