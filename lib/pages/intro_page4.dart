import 'package:flutter/material.dart';

import '../deco/themehelper.dart';
import '../widget_tree.dart';
class Page4 extends StatefulWidget {
  const Page4({Key? key}) : super(key: key);

  @override
  State<Page4> createState() => _Page4State();
}

class _Page4State extends State<Page4> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xFF00FFDE),
        body: ListView(
          children: [
            SizedBox(height:140),
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
                          image: AssetImage("assets/personal-growth.png"),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30,),
                  const SizedBox(height: 30,),
                  const SizedBox(
                    child: Text("Visit other people's profile and witness their progress",style: TextStyle(fontWeight: FontWeight.bold,
                        fontSize: 30),textAlign: TextAlign.center,),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40,),
          ],
        ),
    );
  }
}
