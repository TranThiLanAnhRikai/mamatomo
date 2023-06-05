import 'package:flutter/material.dart';
import 'package:mamatomo/main.dart';
import 'package:mamatomo/screens/childprofile.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mamatomo/models/user.dart';
import 'dart:io';
import 'package:geolocator/geolocator.dart';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:mamatomo/hobby.dart';
import 'dart:typed_data';
import 'package:mamatomo/constants/color.dart';



void main() => runApp(MomProfileApp());



class MomProfileApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MomProfilePage(),
    );
  }
}

class MomProfilePage extends StatefulWidget {
  @override
  _MomProfilePageState createState() => _MomProfilePageState();
}

class _MomProfilePageState extends State<MomProfilePage> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _introController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();

  File? uploadedImage;
  List<int> hobbies = [];
  int _currentAge = 25;
  String? _address = "";
  bool locationEnabled = false;

  Future<http.Response> createUser(UserModel user, List<int> hobbies) async {
    final url = Uri.parse('http://localhost:8000/users');
    final headers = <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    };

    final body = jsonEncode({
      'name': user.name,
      'password': user.password,
      'age': user.age,
      'intro': user.intro,
      'address': user.address,
      'imageBytes': user.imageBytes,
      'hobbies': hobbies,
    });

    final response = await http.post(url, headers: headers, body: body);
    return response;
  }
  void _navigateToChildProfile() {
    final new_user = UserModel(
      name: _nameController.text,
      password: _passwordController.text,
      age: _currentAge,
      intro: _introController.text,
      address: _address,
      imageBytes: uploadedImage != null ? uploadedImage!.readAsBytesSync() : Uint8List(0),
    );
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ChildProfile(new_user: new_user, hobbies: hobbies, uploadedImage: uploadedImage!)),
    );
  }


  Future<String?> getAddress(double latitude, double longitude) async {
    final apiKey = 'AIzaSyBQk6u-RmuHWR2A6HDytDi1WXl4vtwDIxs';
    final url =
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=$latitude,$longitude&key=$apiKey';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final results = data['results'];
      debugPrint("results");
      debugPrint(results.toString());
      if (results.length > 0) {
        final formattedAddress = results[0]['formatted_address'];
        return formattedAddress;
        debugPrint("data");
        debugPrint(formattedAddress);
      }

    }

    //return null;
  }



  void _handleImageUpload() async {
    final picker = ImagePicker();
    final pickedImage = await picker.getImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      File imageFile = File(pickedImage.path);
      setState(() {
        uploadedImage = imageFile;

      });
    }
  }




  void _handleImageTap() {
    // Open image picker when the uploaded image is tapped
    _handleImageUpload();
  }

  void _toggleInterest(int hobbyIndex) {
    setState(() {
      if (hobbies.contains(hobbyIndex)) {
        hobbies.remove(hobbyIndex);
      } else {
        hobbies.add(hobbyIndex);
      }
    });
  }

  void getUserLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are disabled
      return;
    }

    // Check for location permission
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        // Location permission denied
        return;
      }
    }

    // Retrieve the user's current location
    final currentPosition = await Geolocator.getCurrentPosition();
    _address = await getAddress(
      currentPosition.latitude,
      currentPosition.longitude,
    );

    // Store the address in your registration form or user profile
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.appBarColor,
        title: Text("Mom's Profile", style: TextStyle(color: Colors.black),),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  if (uploadedImage != null)
                    GestureDetector(
                      onTap: _handleImageTap,
                      child: CircleAvatar(
                        radius: 24,
                        backgroundImage: FileImage(uploadedImage!),
                      ),
                    )
                  else
                    ElevatedButton(
                      onPressed: _handleImageUpload,
                      child: CircleAvatar(
                        radius: 24,
                        child: Icon(Icons.image, size: 48),
                      ),
                    ),
                ],
              ),
              // if (uploadedImage == null && uploadImageFlag == true)
              //   Container(
              //     child: Text(
              //       "Add an image for your profile avatar",
              //       style: TextStyle(
              //         color: Colors.red,
              //       ),
              //     ),
              //   ),
              SizedBox(height: 16),
              Text("Username"),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  hintText: "Enter your name",
                ),
              ),
              SizedBox(height: 16),
              Text("Password"),
              TextFormField(
                obscureText: true,
                controller: _passwordController,
                decoration: InputDecoration(
                  hintText: "Password",
                ),
              ),
              SizedBox(height: 16),
              Text("Confirm Password"),
              TextFormField(
                obscureText: true,
                controller: _confirmPasswordController,
                decoration: InputDecoration(
                  hintText: "Confirm Password",
                ),
              ),
              SizedBox(height: 16),
              if (_passwordController.text.isNotEmpty &&
                  _confirmPasswordController.text.isNotEmpty &&
                  _passwordController.text != _confirmPasswordController.text)
                Container(
                  child: Text(
                    "Password doesn't match",
                    style: TextStyle(
                      color: Colors.red,
                    ),
                  ),
                ),
              Column(
                children: <Widget>[
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Age: $_currentAge',
                    ),
                  ),
                  NumberPicker(
                    itemHeight: 30,
                    axis: Axis.horizontal,
                    value: _currentAge,
                    minValue: 0,
                    maxValue: 100,
                    onChanged: (value) => setState(() => _currentAge = value),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Text("Introduction"),
              TextFormField(
                controller: _introController,
                maxLines: 3,
                maxLength: 100,
                decoration: InputDecoration(
                  hintText: "Let us know about you",
                ),
              ),
              if (_introController == null)
                Container(
                  child: Text(
                    "Let us know about you",
                    style: TextStyle(
                      color: Colors.red,
                    ),
                  ),
                ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Allow location"),
                  Switch(
                    value: locationEnabled,
                    onChanged: (value) {
                      setState(() {
                        locationEnabled = value;
                        if (locationEnabled) {
                          getUserLocation();
                        }
                      });
                    },
                  ),
                ],
              ),
              // if (locationEnabled == false && locationEnabledFlag == true)
              //   Container(
              //     child: Text(
              //       "Allow location to find friends near you",
              //       style: TextStyle(
              //         color: Colors.red,
              //       ),
              //     ),
              //   ),
              Text("Hobbies"),
              SizedBox(height: 16),
              GridView.count(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                crossAxisCount: 3,
                children: [
                  InterestTile(
                    icon: Icons.book,
                    text: "Reading",
                    isSelected: hobbies.contains(Hobby.Reading.index),
                    onTap: () => _toggleInterest(Hobby.Reading.index),
                  ),
                  InterestTile(
                    icon: Icons.restaurant,
                    text: "Cooking",
                    isSelected: hobbies.contains(Hobby.Cooking.index),
                    onTap: () => _toggleInterest(Hobby.Cooking.index),
                  ),
                  InterestTile(
                    icon: Icons.create,
                    text: "Knitting",
                    isSelected: hobbies.contains(Hobby.Knitting.index),
                    onTap: () => _toggleInterest(Hobby.Knitting.index),
                  ),
                  InterestTile(
                    icon: Icons.music_note,
                    text: "Dancing",
                    isSelected: hobbies.contains(Hobby.Dancing.index),
                    onTap: () => _toggleInterest(Hobby.Dancing.index),
                  ),
                  InterestTile(
                    icon: Icons.flight,
                    text: "Traveling",
                    isSelected: hobbies.contains(Hobby.Traveling.index),
                    onTap: () => _toggleInterest(Hobby.Traveling.index),
                  ),
                  InterestTile(
                    icon: Icons.directions_walk,
                    text: "Walking",
                    isSelected: hobbies.contains(Hobby.Walking.index),
                    onTap: () => _toggleInterest(Hobby.Walking.index),
                  ),
                  InterestTile(
                    icon: Icons.directions_run,
                    text: "Running",
                    isSelected: hobbies.contains(Hobby.Running.index),
                    onTap: () => _toggleInterest(Hobby.Running.index),
                  ),
                  InterestTile(
                    icon: Icons.spa,
                    text: "Doing Yoga",
                    isSelected: hobbies.contains(Hobby.DoingYoga.index),
                    onTap: () => _toggleInterest(Hobby.DoingYoga.index),
                  ),
                  InterestTile(
                    icon: Icons.book,
                    text: "Manga",
                    isSelected: hobbies.contains(Hobby.Manga.index),
                    onTap: () => _toggleInterest(Hobby.Manga.index),
                  ),
                  InterestTile(
                    icon: Icons.tv,
                    text: "Watch TV",
                    isSelected: hobbies.contains(Hobby.WatchTV.index),
                    onTap: () => _toggleInterest(Hobby.WatchTV.index),
                  ),
                  InterestTile(
                    icon: Icons.movie,
                    text: "Netflix",
                    isSelected: hobbies.contains(Hobby.Netflix.index),
                    onTap: () => _toggleInterest(Hobby.Netflix.index),
                  ),
                  InterestTile(
                    icon: Icons.sports,
                    text: "Sports",
                    isSelected: hobbies.contains(Hobby.Sports.index),
                    onTap: () => _toggleInterest(Hobby.Sports.index),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 16.0),
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (_nameController.text.isEmpty ||
                        _passwordController.text.isEmpty ||
                        _introController.text.isEmpty ||
                        _confirmPasswordController.text.isEmpty ||
                        uploadedImage == null
                        ) {
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
                    } else if (!locationEnabled) {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text("Location Not Enabled"),
                            content: Text("Please allow location to find friends near you."),
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
                    } else if (hobbies.isEmpty) {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text("No hobbies chosen"),
                            content: Text("Please choose at least one hobby"),
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
                    }
                    else {
                      _navigateToChildProfile();
                    }
                  },
                  child: Text("Next"),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}

class InterestTile extends StatelessWidget {
  final IconData icon;
  final String text;
  final bool isSelected;
  final VoidCallback onTap;

  InterestTile({
    required this.icon,
    required this.text,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Icon(icon, size: 32),
          SizedBox(height: 8),
          Text(
            text,
            style: TextStyle(
              color: isSelected ? Colors.blue : Colors.black,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}

