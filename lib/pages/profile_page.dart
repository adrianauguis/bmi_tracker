// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../auth.dart';
import '../model/profile_model.dart';
import '../model/storage_service.dart';
import 'bmi_page.dart';
import 'home_page.dart';
import 'login_register_page.dart';
import 'profile_form_page.dart';

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
    await Auth().signOut();
    setState(() {
      Navigator.push(context,
      MaterialPageRoute(builder: (context) => const LoginPage()));
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
                                      color: Colors.black),
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
                                  color: Colors.black),
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
                                  color: Colors.black),
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
                                      color: Colors.black),
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
          Padding(
            padding: const EdgeInsets.all(20),
            child: Material(
              elevation: 10,
              borderRadius: BorderRadius.circular(20),
              color: const Color(0xFF00FFDE),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
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
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
                        child: const Text("Edit Profile",
                            style: TextStyle(color: Colors.black))),
              ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
                        onPressed: () {
                          signOut();
                            },
                        child: const Text("Sign out", style: TextStyle(color: Colors.black))),
                ],
              ),
            ),
          ),
          const SizedBox(width: 7),
         Padding(
           padding: const EdgeInsets.all(16.0),
           child: Container(
               decoration: BoxDecoration(
                 borderRadius: BorderRadius.circular(20.0),
                   boxShadow:[
               BoxShadow(
                color: Colors.grey.withOpacity(0.5), //color of shadow
                 spreadRadius: 5, //spread radius
                 blurRadius: 7, // blur radius
                 offset: const Offset(0, 2), // changes position of shadow
               ),
                  ],
                color: Colors.white,
               ),
               padding: const EdgeInsets.symmetric(horizontal: 20),
               alignment: Alignment.topLeft,
               height: 315,
               child: isLoading
                   ? const CircularProgressIndicator()
                   : buildProfileStreamBuilder()),
         ),

          const SizedBox(height: 10),

          const Center(
            child: SizedBox(
              height: 30,
              child: Text("BMI Collection",
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                  boxShadow:[
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5), //color of shadow
                      spreadRadius: 5, //spread radius
                      blurRadius: 7, // blur radius
                      offset: const Offset(0, 2), // changes position of shadow
                    ),
                  ],
                  color: Colors.white,
                ),
                padding: const EdgeInsets.symmetric(horizontal: 20),
                alignment: Alignment.topLeft,
                height: 315,
                child: isLoading
                    ? const CircularProgressIndicator()
                    : buildBMIStreamBuilder()),
          ),

          // Card(
          //     elevation: 10,
          //     shape: RoundedRectangleBorder(
          //       side: const BorderSide(color: Colors.white70, width: 1),
          //       borderRadius: BorderRadius.circular(15),
          //     ),
          //     child: Container(
          //         alignment: Alignment.center,
          //         height: 300,
          //         //height: MediaQuery.of(context).size.height,
          //         color: const Color(0xFF967E76),
          //         child: isLoading
          //             ? const CircularProgressIndicator()
          //             : buildBMIStreamBuilder())),
          const SizedBox(height: 5),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20),
        child: Material(
          elevation: 10,
          borderRadius: BorderRadius.circular(20),
          color: const Color(0xFF00FFDE),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => HomePage()));
                  },
                  icon: const Icon(Icons.home)),
              IconButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => const BMIPage()));
                  },
                  icon: const Icon(Icons.scale_outlined)),
              IconButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => const ProfilePage()));
                  },
                  icon: const Icon(Icons.person)),

            ],
          ),
        ),
      ),
    );
  }
}
