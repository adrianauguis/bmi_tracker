// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_bmi/pages/login_register_page.dart';
import 'package:final_bmi/pages/profile_form_page.dart';
import 'package:final_bmi/pages/bmi_page.dart';
import 'package:final_bmi/pages/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../auth.dart';
import '../model/profile_model.dart';
import '../provider/db_provider.dart';

class ProfilePage extends StatefulWidget {
  final int? selectedIndex;

  final dynamic data;

  const ProfilePage({
    Key? key,
    this.selectedIndex,
    this.data,
  }) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final CollectionReference profile =
      FirebaseFirestore.instance.collection('profile');
  final CollectionReference bmiHistory =
      FirebaseFirestore.instance.collection('bmiHistory');
  late DocumentSnapshot docToEdit;
  DBProvider? dbProvider;
  late Future<List<Profile>> dataList;
  List<Profile> datas = [];
  var receiver;
  var isLoading = false;

  setDoc(DocumentSnapshot documentSnapshot) {
    docToEdit = documentSnapshot;
  }

  Future<void> deleteData(String productId) async {
    await bmiHistory.doc(productId).delete();
  }

  final User? user = Auth().currentUser!;

  Future<void> signOut() async {
    FirebaseAuth.instance.signOut();
    print(Auth().currentUser?.email);
    await Auth().signOut();
    setState(() {
      Navigator.pop(context);
    });
  }

