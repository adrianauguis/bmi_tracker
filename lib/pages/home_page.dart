import 'package:final_bmi/pages/bmi_page.dart';
import 'package:final_bmi/pages/profile_page.dart';
import 'package:flutter/material.dart';


class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  // void _onItemTapped(int index) {
  //   setState(() {
  //     _selectedIndex = index;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey,
        title: const Text("BMI Tracker",
            style: TextStyle(fontWeight: FontWeight.bold)),
        leading: const Icon(Icons.balance),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.menu)),
        ],
      ),
      body: const Center(
        child: Text("Wapay sulod diri ang history"),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.grey,
        currentIndex: _selectedIndex,
        items: <BottomNavigationBarItem>[
          const BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: IconButton(
                onPressed: (){
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const BMIPage()));
                }, icon: const Icon(Icons.balance)),
            label: 'BMI',
          ),
          BottomNavigationBarItem(
            icon: IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ProfilePage(
                            selectedIndex: 2,
                          )));
                },
                icon: const Icon(Icons.account_circle)),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
