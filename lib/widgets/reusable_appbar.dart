import 'package:flutter/material.dart';

Widget reusableAppbar({required String title}) {
  return AppBar(
    title: Text(title,
        style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 30,
            height: 1)),
    centerTitle: true,
    toolbarHeight: 50,
    automaticallyImplyLeading: false,
    flexibleSpace: Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(colors: [
          Color.fromRGBO(43, 123, 241, 1),
          Color.fromRGBO(15, 179, 255, .8)
        ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
    ),
  );
}
