import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_bmi/model/bmi_model.dart';
import 'package:final_bmi/pages/bmi_page.dart';
import 'package:final_bmi/pages/profile_page.dart';
import 'package:final_bmi/provider/db_provider.dart';
import 'package:flutter/material.dart';


class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final CollectionReference bmiHistory = FirebaseFirestore.instance.collection('bmiHistory');
  DBProvider? dbProvider;
  late Future<List<BmiModel>> dataList;
  int _selectedIndex = 0;
  var isloading = false;


  @override
  void initState() {
    dbProvider = DBProvider();
    super.initState();
  }

  Future <void> deleteData(String productId)async{
    await bmiHistory.doc(productId).delete();
  }


  // buildBMIStreamBuilder(){
  //   return StreamBuilder(
  //       stream: bmiHistory.snapshots(),
  //       builder: (context,AsyncSnapshot<QuerySnapshot>streamSnapshot){
  //         if(streamSnapshot.hasData){
  //           return ListView.builder(
  //               padding: const EdgeInsets.all(10),
  //               itemCount: streamSnapshot.data!.docs.length,
  //               itemBuilder: (context,index){
  //                 final DocumentSnapshot documentSnapshot = streamSnapshot.data!.docs[index];
  //                 return Dismissible(
  //                   key: UniqueKey(),
  //                   background: Container(color: Colors.red),
  //                   onDismissed: (DismissDirection direction) {
  //                     setState(() {
  //                       deleteData(documentSnapshot.id);
  //                       // dbProvider!.deleteBMI(documentSnapshot['id']);
  //                       // dataList = dbProvider!.getBMIList();
  //                       // snapshot.data!.remove(snapshot.data![index]);
  //                     });
  //                   },
  //                   child: Card(
  //                     elevation: 10,
  //                     shape: RoundedRectangleBorder(
  //                         side: const BorderSide(color: Colors.white70, width: 1),
  //                         borderRadius: BorderRadius.circular(10)),
  //                     child: ExpansionTile(
  //                       title: Text(documentSnapshot['weightClass']),
  //                       subtitle: Text('Result: ${documentSnapshot['result']}'),
  //                       backgroundColor: Color(0xFFF8EDE3),
  //                       children: [
  //                         Container(
  //                           color: Color(0xFF85586F),
  //                           alignment: Alignment.centerLeft,
  //                           padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 5),
  //                           child: Column(
  //                             crossAxisAlignment: CrossAxisAlignment.start,
  //                             children: [
  //                               Text("Height: ${documentSnapshot['height']}",style: const TextStyle(color: Colors.white)),
  //                               Text("Weight: ${documentSnapshot['weight']}",style: const TextStyle(color: Colors.white)),
  //                               Text("Age: ${documentSnapshot['age']}",style: const TextStyle(color: Colors.white))
  //                             ],
  //                           ),
  //                         )
  //                       ],
  //                     ),
  //                   ),
  //                 );
  //               });
  //         }else{
  //           return const CircularProgressIndicator();
  //         }
  //       });
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
        child: CircularProgressIndicator(),
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
      )
    );
  }
}
