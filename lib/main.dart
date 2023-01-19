import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'pages/home_page.dart';

Future main()async{
  const primaryColor = Color(0xFF85586F);
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

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