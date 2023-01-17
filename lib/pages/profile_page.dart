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
        padding: const EdgeInsets.symmetric(horizontal: 12),
        children: [

          const SizedBox(height: 36),
          Container(
            alignment: Alignment.center,
            height: 120,
            child: const CircleAvatar(
              radius: 60,
              backgroundImage: NetworkImage('https://www.thefarmersdog.com/digest'
                  '/wp-content/uploads/2021/12/corgi-top-1400x871.jpg'),
            ),
          ),
          Card(
            elevation: 10,
            shape: RoundedRectangleBorder(
                side: const BorderSide(color: Colors.white70, width: 1),
                borderRadius: BorderRadius.circular(15),
            ),
            child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                alignment: Alignment.topLeft,
                height: 200,
                color: const Color(0xFF967E76),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: const [
                    Text("Name: Adrian", style: TextStyle(color: Colors.white)),
                    SizedBox(width: 125),
                    Text("Surname: Auguis", style: TextStyle(color: Colors.white)),
                  ],
                ),
            )
          ),
          Card(
              elevation: 10,
              shape: RoundedRectangleBorder(
                side: const BorderSide(color: Colors.white70, width: 1),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Container(
                  alignment: Alignment.center,
                  height: 200,
                  color: const Color(0xFF967E76),
                  child: const Text("Wapako ka balo unsa ni dari",
                      style: TextStyle(color: Colors.white))
              )
          ),
          Container(
              alignment: Alignment.center,
              height: 70,
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
