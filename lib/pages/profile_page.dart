// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_bmi/pages/bmi_collection_page.dart';
import 'package:final_bmi/pages/profile_form_page.dart';
import 'package:final_bmi/pages/bmi_page.dart';
import 'package:final_bmi/pages/home_page.dart';
import 'package:flutter/material.dart';

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
  final CollectionReference profile = FirebaseFirestore.instance.collection('profile');
  late DocumentSnapshot docToEdit;
  DBProvider? dbProvider;
  late Future<List<Profile>> dataList;
  List <Profile> datas = [];
  var receiver;
  var isLoading = false;

  setDoc(DocumentSnapshot documentSnapshot){
    docToEdit = documentSnapshot;
  }

  buildProfilePage() {
    dataList = dbProvider!.getProfileList();
    return Column(
      children: [
        Expanded(
            child: FutureBuilder(
                future: dataList,
                builder: (context, AsyncSnapshot<List<Profile>> snapshot) {
                  if (!snapshot.hasData || snapshot.data == null) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.data!.isEmpty) {
                    return const Center(
                      child: Text('No Profile Details'),
                    );
                  } else {
                    return ListView.builder(
                        padding: const EdgeInsets.all(10),
                        shrinkWrap: true,
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          String fname = snapshot.data![index].fullName!
                              .toString();
                          String bday =
                          snapshot.data![index].birthdate!.toString();
                          String gender =
                          snapshot.data![index].gender!.toString();
                          String email =
                          snapshot.data![index].email!.toString();
                          String phoneNum =
                          snapshot.data![index].phoneNum!.toString();
                          String address =
                          snapshot.data![index].address!.toString();
                          int age =
                          snapshot.data![index].age!.toInt();
                          return
                            Column(
                              children: [
                                // Container(decoration: const BoxDecoration(border: Border(bottom: BorderSide()))),
                                ListTile(
                                  leading: const Icon(Icons.perm_identity),
                                  title: Text.rich(
                                      TextSpan(
                                          text: 'Full Name: ',
                                          children: <TextSpan>[
                                            TextSpan(
                                              text: fname,
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.indigoAccent
                                              ),
                                            )
                                          ]
                                      )
                                  ),
                                ),

                                // Container(decoration: const BoxDecoration(border: Border(bottom: BorderSide()))),

                                ListTile(
                                  leading: const Icon(
                                      Icons.onetwothree_outlined),
                                  title: Text.rich(
                                      TextSpan(
                                          text: 'Age: ',
                                          children: <TextSpan>[
                                            TextSpan(
                                              text: age.toString(),
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.indigoAccent
                                              ),
                                            )
                                          ]
                                      )
                                  ),
                                ),

                                // Container(decoration: const BoxDecoration(border: Border(bottom: BorderSide()))),

                                ListTile(
                                  leading: const Icon(Icons.cake_outlined),
                                  title: Text.rich(
                                      TextSpan(
                                          text: 'BirthDate: ',
                                          children: <TextSpan>[
                                            TextSpan(
                                              text: bday,
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.indigoAccent
                                              ),
                                            )
                                          ]
                                      )
                                  ),
                                ),

                                // Container(decoration: const BoxDecoration(border: Border(bottom: BorderSide()))),

                                ListTile(
                                  leading: const Icon(
                                      Icons.people_alt_outlined),
                                  title: Text.rich(
                                      TextSpan(
                                          text: 'Gender: ',
                                          children: <TextSpan>[
                                            TextSpan(
                                              text: gender,
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.indigoAccent
                                              ),
                                            )
                                          ]
                                      )
                                  ),
                                ),

                                // Container(decoration: const BoxDecoration(border: Border(bottom: BorderSide()))),

                                ListTile(
                                  leading: const Icon(Icons.email_outlined),
                                  title: Text.rich(
                                      TextSpan(
                                          text: 'Email Address: ',
                                          children: <TextSpan>[
                                            TextSpan(
                                              text: email,
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.indigoAccent
                                              ),
                                            )
                                          ]
                                      )
                                  ),
                                ),

                                // Container(decoration: const BoxDecoration(border: Border(bottom: BorderSide()))),

                                ListTile(
                                  leading: const Icon(Icons.phone),
                                  title: Text.rich(
                                      TextSpan(
                                          text: 'Phone Number: ',
                                          children: <TextSpan>[
                                            TextSpan(
                                              text: phoneNum,
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.indigoAccent
                                              ),
                                            )
                                          ]
                                      )
                                  ),
                                ),

                                // Container(decoration: const BoxDecoration(border: Border(bottom: BorderSide()))),

                                ListTile(
                                  leading: const Icon(Icons.pin_drop_outlined),
                                  title: Text.rich(
                                      TextSpan(
                                          text: 'Address: ',
                                          children: <TextSpan>[
                                            TextSpan(
                                              text: address,
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.indigoAccent
                                              ),
                                            )
                                          ]
                                      )
                                  ),
                                ),

                                // Container(decoration: const BoxDecoration(border: Border(bottom: BorderSide()))),
                              ],


                            );
                        }
                    );

                  }
                }
                  )
    ),
      ],
    );
  }

  buildProfileStreamBuilder(){
    return StreamBuilder(
        stream: profile.snapshots(),
        builder: (context,AsyncSnapshot<QuerySnapshot>streamSnapshot){
          if(streamSnapshot.hasData){
            return ListView.builder(
                padding: const EdgeInsets.all(10),
                itemCount: streamSnapshot.data!.docs.length,
                itemBuilder: (context,index){
                  DocumentSnapshot documentSnapshot = streamSnapshot.data!.docs[index];
                  setDoc(documentSnapshot);
                  return Column(
                    children: [
                      // Container(decoration: const BoxDecoration(border: Border(bottom: BorderSide()))),
                      ListTile(
                        leading: const Icon(Icons.perm_identity),
                        title: Text.rich(
                            TextSpan(
                                text: 'Full Name: ',
                                children: <TextSpan>[
                                  TextSpan(
                                    text: documentSnapshot['fullName'],
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.indigoAccent
                                    ),
                                  )
                                ]
                            )
                        ),
                      ),

                      // Container(decoration: const BoxDecoration(border: Border(bottom: BorderSide()))),

                      ListTile(
                        leading: const Icon(
                            Icons.onetwothree_outlined),
                        title: Text.rich(
                            TextSpan(
                                text: 'Age: ',
                                children: <TextSpan>[
                                  TextSpan(
                                    text: documentSnapshot['age'].toString(),
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.indigoAccent
                                    ),
                                  )
                                ]
                            )
                        ),
                      ),

                      // Container(decoration: const BoxDecoration(border: Border(bottom: BorderSide()))),

                      ListTile(
                        leading: const Icon(Icons.cake_outlined),
                        title: Text.rich(
                            TextSpan(
                                text: 'BirthDate: ',
                                children: <TextSpan>[
                                  TextSpan(
                                    text: documentSnapshot['birthdate'].toString(),
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.indigoAccent
                                    ),
                                  )
                                ]
                            )
                        ),
                      ),

                      // Container(decoration: const BoxDecoration(border: Border(bottom: BorderSide()))),

                      ListTile(
                        leading: const Icon(
                            Icons.people_alt_outlined),
                        title: Text.rich(
                            TextSpan(
                                text: 'Gender: ',
                                children: <TextSpan>[
                                  TextSpan(
                                    text: documentSnapshot['gender'],
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.indigoAccent
                                    ),
                                  )
                                ]
                            )
                        ),
                      ),

                      // Container(decoration: const BoxDecoration(border: Border(bottom: BorderSide()))),

                      ListTile(
                        leading: const Icon(Icons.email_outlined),
                        title: Text.rich(
                            TextSpan(
                                text: 'Email Address: ',
                                children: <TextSpan>[
                                  TextSpan(
                                    text: documentSnapshot['emailAdd'],
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.indigoAccent
                                    ),
                                  )
                                ]
                            )
                        ),
                      ),

                      // Container(decoration: const BoxDecoration(border: Border(bottom: BorderSide()))),

                      ListTile(
                        leading: const Icon(Icons.phone),
                        title: Text.rich(
                            TextSpan(
                                text: 'Phone Number: ',
                                children: <TextSpan>[
                                  TextSpan(
                                    text: documentSnapshot['phoneNum'].toString(),
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.indigoAccent
                                    ),
                                  )
                                ]
                            )
                        ),
                      ),

                      // Container(decoration: const BoxDecoration(border: Border(bottom: BorderSide()))),

                      ListTile(
                        leading: const Icon(Icons.pin_drop_outlined),
                        title: Text.rich(
                            TextSpan(
                                text: 'Address: ',
                                children: <TextSpan>[
                                  TextSpan(
                                    text: documentSnapshot['address'],
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.indigoAccent
                                    ),
                                  )
                                ]
                            )
                        ),
                      ),

                      // Container(decoration: const BoxDecoration(border: Border(bottom: BorderSide()))),
                    ],


                  );
                });
          }else{
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

          Container(
              alignment: Alignment.center,
              height: 70,
              child: ElevatedButton(
                  onPressed: ()async{
                   receiver = await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ProForm(docU: docToEdit,)
                        )
                    );
                    if (receiver != null ){
                      setState(() {
                        datas.add(receiver);
                      });
                    }else{
                      return;
                    }
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue),
                  child: const Text("Edit Profile",
                      style: TextStyle(color: Colors.white)
                  )
              )
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
                height: 412,
                color: const Color(0xFF967E76),
                child: isLoading
                    ? const CircularProgressIndicator()
                    : buildProfileStreamBuilder()

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
                  height: 100,
                  color: const Color(0xFF967E76),
                  child: ElevatedButton(
                    onPressed: (){
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const BmiCollection()
                          )
                      );
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.brown
                    ),
                    child: const Text(
                        'BMI Collection',
                        style: TextStyle(color: Colors.white)
                    ),
                  ),
              )
          ),
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
