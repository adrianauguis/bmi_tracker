import 'package:final_bmi/pages/intro_page4.dart';
import 'package:final_bmi/widget_tree.dart';
import 'package:flutter/material.dart';

import 'intro_page1.dart';
import 'intro_page2.dart';
import 'intro_page3.dart';

class Introduction extends StatefulWidget {
  const Introduction({Key? key}) : super(key: key);
  @override
  State<Introduction> createState() => _IntroductionState();
}
class _IntroductionState extends State<Introduction> {
  // Initializing a Controller fore PageView
  final PageController _pageViewController = PageController(initialPage: 0); // set the initial page you want to show
  int _activePage = 0;  // will hold current active page index value
  //Create a List Holding all the Pages
  final List<Widget> _Pages = [
    Page1(),
    Page2(),
    Page3(),
    Page4(),
  ];
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _pageViewController.dispose();  // dispose the PageController
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // will make use of Stack Widget, so that One Widget can we placed on top
      body: Stack(
        children: [
          PageView.builder(
              controller: _pageViewController,
              onPageChanged: (int index){
                setState(() {
                  _activePage = index;
                });
              },
              itemCount: _Pages.length,
              itemBuilder: (BuildContext context, int index){
                return _Pages[index];
              }
          ),
          //creating dots at bottom
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: 40,
            child: Container(
              color: Colors.black12,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List<Widget>.generate(
                    _Pages.length,
                        (index) => Padding(
                      padding: const EdgeInsets.all(10),
                      child: InkWell(
                        onTap: () {
                          _pageViewController.animateToPage(index,
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeIn);
                        },
                        child: CircleAvatar(
                          radius: 5,
                          // check if a dot is connected to the current page
                          // if true, give it a different color
                          backgroundColor: _activePage == index
                              ? Colors.greenAccent
                              : Colors.white30,
                        ),
                      ),
                    )),
              ),
            ),
          ),
        ],
      ),
    );
  }
}