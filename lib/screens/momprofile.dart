import 'package:flutter/material.dart';
import 'package:mamatomo/main.dart';
import 'package:mamatomo/screens/childprofile.dart';

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
  DateTime? selectedDate;
  String? uploadedImage;
  List<String> interests = [];

  Future<void> _showDatePicker(BuildContext context) async {
    final currentDate = DateTime.now();
    final initialDate = selectedDate ?? currentDate.subtract(Duration(days: 365 * 25));
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(currentDate.year - 100),
      lastDate: currentDate,
    );

    if (pickedDate != null) {
      setState(() {
        selectedDate = pickedDate;
      });
    }
  }

  void _handleImageUpload(String imagePath) {
    setState(() {
      uploadedImage = imagePath;
    });
  }

  void _toggleInterest(String interest) {
    setState(() {
      if (interests.contains(interest)) {
        interests.remove(interest);
      } else {
        interests.add(interest);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Mom's Profile"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Text(
              //   "Mom's Profile",
              //   style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              // ),
              SizedBox(height: 16),
              GestureDetector(
                onTap: () {
                  _handleImageUpload('image/path.jpg');
                },
                child: Icon(
                  Icons.image,
                  size: 48,
                ),
              ),
              SizedBox(height: 16),
              Text("Username"),
              TextFormField(
                decoration: InputDecoration(
                  hintText: "Enter your name",
                ),
              ),
              SizedBox(height: 16),
              Text("Birthday"),
              GestureDetector(
                onTap: () {
                  _showDatePicker(context);
                },
                child: TextFormField(
                  readOnly: true,
                  decoration: InputDecoration(
                    hintText: selectedDate != null
                        ? "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}"
                        : "Select your birthday",
                  ),
                ),
              ),
              SizedBox(height: 16),
              Text("Introduction"),
              TextFormField(
                maxLines: 3,
                maxLength: 100,
                decoration: InputDecoration(
                  hintText: "Let us know about you",
                ),
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Allow location"),
                  Switch(
                    value: true,
                    onChanged: (value) {
                      // Handle switch state change
                    },
                  ),
                ],
              ),
              SizedBox(height: 16),
              Text("Interests"),
              SizedBox(height: 16),
              GridView.count(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                crossAxisCount: 3,
                children: [
                  InterestTile(
                    icon: Icons.book,
                    text: "Reading",
                    isSelected: interests.contains("Reading"),
                    onTap: () => _toggleInterest("Reading"),
                  ),
                  InterestTile(
                    icon: Icons.restaurant,
                    text: "Cooking",
                    isSelected: interests.contains("Cooking"),
                    onTap: () => _toggleInterest("Cooking"),
                  ),
                  InterestTile(
                    icon: Icons.create,
                    text: "Knitting",
                    isSelected: interests.contains("Knitting"),
                    onTap: () => _toggleInterest("Knitting"),
                  ),
                  InterestTile(
                    icon: Icons.music_note,
                    text: "Dancing",
                    isSelected: interests.contains("Dancing"),
                    onTap: () => _toggleInterest("Dancing"),
                  ),
                  InterestTile(
                    icon: Icons.flight,
                    text: "Traveling",
                    isSelected: interests.contains("Traveling"),
                    onTap: () => _toggleInterest("Traveling"),
                  ),
                  InterestTile(
                    icon: Icons.directions_walk,
                    text: "Walking",
                    isSelected: interests.contains("Walking"),
                    onTap: () => _toggleInterest("Walking"),
                  ),
                  InterestTile(
                    icon: Icons.directions_run,
                    text: "Running",
                    isSelected: interests.contains("Running"),
                    onTap: () => _toggleInterest("Running"),
                  ),
                  InterestTile(
                    icon: Icons.spa,
                    text: "Doing Yoga",
                    isSelected: interests.contains("Doing Yoga"),
                    onTap: () => _toggleInterest("Doing Yoga"),
                  ),
                  InterestTile(
                    icon: Icons.book,
                    text: "Manga",
                    isSelected: interests.contains("Manga"),
                    onTap: () => _toggleInterest("Manga"),
                  ),
                  InterestTile(
                    icon: Icons.tv,
                    text: "Watch TV",
                    isSelected: interests.contains("Watch TV"),
                    onTap: () => _toggleInterest("Watch TV"),
                  ),
                  InterestTile(
                    icon: Icons.movie,
                    text: "Netflix",
                    isSelected: interests.contains("Netflix"),
                    onTap: () => _toggleInterest("Netflix"),
                  ),
                  InterestTile(
                    icon: Icons.sports,
                    text: "Sports",
                    isSelected: interests.contains("Sports"),
                    onTap: () => _toggleInterest("Sports"),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 16.0),
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ChildProfile()),
                    );
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
