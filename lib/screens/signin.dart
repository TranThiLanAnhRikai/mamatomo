import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:mamatomo/main.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mamatomo/screens/connect.dart';
const users = const {
  'dribbble@gmail.com': '12345',
  '1@gmail.com': '123',
};

class Signin extends StatelessWidget {
  Duration get loginTime => Duration(milliseconds: 2250);

  Future<String?>? _authUser(LoginData data) {
    debugPrint('Name: ${data.name}, Password: ${data.password}');
    return Future.delayed(loginTime).then((_) {
      if (!users.containsKey(data.name)) {
        return 'User not exists';
      }
      if (users[data.name] != data.password) {
        return 'Wrong password. Try again.';
      }
      return null;
    });
  }

  Future<String?>? _signupUser(SignupData data) {
    debugPrint('Signup Name: ${data.name}, Password: ${data.password}');
    return Future.delayed(loginTime).then((_) {
      return null;
    });
  }

  Future<String?>? _recoverPassword(String name) {
    debugPrint('Name: $name');
    return Future.delayed(loginTime).then((_) {
      if (!users.containsKey(name)) {
        return 'User not exists';
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
        icon: Icon(Icons.arrow_back)
    ,
    onPressed
    :
    (
    ) {
    Navigator.pop(context);
    },
    ),
    ),
    body: FlutterLogin(
    title: 'MAMATOMO',
    //logo: AssetImage('assets/logo.png'),
    onLogin: _authUser,
    hideForgotPasswordButton: true,

    loginProviders: <LoginProvider>[
    LoginProvider(
    icon: FontAwesomeIcons.google,
    label: 'Google',
    callback: () async {
    debugPrint('start google sign in');
    await Future.delayed(loginTime);
    debugPrint('stop google sign in');
    return null;
    },
    ),
    LoginProvider(
    icon: FontAwesomeIcons.facebookF,
    label: 'Facebook',
    callback: () async {
    debugPrint('start facebook sign in');
    await Future.delayed(loginTime);
    debugPrint('stop facebook sign in');
    return null;
    },
    ),
    ],
    onSubmitAnimationCompleted: () {
    Navigator.of(context).pushReplacement(MaterialPageRoute(
    builder: (context) => UserListPage(),
    ));
    },
    onRecoverPassword
    :
    _recoverPassword
    ,
    )
    );
  }
}