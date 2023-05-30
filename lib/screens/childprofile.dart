import 'package:flutter/material.dart';

class ChildProfile extends StatefulWidget {
  @override
  _ChildProfileState createState() => _ChildProfileState();
}

class _ChildProfileState extends State<ChildProfile> {
  TextEditingController _nameController = TextEditingController();
  DateTime? _selectedDate; // Nullable DateTime

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Child Profile'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      IconButton(
                        iconSize: 48.0,
                        icon: Icon(Icons.male),
                        onPressed: () {
                          // Perform action for boy icon
                        },
                      ),
                      Text(
                        'Boy',
                        style: TextStyle(fontSize: 16.0),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      IconButton(
                        iconSize: 48.0,
                        icon: Icon(Icons.female),
                        onPressed: () {
                          // Perform action for girl icon
                        },
                      ),
                      Text(
                        'Girl',
                        style: TextStyle(fontSize: 16.0),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      IconButton(
                        iconSize: 48.0,
                        icon: Icon(Icons.pregnant_woman),
                        onPressed: () {
                          // Perform action for expecting icon
                        },
                      ),
                      Text(
                        'Expecting',
                        style: TextStyle(fontSize: 16.0),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 32.0),
              Text(
                'Name',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16.0),
              ),
              TextField(
                controller: _nameController,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 32.0),
              GestureDetector(
                onTap: () => _selectDate(context),
                child: Text(
                  'Birthday/Due date',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16.0),
                ),
              ),
              SizedBox(height: 8.0),
              Text(
                _selectedDate != null
                    ? '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}'
                    : '',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16.0),
              ),
              SizedBox(height: 32.0),
              ElevatedButton(
                onPressed: () {
                  // Perform action for "Add another child" button
                  showModalBottomSheet(
                    context: context,
                    builder: (BuildContext context) {
                      return ChildProfile();
                    },
                  );
                },
                child: Text('Add another child'),
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  // Perform action for "Register" button
                  Navigator.pushNamed(context, '/me');
                },
                child: Text('Register'),
              ),
              SizedBox(height: 32.0), // Increased spacing
            ],
          ),
        ),
      ),
    );
  }
}
