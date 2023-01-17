import 'package:flutter/material.dart';
import 'pages/home_page.dart';

void main(){
  const primaryColor = Color(0xFF85586F);
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      primaryColor: primaryColor,
      primarySwatch: Colors.brown,
      scaffoldBackgroundColor: const Color(0xFFDFD3C3)
    ),
    home: const HomePage(),
  ));
}