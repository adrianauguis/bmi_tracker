import 'package:final_bmi/provider/api_provider.dart';
import 'package:final_bmi/model/bmi_model.dart';
import 'package:final_bmi/pages/bmi_page.dart';
import 'package:final_bmi/pages/home_page.dart';
import 'package:flutter/material.dart';


class ProfilePage extends StatefulWidget {
  final int? selectedIndex;

  const ProfilePage({Key? key, this.selectedIndex}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late Future<List<BmiModel>> dataList;

  loadFromApi()async{
    var apiProvider = TestApiProvider();
    await apiProvider.getAllTest();
  }

  @override
  void initState() {

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Container(
            alignment: Alignment.center,
            height: 100,
            color: Colors.red,
            child: const Icon(Icons.account_circle),
          ),
          Container(
              alignment: Alignment.center,
              height: 250,
              color: Colors.green,
              child: const Text("Details ni dari",
                  style: TextStyle(color: Colors.white))
          ),
          Container(
              alignment: Alignment.center,
              height: 200,
              color: Colors.blue,
              child: const Text("Wapako ka balo unsa ni dari",
                  style: TextStyle(color: Colors.white))
          ),
          Container(
              alignment: Alignment.center,
              height: 80,
              child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue),
                  child: const Text("Edit Profile",
                      style: TextStyle(color: Colors.white))))
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.grey,
        currentIndex: widget.selectedIndex!,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: IconButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const HomePage()));
                },
                icon: const Icon(Icons.home)),
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
          const BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
