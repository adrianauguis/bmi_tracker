import 'package:flutter/material.dart';

import '../deco/themehelper.dart';
import '../widget_tree.dart';
class Page2 extends StatefulWidget {
  const Page2({Key? key}) : super(key: key);

  @override
  State<Page2> createState() => _Page2State();
}

class _Page2State extends State<Page2> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFF00FFDE),
        body: ListView(
            children: [
              const SizedBox(height: 230),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    SizedBox(
                      height: 200,
                      width: 200,
                      child: InkWell(
                        child: Container(
                          child: const Image(
                            image: AssetImage("assets/checking.png"),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30,),
                    const SizedBox(height: 30,),
                    const SizedBox(
                      child: Text('Here, you can check your body daily',style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28),),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 80,),
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
            ]
        ));
  }
}
