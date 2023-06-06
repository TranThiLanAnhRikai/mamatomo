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


class ChildProfile extends StatefulWidget {
  final UserModel new_user;
  final List<int> hobbies;
  final File uploadedImage;

  ChildProfile({required this.new_user, required this.hobbies, required this.uploadedImage});

  @override
  _ChildProfileState createState() => _ChildProfileState(new_user, hobbies, uploadedImage);
}

class _ChildProfileState extends State<ChildProfile> {
  UserModel new_user;
  List<int> hobbies;
  File uploadedImage;
  _ChildProfileState(this.new_user, this.hobbies, this.uploadedImage);


  bool isBoySelected = false;
  bool isGirlSelected = false;
  bool isExpectingSelected = false;
  final _nameController = TextEditingController();
  DateTime? _selectedDate;
  List<ChildModel> children = [];
  String? sub_text;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  String _calculateAge(DateTime birthday) {
    final now = DateTime.now();
    final difference = birthday.difference(now);

    if (difference.isNegative) {
      final days = now.difference(birthday).inDays + 1;
      final years = days ~/ 365;
      final months = (days % 365) ~/ 30;
      final remainingDays = (days % 365) % 30;

      if (years == 0 && months == 0) {
        return '$remainingDays days';
      } else if (years == 0) {
        return '$months months $remainingDays days';
      } else {
        return '$years years $months months $remainingDays days';
      }
    } else {
      return '${difference.inDays} more days';
    }
  }

  // int _calculateDays(DateTime birthday) {
  //   final now = DateTime.now();
  //   return birthday.difference(now).inDays.abs();
  // }


  Future<void> _createUser(UserModel user, List<ChildModel> children, List<int> hobbies, File uploadedImage) async {
    try {
      final imageBytes = await uploadedImage.readAsBytes();
      final String base64Image = base64Encode(imageBytes);

      final Map<String, dynamic> userData = {
        'name': user.name,
        'password': user.password,
        'age': user.age,
        'intro': user.intro,
        'address': user.address,
        'image': base64Image,
        'children': children.map((child) => child.toJson()).toList(),
        'hobbies': hobbies,
      };


      final jsonData = jsonEncode(userData);

      //Make a POST request to the create_user API endpoint
      final response = await http.post(
        Uri.parse('http://localhost:8000/create_user'),
        headers: {'Content-Type': 'application/json'},
        body: jsonData,
      );

      // final response = await request.send();

      if (response.statusCode == 200) {
        // User creation successful
        print('User created successfully');
      } else {
        // User creation failed
        print('Failed to create user. Error: ${response.statusCode}');
      }
    } catch (e) {
      // Exception occurred
      print('Exception occurred while creating user: $e');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        backgroundColor: AppColors.appBarColor,
        title: Text("Child Profile", style: TextStyle(color: Colors.black),),
      ),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                iconSize: 48.0,
                icon: Icon(Icons.male),
                color: isBoySelected ? Colors.blue : null,
                onPressed: () {
                  setState(() {
                    isBoySelected = true;
                    isGirlSelected = false;
                    isExpectingSelected = false;
                  });
                },
              ),
              IconButton(
                iconSize: 48.0,
                icon: Icon(Icons.female),
                color: isGirlSelected ? Colors.blue : null,
                onPressed: () {
                  setState(() {
                    isBoySelected = false;
                    isGirlSelected = true;
                    isExpectingSelected = false;
                  });
                },
              ),
              IconButton(
                iconSize: 48.0,
                icon: Icon(Icons.pregnant_woman),
                color: isExpectingSelected ? Colors.blue : null,
                onPressed: () {
                  setState(() {
                    isBoySelected = false;
                    isGirlSelected = false;
                    isExpectingSelected = true;
                  });
                },
              ),
            ],
          ),
          SizedBox(height: 16.0),
          TextField(
            controller: _nameController,
            decoration: InputDecoration(
              labelText: 'Name',
              alignLabelWithHint: true,
            ),
          ),
          SizedBox(height: 16.0),
          Text('Birthday/Due Date'),
          TextButton(
            child:
                Icon(Icons.calendar_today),
            onPressed: () {
              _selectDate(context);
            },
          ),
          SizedBox(height: 16.0),
          if (_selectedDate != null)
            Row(
              children: [
                Icon(Icons.calendar_today),
                SizedBox(width: 8.0),
                Text(_calculateAge(_selectedDate!)),
              ],
            ),
          SizedBox(height: 16.0),
          ElevatedButton(
            child: Text('Add'),
            onPressed: () {
              if (_nameController.text.isEmpty || _selectedDate == null || (!isBoySelected && !isGirlSelected && !isExpectingSelected))
              {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text("Missing Fields"),
                      content: Text("Please fill in all the fields."),
                      actions: [
                        TextButton(
                          child: Text("OK"),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  },
                );
              } else {
                setState(() {
                  final gender = isBoySelected
                      ? Gender.Boy.index
                      : isGirlSelected
                      ? Gender.Girl.index
                      : Gender.Expecting.index;
                  DateTime dateOnly = DateTime(_selectedDate!.year, _selectedDate!.month, _selectedDate!.day);
                  final newChild = ChildModel(
                    name: _nameController.text,
                    genderId: gender,
                    birthday: DateFormat('yyyyMMdd').format(dateOnly),
                  );

                  sub_text = _calculateAge(_selectedDate!);
                  children.add(newChild);
                  _nameController.clear();
                  _selectedDate = null;
                  isBoySelected = false;
                  isGirlSelected = false;
                  isExpectingSelected = false;
                });
              }
            },
          ),


          SizedBox(height: 16.0),

          for (var child in children)
            Card(
              child: ListTile(
                leading: child.genderId == Gender.Boy.index
                    ? Icon(Icons.male)
                    : child.genderId == Gender.Girl.index
                    ? Icon(Icons.female)
                    : Icon(Icons.pregnant_woman),
                title: Text(child.name),
                subtitle: Text(sub_text!),
              ),
            ),
          SizedBox(height: 16.0),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // ElevatedButton(
              //   child: Text('Add Another Child'),
              //   onPressed: () {
              //     _showAddChildDialog(context);
              //   },
              // ),

              // log(children.toList()[1].name);
              // log(hobbies.length.toString());
              // debugPrint('${hobbies.toString()}');
              ElevatedButton(
                child: Text('Register'),

                onPressed: () {
                  if (children.isEmpty) {
                    showDialog(context: context,
                        builder: (BuildContext context)  {
                      return AlertDialog(
                        title: Text("Missing fields"),
                        content: Text("Please add information about your child"),
                        actions: [
                          TextButton(
                            child: Text("OK"),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                    );
                  };
                  _createUser(new_user, children, hobbies, uploadedImage);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
