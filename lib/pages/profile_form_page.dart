// ignore_for_file: prefer_typing_uninitialized_variables, use_build_context_synchronously

//NOTE: USE THIS PAGE CODE FOR THE 2ND OPTION ONLY
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_bmi/model/profile_model.dart';
import 'package:final_bmi/provider/db_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ProForm extends StatefulWidget {
  DocumentSnapshot docU;
  ProForm({Key? key, required this.docU}) : super(key: key);

  @override
  State<ProForm> createState() => _ProFormState();
}

class _ProFormState extends State<ProForm> {
  final CollectionReference profile = FirebaseFirestore.instance.collection('profile');
  DBProvider? dbProvider;
  final formKey = GlobalKey<FormState>();
  // late DateTime dt;
  final fullName = TextEditingController();
  final age = TextEditingController();
  final birthdate = TextEditingController();
  final email = TextEditingController();
  final phoneNum = TextEditingController();
  final address = TextEditingController();
  var gender, sender;
  bool update = false;


  @override
  void initState() {
    dbProvider = DBProvider();
    super.initState();
  }

  // Future<void> selectDate(BuildContext context) async {
  //   final DateTime? picked = await showDatePicker(
  //       context: context,
  //       initialDate: selectedDate,
  //       firstDate: DateTime(1960, 8),
  //       lastDate: DateTime(2101));
  //   if (picked != null && picked != selectedDate) {
  //     setState(() {
  //       selectedDate = picked;
  //       update = true;
  //     });
  //   }
  // }


  @override
  Widget build(BuildContext context) {
    DocumentSnapshot newDoc = widget.docU;
    if (newDoc != null){
      fullName.text = newDoc['fullName'];
      age.text = newDoc['age'].toString();
      email.text = newDoc['emailAdd'];
      phoneNum.text = newDoc['phoneNum'].toString();
      address.text = newDoc['address'];
      gender = newDoc['gender'];
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back)
        ),
        title: const Text('Profile Information:'),
      ),

      body: ListView(
        children: [
          Container(
            alignment: Alignment.center,
            height: 500,
            //color: Colors.green,
            child: Form(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              key: formKey,
              child: ListView(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10, vertical: 10),
                children: [
                  Container(
                      alignment: Alignment.center,
                      height: 50,
                      color: Colors.brown,
                      child: const Text(
                          "MEMBERSHIP INFORMATION",
                          style: TextStyle(color: Colors.white)
                      )
                  ),
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
                  // ListTile(
                  //   title: Text(birthdate.text),
                  //   subtitle: const Text("Birthdate"),
                  //   shape: RoundedRectangleBorder(
                  //     side: const BorderSide(color: Colors.grey, width: 1),
                  //     borderRadius: BorderRadius.circular(5),
                  //   ),
                  //   trailing: IconButton(
                  //       onPressed: (){
                  //         selectDate(context);
                  //       },
                  //       icon: const Icon(Icons.calendar_month)),
                  // ),
                  // TextFormField(
                  //   controller: birthdate,
                  //   keyboardType: TextInputType.datetime,
                  //   decoration: InputDecoration(
                  //     border: OutlineInputBorder(),
                  //     labelText: "BirthDate:",
                  //     suffixIcon: IconButton(
                  //         onPressed: (){
                  //           selectDate(context);
                  //         },
                  //         icon: const Icon(Icons.calendar_month))
                  //   ),
                  //   validator: (value) {
                  //     if (value!.isEmpty) {
                  //       return "Please Enter BirthDate";
                  //     }
                  //     return null;
                  //   },
                  // ),
                  const SizedBox(height: 7),
                  DropdownButtonFormField(
                      value: gender,
                      decoration: const InputDecoration(
                          labelText: "Gender:",
                          border: OutlineInputBorder()
                      ),
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
                      }
                  ),
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
                  TextFormField(
                    controller: phoneNum,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Phone Number:",
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Please Enter Phone Number";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 7),
                  TextFormField(
                    controller: address,
                    keyboardType: TextInputType.streetAddress,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Address:",
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Please Enter Address";
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),

          Container(
            alignment: Alignment.center,
            height: 50,
            //color: Colors.blue,
            child: ElevatedButton(
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  await profile.doc(newDoc.id).update({
                    "fullName": fullName.text,
                    "age": int.parse(age.text),
                    "birthdate": birthdate.text,
                    "gender": gender,
                    "email": email.text,
                    "phoneNum": int.parse(phoneNum.text),
                    "address": address.text
                  });

                  await dbProvider!.insertProfile(Profile(
                      fullName: fullName.text,
                      age: int.parse(age.text),
                      // birthdate: birthdate.text,
                      gender: gender,
                      email: email.text,
                      phoneNum: phoneNum.text,
                      address: address.text
                  ));

                  sender = await Profile(fullName: fullName.text,
                      age: int.parse(age.text),
                      // birthdate: birthdate.text,
                      gender: gender,
                      email: email.text,
                      phoneNum: phoneNum.text,
                      address: address.text);

                  Navigator.pop(context,sender);
                }else{
                  return;
                }
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.brown),
              child: const Text(
                  "Save Changes",
                  style: TextStyle(color: Colors.white)
              ),
            ),
          ),
        ],
      ),
    );
  }
}