  buildProfileStreamBuilder() {
    return StreamBuilder(
        stream: profile.snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
          if (streamSnapshot.hasData) {
            return ListView.builder(
                padding: const EdgeInsets.all(10),
                itemCount: streamSnapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  DocumentSnapshot documentSnapshot =
                      streamSnapshot.data!.docs[index];
                  setDoc(documentSnapshot);
                  return Column(
                    children: [
                      // Container(decoration: const BoxDecoration(border: Border(bottom: BorderSide()))),
                      ListTile(
                        leading: const Icon(Icons.perm_identity),
                        title: Text.rich(
                            TextSpan(text: 'Full Name: ', children: <TextSpan>[
                          TextSpan(
                            text: documentSnapshot['fullName'],
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          )
                        ])),
                      ),

                      // Container(decoration: const BoxDecoration(border: Border(bottom: BorderSide()))),

                      ListTile(
                        leading: const Icon(Icons.onetwothree_outlined),
                        title: Text.rich(
                            TextSpan(text: 'Age: ', children: <TextSpan>[
                          TextSpan(
                            text: documentSnapshot['age'].toString(),
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          )
                        ])),
                      ),

                      ListTile(
                        leading: const Icon(Icons.people_alt_outlined),
                        title: Text.rich(
                            TextSpan(text: 'Gender: ', children: <TextSpan>[
                          TextSpan(
                            text: documentSnapshot['gender'],
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          )
                        ])),
                      ),

                      // Container(decoration: const BoxDecoration(border: Border(bottom: BorderSide()))),

                      ListTile(
                        leading: const Icon(Icons.email_outlined),
                        title: Text.rich(TextSpan(
                            text: 'Email Address: ',
                            children: <TextSpan>[
                              TextSpan(
                                text: documentSnapshot['emailAdd'],
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              )
                            ])),
                      ),

                      // Container(decoration: const BoxDecoration(border: Border(bottom: BorderSide()))),

                      ListTile(
                        leading: const Icon(Icons.phone),
                        title: Text.rich(TextSpan(
                            text: 'Phone Number: ',
                            children: <TextSpan>[
                              TextSpan(
                                text: documentSnapshot['phoneNum'].toString(),
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              )
                            ])),
                      ),

                      // Container(decoration: const BoxDecoration(border: Border(bottom: BorderSide()))),

                      ListTile(
                        leading: const Icon(Icons.pin_drop_outlined),
                        title: Text.rich(
                            TextSpan(text: 'Address: ', children: <TextSpan>[
                          TextSpan(
                            text: documentSnapshot['address'],
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          )
                        ])),
                      ),

                      // Container(decoration: const BoxDecoration(border: Border(bottom: BorderSide()))),
                    ],
                  );
                });
          } else {
            return const CircularProgressIndicator();
          }
        });
  }

  buildBMIStreamBuilder() {
    return StreamBuilder(
        stream: bmiHistory.snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
          if (streamSnapshot.hasData) {
            return ListView.builder(
                padding: const EdgeInsets.all(10),
                itemCount: streamSnapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  final DocumentSnapshot documentSnapshot =
                      streamSnapshot.data!.docs[index];
                  return Dismissible(
                    key: UniqueKey(),
                    background: Container(color: Colors.red),
                    onDismissed: (DismissDirection direction) {
                      setState(() {
                        deleteData(documentSnapshot.id);
                        // dbProvider!.deleteBMI(documentSnapshot['id']);
                        // dataList = dbProvider!.getBMIList();
                        // snapshot.data!.remove(snapshot.data![index]);
                      });
                    },
                    child: Card(
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                          side:
                              const BorderSide(color: Colors.white70, width: 1),
                          borderRadius: BorderRadius.circular(10)),
                      child: ExpansionTile(
                        title: Text(documentSnapshot['weightClass']),
                        subtitle: Text('Result: ${documentSnapshot['result']}'),
                        backgroundColor: const Color(0xFFF8EDE3),
                        children: [
                          Container(
                            color: const Color(0xFF85586F),
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 5),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Height: ${documentSnapshot['height']}",
                                    style:
                                        const TextStyle(color: Colors.white)),
                                Text("Weight: ${documentSnapshot['weight']}",
                                    style:
                                        const TextStyle(color: Colors.white)),
                                Text("Age: ${documentSnapshot['age']}",
                                    style: const TextStyle(color: Colors.white))
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                });
          } else {
            return const CircularProgressIndicator();
          }
        });
  }

  @override
  void initState() {
    dbProvider = DBProvider();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 35),
        children: [
          const SizedBox(height: 36),
          Container(
            alignment: Alignment.center,
            height: 120,
            child: const CircleAvatar(
              radius: 60,
              backgroundImage:
                  NetworkImage('https://www.thefarmersdog.com/digest'
                      '/wp-content/uploads/2021/12/corgi-top-1400x871.jpg'),
            ),
          ),
          Container(
              alignment: Alignment.center,
              height: 70,
              child: ElevatedButton(
                  onPressed: () async {
                    receiver = await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ProForm(
                                  docU: docToEdit,
                                )));
                    if (receiver != null) {
                      setState(() {
                        datas.add(receiver);
                      });
                    } else {
                      return;
                    }
                  },
                  style:
                      ElevatedButton.styleFrom(backgroundColor: Colors.brown),
                  child: const Text("Edit Profile",
                      style: TextStyle(color: Colors.white)))),
          Card(
              elevation: 20,
              shape: RoundedRectangleBorder(
                side: const BorderSide(color: Colors.white70, width: 1),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  alignment: Alignment.topLeft,
                  height: 365,
                  color: const Color(0xFF967E76),
                  child: isLoading
                      ? const CircularProgressIndicator()
                      : buildProfileStreamBuilder())),
          const SizedBox(height: 10),
          const SizedBox(
            height: 40,
            child: Text("BMI Collection", style: TextStyle(fontSize: 40,fontWeight: FontWeight.bold)),
          ),
          Card(
              elevation: 10,
              shape: RoundedRectangleBorder(
                side: const BorderSide(color: Colors.white70, width: 1),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Container(
                  alignment: Alignment.center,
                  height: 300,
                  //height: MediaQuery.of(context).size.height,
                  color: const Color(0xFF967E76),
                  child: isLoading
                      ? const CircularProgressIndicator()
                      : buildBMIStreamBuilder())),
          const SizedBox(height: 5),
          Card(
              elevation: 10,
              shape: RoundedRectangleBorder(
                side: const BorderSide(color: Colors.white70, width: 1),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Container(
                  alignment: Alignment.center,
                  height: 70,
                  //height: MediaQuery.of(context).size.height,
                  color: const Color(0xFF967E76),
                  child: ElevatedButton(
                      onPressed: (){
                        signOut();
                      },
                      child: const Text("Sign out"))))
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.grey,
        currentIndex: widget.selectedIndex!,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const HomePage()));
                },
                icon: const Icon(Icons.home)),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: IconButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const BMIPage()));
                },
                icon: const Icon(Icons.balance)),
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
