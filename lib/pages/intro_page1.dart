import 'package:flutter/material.dart';

import '../deco/themehelper.dart';
import '../widget_tree.dart';

class Page1 extends StatefulWidget {
  const Page1({Key? key}) : super(key: key);

  @override
  State<Page1> createState() => _Page1State();
}

class _Page1State extends State<Page1> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF00FFDE),
      body: ListView(
        children: [
          const SizedBox(height: 100,),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                SizedBox(
                  height: 400,
                  width: 400,
                  child: InkWell(
                    child: Container(
                      child: const Image(
                        image: AssetImage("assets/splash logo.png"),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30,),
                const SizedBox(height: 30,),
                const SizedBox(
                  child: Text('Welcome to Fitnemesiss',style: TextStyle(fontWeight: FontWeight.bold, fontSize: 38),),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 60),
                Container(
                  decoration: ThemeHelper().buttonBoxDecoration(context),
                  height: 40,
                  width: 70,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.lightBlue, // Background color
                      ),
                      onPressed: (){
                        setState(() {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) => const WidgetTree()));
                        });
                      }, child: Text('Skip',style: TextStyle(fontSize: 20),))),
              ],
            ),
          )
        ],
      ),
    );
  }
}