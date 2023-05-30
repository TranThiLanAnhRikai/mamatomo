import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:mamatomo/screens/signin.dart';
import 'package:mamatomo/screens/momprofile.dart';
import 'package:mamatomo/main.dart';
void main() {
  runApp(Splash());
}

class Splash extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SplashScreen(),
      routes: {
        '/register': (context) => MomProfilePage(),
        '/signin': (context) => Signin(),
      },
    );
  }
}

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/logo.png',
              width: 350,
              height: 350,
            ),
            SizedBox(height: 20),
            Text(
              'Find your next Mama friend',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/register');
              },
              child: Text(
                'Sign up to join our community',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(height: 10),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/signin');
              },
              child: Text(
                'Already have an account? Signin here',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
