import 'package:flutter/material.dart';


class AppBarComponent {

  static AppBar CreateAppBar(String title){
    return AppBar(
      backgroundColor: const Color(0xFF009688),
      title: Text(title),
    );
  }

}