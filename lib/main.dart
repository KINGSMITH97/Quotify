import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/home.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Quotify",
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: "Satoshi",
      ),
      home: const HomePage(),
    ),
  );
}
