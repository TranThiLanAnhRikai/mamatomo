import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:mamatomo/main.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mamatomo/screens/connect.dart';
import 'package:mamatomo/screens/momprofile.dart';
import 'package:flutter/src/widgets/basic.dart';

const users = {
  'dribbble@gmail.com': '12345',
  '1@gmail.com': '123',
};

class Signin extends StatelessWidget {
  Duration get loginTime => Duration(milliseconds: 2250);

  Future<String?> _authUser(LoginData data) {
    debugPrint('Name: ${data.name}, Password: ${data.password}');
    return Future.delayed(loginTime).then((_) {
      if (!users.containsKey(data.name)) {
        return 'User does not exist';
      }
      if (users[data.name] != data.password) {
        return 'Wrong password. Try again.';
      }
      return null;
    });
  }

  void _navigateToMomProfile(BuildContext context) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => MomProfileApp(),
      ),
    );
  }


  Future<String?> _signupUser(BuildContext context, SignupData data) {
    debugPrint('Signup Name: ${data.name}, Password: ${data.password}');
    return Future.delayed(loginTime).then((_) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => MomProfileApp(),
        ),
      );
      return null;
    });
  }

  Future<String?> _recoverPassword(String name) {
    debugPrint('Name: $name');
    return Future.delayed(loginTime).then((_) {
      if (!users.containsKey(name)) {
        return 'User does not exist';
      }
      return null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 40,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: FlutterLogin(
        headerWidget: Column(
          children: [
            Container(
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Not a member yet? ',
                    style: TextStyle(color: Colors.black, fontSize: 17),
                  ),
                  InkWell(
                    onTap: () => _navigateToMomProfile(context),
                    child: Text(
                      'Sign Up Here',
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 17,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
          ],
        ),
        title: 'MAMATOMO',
        onLogin: _authUser,
        userType: LoginUserType.name,
        //onSignup: (data) => _signupUser(context, data),
        hideForgotPasswordButton: true,
        onSubmitAnimationCompleted: () {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => UserListPage(),
            ),
          );
        },
        onRecoverPassword: _recoverPassword,
        messages: LoginMessages(
          userHint: 'Username',
        ),
      ),
    );
  }
}