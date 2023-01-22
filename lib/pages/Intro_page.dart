import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../deco/themehelper.dart';
import '../widget_tree.dart';
import 'intro_page1.dart';
import 'intro_page2.dart';
import 'intro_page3.dart';
import 'intro_page4.dart';

class Introduction extends StatefulWidget {
  const Introduction({Key? key}) : super(key: key);
  @override
  State<Introduction> createState() => _IntroductionState();
}
class _IntroductionState extends State<Introduction> {
  void loadCounter() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print(_counter);
    _counter = (prefs.getBool('counter'))!;
    if (_counter = false) {
      setState(() {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const WidgetTree()));
      });
    }

  }
  void _incrementCounter() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      prefs.setBool('counter', _counter);

    });
  }

  void onChanged(bool value) {
    setState(() {
      _counter = value;

    });
  }
  bool _counter = false;
  // Initializing a Controller fore PageView
  final PageController _pageViewController = PageController(initialPage: 0); // set the initial page you want to show
  int _activePage = 0;  // will hold current active page index value
  //Create a List Holding all the Pages
  final List<Widget> _Pages = [
    const Page1(),
    const Page2(),
    const Page3(),
    const Page4(),
  ];
  @override
  void dispose() {
    super.dispose();
    _pageViewController.dispose();  // dispose the PageController
  }
  @override
  void initState() {
    loadCounter();
    super.initState();
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
          ), //creating dots at bottom
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: 140,
            child: Container(
              color: Colors.black12,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(18.0),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Row(
                              children: [
                                Checkbox(
                                    value: _counter,
                                    onChanged: (bool? value) {
                                      onChanged(value!);
                                    }),
                                const Text("Do not show this again!"),
                                const SizedBox(width:20,),
                                Container(
                                    decoration: ThemeHelper().buttonBoxDecoration(context),
                                    height: 50,
                                    width: 152,
                                    child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.lightBlue, // Background color
                                        ),
                                        onPressed: (){
                                          setState(() {
                                            _incrementCounter();
                                            print(_counter);
                                            Navigator.push(context,
                                                MaterialPageRoute(builder: (context) => const WidgetTree()));
                                          });

                                        }, child: const Text("Let's Get Started",style: TextStyle(fontSize: 20),))),
                              ],
                            ),
            ],
                    ),
                  ),
                      Row(
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
                    ],
                  ),
              ),
            ),
        ],
      ),
    );
  }
}