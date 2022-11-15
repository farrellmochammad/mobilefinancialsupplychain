import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dashboard_screen.dart';
import 'package:http/http.dart' as http;

const users = const {
  'dribbble@gmail.com': '12345',
  'hunter@gmail.com': 'hunter',
};

class LoginScreen extends StatelessWidget {
  static const routeName = '/auth';

  Duration get loginTime => Duration(milliseconds: 2250);
  final storage = const FlutterSecureStorage();

  Future<String?> _authUser(LoginData data) {
    return Future.delayed(loginTime).then((_) {
      if (!users.containsKey(data.name)) {
        return 'User not exists';
      }
      if (users[data.name] != data.password) {
        return 'Password does not match';
      }
      return null;
    });
  }

  Future<String?> _signupUser(SignupData data) {
    return Future.delayed(loginTime).then((_) {
      return null;
    });
  }

  Future<String?> _recoverPassword(String name) {

    return Future.delayed(loginTime).then((_) {
      if (!users.containsKey(name)) {
        return 'User not exists';
      }
      return 'ok';
    });
  }

  Future<String?> _login(LoginData data) async {
    return Future.delayed(loginTime).then((_) async {
      final response = await http.post(
        Uri.parse('http://localhost:2021/login'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'username': data.name,
          'password': data.password
        }),
      );

      if (response.statusCode == 200) {
        // If the server did return a 201 CREATED response,
        // then parse the JSON.
        LoginPayload payload = LoginPayload.fromJson(jsonDecode(response.body));
        if (payload.token == null){
          return 'User not exists';
        }
        await storage.write(key: 'token', value: payload.token);
        await storage.write(key: 'permission', value: payload.permission);
      } else {
        // If the server did not return a 201 CREATED response,
        // then throw an exception.
        return 'There are networking problem';

      }
      return null;
    });

  }

  @override
  Widget build(BuildContext context) {
    return FlutterLogin(
      title: 'ECORP',
      logo: AssetImage('assets/images/29072.png'),
      onLogin: _login,
      onSignup: _signupUser,
      onSubmitAnimationCompleted: () {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => DashboardScreen(),
        ));
      },
      onRecoverPassword: _recoverPassword,
    );
  }
}

class LoginPayload {
  final String token;
  final String permission;

  const LoginPayload({required this.token, required this.permission});

  factory LoginPayload.fromJson(Map<String, dynamic> json) {
    return LoginPayload(
      token: json['token'],
      permission: json['permission']
    );
  }


}