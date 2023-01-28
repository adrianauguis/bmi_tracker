// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_bmi/model/storage_service.dart';
import 'package:final_bmi/pages/profile_form_page.dart';
import 'package:final_bmi/pages/bmi_page.dart';
import 'package:final_bmi/pages/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final CollectionReference profile =
      FirebaseFirestore.instance.collection('users');

  late DocumentSnapshot docToEdit;
  late Future<List<Profile>> dataList;
  List<Profile> datas = [];
  var receiver;
  var isLoading = false;
  final Storage storage = Storage();

  setDoc(DocumentSnapshot documentSnapshot) {
    docToEdit = documentSnapshot;
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
                  if (documentSnapshot.id != _firebaseAuth.currentUser!.uid) {
                    return Container();
                  }
                  {
                    setDoc(documentSnapshot);
                    return Column(
                      children: [
                        ListTile(
                          leading: const Icon(Icons.perm_identity),
                          title: Text.rich(TextSpan(
                              text: 'Full Name: ',
                              children: <TextSpan>[
                                TextSpan(
                                  text: documentSnapshot['fullName'],
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                )
                              ])),
                        ),
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
                        ListTile(
                          leading: const Icon(Icons.email_outlined),
                          title: Text.rich(TextSpan(
                              text: 'Email Address: ',
                              children: <TextSpan>[
                                TextSpan(
                                  text: documentSnapshot['email'],
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                )
                              ])),
                        ),
                        // ListTile(
                        //   leading: const Icon(Icons.phone),
                        //   title: Text.rich(TextSpan(
                        //       text: 'Phone Number: ',
                        //       children: <TextSpan>[
                        //         TextSpan(
                        //           text: documentSnapshot['phoneNum'].toString(),
                        //           style: const TextStyle(
                        //               fontWeight: FontWeight.bold,
                        //               color: Colors.white),
                        //         )
                        //       ])),
                        // ),
                      ],
                    );
                  }
                });
          } else {
            return const CircularProgressIndicator();
          }
        });
  }

  buildBMIStreamBuilder() {
    final CollectionReference bmiHistory =
    FirebaseFirestore.instance.collection('users').doc(_firebaseAuth.currentUser!.uid).collection('bmiHistory');

    Future<void> deleteData(String productId) async {
      await bmiHistory.doc(productId).delete();
    }

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
                  Timestamp t = documentSnapshot['bmiDate'];
                  DateTime date = t.toDate();
                  String formattedDate = DateFormat.yMMMEd().format(date);
                  return Dismissible(
                    key: UniqueKey(),
                    background: Container(color: Colors.red),
                    onDismissed: (DismissDirection direction) {
                      setState(() {
                        deleteData(documentSnapshot.id);
                      });
                    },
                    child: Card(
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                          side:
                              const BorderSide(color: Colors.white70, width: 1),
                          borderRadius: BorderRadius.circular(10)),
                      child: ExpansionTile(
                        title: Text(formattedDate),
                        subtitle: Text('BMI Result: ${documentSnapshot['bmiResult']}'),
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
                                Text("Weight Class: ${documentSnapshot['weightClass']}",style:
                            const TextStyle(color: Colors.white)),
                                Text("Height: ${documentSnapshot['height']} ft",
                                    style:
                                        const TextStyle(color: Colors.white)),
                                Text("Weight: ${documentSnapshot['weight']} kg",
                                    style:
                                        const TextStyle(color: Colors.white)),
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
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 35),
        children: [
          const SizedBox(height: 36),
          StreamBuilder(
              stream: storage.getPicStream('pfp'),
              builder: (context, AsyncSnapshot<String> snapshot) {
                if (snapshot.hasData) {
                  return Column(
                    children: [
                      Container(
                          alignment: Alignment.center,
                          height: 120,
                          child: CircleAvatar(
                            radius: 60,
                            backgroundImage: NetworkImage(snapshot.data ??
                                "https://i0.wp.com/collegecore.com/wp-content/uploads/2018/05/facebook-no-profile-picture-icon-620x389.jpg?ssl=1"),
                          )),
                    ],
                  );
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                return Container(
                    alignment: Alignment.center,
                    height: 120,
                    child: const CircleAvatar(
                      radius: 60,
                      backgroundImage: NetworkImage("https://i0.wp.com/collegecore.com/wp-content/uploads/2018/05/facebook-no-profile-picture-icon-620x389.jpg?ssl=1"),
                    ));
              }),

          const SizedBox(height: 10),
          ElevatedButton(
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
              style: ElevatedButton.styleFrom(backgroundColor: Colors.brown),
              child: const Text("Edit Profile",
                  style: TextStyle(color: Colors.white))),

          const SizedBox(width: 7),

          Card(
              elevation: 20,
              shape: RoundedRectangleBorder(
                side: const BorderSide(color: Colors.white70, width: 1),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  alignment: Alignment.topLeft,
                  height: 315,
                  color: const Color(0xFF967E76),
                  child: isLoading
                      ? const CircularProgressIndicator()
                      : buildProfileStreamBuilder())),

          const SizedBox(height: 10),

          const SizedBox(
            height: 40,
            child: Text("BMI Collection",
                style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold)),
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
                      onPressed: () {
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
                          builder: (context) => HomePage()));
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
