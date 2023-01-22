import 'package:flutter/material.dart';

import '../deco/themehelper.dart';
import '../widget_tree.dart';

class Page3 extends StatefulWidget {
  const Page3({Key? key}) : super(key: key);

  @override
  State<Page3> createState() => _Page3State();
}

class _Page3State extends State<Page3> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFF00FFDE),
        body: ListView(
        children: [
          SizedBox(height: 130),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 300,
                  width: 300,
                  child: InkWell(
                    child: Container(
                      child: const Image(
                        image: AssetImage("assets/running.png"),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30,),
                const SizedBox(height: 30,),
                const SizedBox(
                  child: Text('Create a Diet and Exercise plan with ease',style: TextStyle(fontWeight: FontWeight.bold, fontSize: 35),textAlign: TextAlign.center,),
                ),
              ],
          ),
        ),
      ])
    );
  }
}
