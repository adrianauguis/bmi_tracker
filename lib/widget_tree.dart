
import 'package:final_bmi/pages/home_page.dart';
import 'package:final_bmi/pages/login_register_page.dart';
import 'package:final_bmi/pages/permission_screen.dart';
import 'package:flutter/material.dart';

import 'auth.dart';

class WidgetTree extends StatefulWidget {
  const WidgetTree({Key? key}) : super(key: key);

  @override
  State<WidgetTree> createState() => _WidgetTreeState();
}

class _WidgetTreeState extends State<WidgetTree> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Auth().authStateChanges,
      builder: (context, snapshot){
        if (snapshot.hasData){
          return const HomePage();
        } else {
          return const LoginPage();
        }
      },
    );
  }
}
