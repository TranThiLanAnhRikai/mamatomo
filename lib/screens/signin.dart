import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:mamatomo/main.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mamatomo/screens/connect.dart';
import 'package:mamatomo/screens/momprofile.dart';
import 'package:flutter/src/widgets/basic.dart';
import 'package:mamatomo/constants/color.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class Signin extends StatefulWidget {
  @override
  _SigninState createState() => _SigninState();
}

class _SigninState extends State<Signin> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false;
  String? _errorMessage;
  bool _obscurePassword = true;
  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _usernameController.addListener(_clearErrorMessage);
    _passwordController.addListener(_clearErrorMessage);
  }

  void _clearErrorMessage() {
    setState(() {
      _errorMessage = null;
    });
  }

  Future<void> _login(String username) async {

    if (_usernameController.text.isEmpty || _passwordController.text.isEmpty) {
      _clearErrorMessage();
      return;
    }
    final response = await http.get(Uri.parse('http://localhost:8000/get_user?username=$username'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseBody = jsonDecode(response.body);
      final String storedPassword = responseBody['pw'] as String;
      // Compare the password
      if (_passwordController.text == storedPassword) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MomProfilePage()),
        );
      } else {
        _errorMessage = "Wrong password";
        debugPrint(_errorMessage);
      }
      // Proceed with the remaining logic (e.g., navigation)
    } else {
      _errorMessage = "No user found";
    }
    setState(() {});
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondaryColor,
      appBar: AppBar(
        toolbarHeight: 40,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Mamatomo',
              style: TextStyle(
                fontSize: 34,
                fontWeight: FontWeight.bold,
              ),
            ),
            Card(
              elevation: 10,
              margin: EdgeInsets.all(20),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Padding(
                  padding: EdgeInsets.all(36),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        // Username field with icon
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(
                              color: Colors.black,
                              width: 2,
                            ),
                          ),
                          child: TextFormField(
                            controller: _usernameController,
                            decoration: InputDecoration(
                              labelText: 'Username',
                              prefixIcon: Icon(Icons.person),
                              border: InputBorder.none,
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter your username';
                              }
                              return null;
                            },
                          ),
                        ),
                        if (_errorMessage != null)
                          Padding(
                            padding: EdgeInsets.only(left: 16, top: 4),
                            child: Text(
                              _errorMessage!,
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        SizedBox(height: 10),
                        // Password field with obscure icon
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(
                              color: Colors.black,
                              width: 2,
                            ),
                          ),
                          child: TextFormField(
                            controller: _passwordController,
                            obscureText: true,
                            decoration: InputDecoration(
                              labelText: 'Password',
                              prefixIcon: Icon(Icons.lock),
                              suffixIcon: IconButton(
                                icon: Icon(Icons.visibility),
                                onPressed: () {
                                  setState(() {
                                    _obscurePassword = !_obscurePassword;
                                  });
                                },
                              ),
                              border: InputBorder.none,
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter your password';
                              }
                              return null;
                            },
                          ),
                        ),
                        SizedBox(height: 20),
                        // Sign In button
                        ElevatedButton(
                          onPressed: () => _login(_usernameController.text),

                          child: Text('Sign In'),
                        ),

                      ],
                    ),
                  ),
                ),
              ),
            ),
            Container(
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Not a member yet? ',
                    style: TextStyle(color: Colors.black, fontSize: 20),
                  ),
                  InkWell(
                    onTap: () {
                      // Navigate to Sign Up screen
                    },
                    child: Text(
                      'Sign Up Here',
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}