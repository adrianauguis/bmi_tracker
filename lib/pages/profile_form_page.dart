// ignore_for_file: prefer_typing_uninitialized_variables, use_build_context_synchronously, unnecessary_null_comparison

//NOTE: USE THIS PAGE CODE FOR THE 2ND OPTION ONLY
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_bmi/auth.dart';
import 'package:final_bmi/pages/profile_page.dart';
import 'package:final_bmi/provider/db_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';

import '../model/storage_service.dart';

class ProForm extends StatefulWidget {
  DocumentSnapshot docU;

  ProForm({Key? key, required this.docU}) : super(key: key);

  @override
  State<ProForm> createState() => _ProFormState();
}

class _ProFormState extends State<ProForm> {
  final CollectionReference profile =
      FirebaseFirestore.instance.collection('users');
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final Storage storage = Storage();
  DBProvider? dbProvider;
  final formKey = GlobalKey<FormState>();
  final fullName = TextEditingController();
  final age = TextEditingController();
  final email = TextEditingController();
  final address = TextEditingController();
  var gender, sender;
  bool update = false;

  @override
  void initState() {
    dbProvider = DBProvider();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    DocumentSnapshot newDoc = widget.docU;
    if (newDoc != null) {
      fullName.text = newDoc['fullName'];
      age.text = newDoc['age'].toString();
      email.text = newDoc['email'];
      gender = newDoc['gender'];
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back)),
        title: const Text('Profile Information:'),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        children: [
          const SizedBox(height: 20),
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
                      const SizedBox(height: 10),
                      ElevatedButton(
                          onPressed: () async {
                            final result = await FilePicker.platform.pickFiles(
                                allowMultiple: false,
                                type: FileType.custom,
                                allowedExtensions: ['png', 'jpg', 'jpeg']);

                            if (result == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text("No Image Selected")));
                              return;
                            }
                            final filePath = result.files.single.path!;
                            const fileName = "pfp";
                            storage.uploadFile(filePath, fileName);
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.brown),
                          child: const Text("Change Profile",
                              style: TextStyle(color: Colors.white))),
                    ],
                  );
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                {
                  return Column(
                    children: [
                      Container(
                          alignment: Alignment.center,
                          height: 120,
                          child: const CircleAvatar(
                            radius: 60,
                            backgroundImage: NetworkImage(
                                "https://i0.wp.com/collegecore.com/wp-content/uploads/2018/05/facebook-no-profile-picture-icon-620x389.jpg?ssl=1"),
                          )),
                      const SizedBox(height: 10),
                      ElevatedButton(
                          onPressed: () async {
                            final result = await FilePicker.platform.pickFiles(
                                allowMultiple: false,
                                type: FileType.custom,
                                allowedExtensions: ['png', 'jpg', 'jpeg']);

                            if (result == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text("No Image Selected")));
                              return;
                            }
                            final filePath = result.files.single.path!;
                            const fileName = "pfp";
                            storage.uploadFile(filePath, fileName);
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.brown),
                          child: const Text("Change Profile",
                              style: TextStyle(color: Colors.white))),
                    ],
                  );
                }
              }),
          Container(
            alignment: Alignment.center,
            height: 350,
            //color: Colors.green,
            child: Form(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              key: formKey,
              child: ListView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                children: [
                  Container(
                      alignment: Alignment.center,
                      height: 50,
                      color: Colors.brown,
                      child: const Text("MEMBERSHIP INFORMATION",
                          style: TextStyle(color: Colors.white))),
                  const SizedBox(height: 7),
                  TextFormField(
                    controller: fullName,
                    keyboardType: TextInputType.name,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Full Name:",
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Please Enter Full Name";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 7),
                  TextFormField(
                    controller: age,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Age:",
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Please Enter Age";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 7),
                  DropdownButtonFormField(
                      value: gender,
                      decoration: const InputDecoration(
                          labelText: "Gender:", border: OutlineInputBorder()),
                      items: const [
                        DropdownMenuItem(
                          value: "Male",
                          child: Text("Male"),
                        ),
                        DropdownMenuItem(
                          value: "Female",
                          child: Text("Female"),
                        ),
                      ],
                      onChanged: (value) {
                        setState(() {
                          gender = value;
                        });
                      }),
                  const SizedBox(height: 7),
                  TextFormField(
                    controller: email,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Email Address:",
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Please Enter Email";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 7),
                ],
              ),
            ),
          ),
          Container(
            alignment: Alignment.center,
            height: 40,
            //color: Colors.blue,
            child: ElevatedButton(
              onPressed: () async {
                print(newDoc.id);
                print(_firebaseAuth.currentUser!.uid);
                if (formKey.currentState!.validate()) {
                  await profile.doc(newDoc.id).update({
                    "fullName": fullName.text,
                    "age": int.parse(age.text),
                    "gender": gender.toString(),
                    "email": email.text,
                  });

                  // await dbProvider!.insertProfile(Profile(
                  //     fullName: fullName.text,
                  //     age: int.parse(age.text),
                  //     gender: gender,
                  //     email: email.text,
                  //     phoneNum: phoneNum.text,
                  //     address: address.text
                  // ));

                  Navigator.pop(context);
                } else {
                  return;
                }
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.brown),
              child: const Text("Save Changes",
                  style: TextStyle(color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }
}
