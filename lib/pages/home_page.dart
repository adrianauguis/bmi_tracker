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
  DBProvider? dbProvider;
  late Future<List<BmiModel>> dataList;
  int _selectedIndex = 0;
  var isloading = false;


  @override
  void initState() {
    dbProvider = DBProvider();
    super.initState();
  }

  buildBMIListView() {
    dataList = dbProvider!.getBMIList();
    return Column(
      children: [
        Expanded(
            child: FutureBuilder(
                future: dataList,
                builder: (context, AsyncSnapshot<List<BmiModel>> snapshot) {
                  if (!snapshot.hasData || snapshot.data == null) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.data!.length == 0) {
                    return const Center(
                      child: Text('No Todos'),
                    );
                  } else {
                    return ListView.builder(
                        padding: const EdgeInsets.all(10),
                        shrinkWrap: true,
                        itemCount: snapshot.data?.length,
                        itemBuilder: (context, index) {
                          int bmiId = snapshot.data![index].id!.toInt();
                          String bmiWeightclass =
                          snapshot.data![index].weightClass!;
                          double? height =
                          snapshot.data![index].height!;
                          double? weight =
                          snapshot.data![index].weight!;
                          double? result =
                          snapshot.data![index].result!;
                          return Dismissible(
                            key: UniqueKey(),
                            background: Container(color: Colors.red),
                            onDismissed: (DismissDirection direction) {
                              setState(() {
                                dbProvider!.deleteBMI(bmiId);
                                dataList = dbProvider!.getBMIList();
                                snapshot.data!.remove(snapshot.data![index]);
                              });
                            },
                            child: Card(
                              elevation: 10,
                              shape: RoundedRectangleBorder(
                                side: const BorderSide(color: Colors.white70, width: 1),
                                borderRadius: BorderRadius.circular(10)),
                              child: ExpansionTile(
                                title: Text("$bmiWeightclass"),
                                subtitle: Text('ID: $bmiId'),
                                backgroundColor: Color(0xFFF8EDE3),
                                children: [
                                  Container(
                                    color: Color(0xFF85586F),
                                    alignment: Alignment.centerLeft,
                                    padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 5),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text("Height: $height",style: const TextStyle(color: Colors.white)),
                                        Text("Weight: $weight",style: const TextStyle(color: Colors.white)),
                                        Text("BMI Result: $result",style: const TextStyle(color: Colors.white))
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                        });
                  }
                }))
      ],
    );
  }


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
      body: isloading? const Center(
        child: Text("Wapay sulod diri ang history"),
      ) : buildBMIListView(),
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
