import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_bmi/auth.dart';
import 'package:final_bmi/model/planner_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_core/firebase_core.dart' as firebase_core;

import 'bmi_model.dart';

class Storage {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  final Auth test = Auth();
  final firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  Future<void> uploadFile(String filePath, String fileName)async{
    File file = File(filePath);
    try{
      await storage.ref('${_firebaseAuth.currentUser!.uid}/uploads/$fileName').putFile(file);
    } on firebase_core.FirebaseException catch (e){
      print(e);
    }
  }

  Future addUserInfoToDB(String userId, Map<String, dynamic> userInfoMap) {
    return FirebaseFirestore.instance
        .collection("users")
        .doc(userId)
        .set(userInfoMap);
  }

  Future<BmiModel> createBmiData(BmiModel bmiModel) async {
    final dbClient = FirebaseFirestore.instance.collection('users')
        .doc(_firebaseAuth.currentUser!.uid)
        .collection('bmiHistory').doc();

    await dbClient.set(bmiModel.toJson());
    return bmiModel;
  }

  Future addUserPlannerToDB(PlannerModel plannerModel) async{
    final dbClient = FirebaseFirestore.instance.collection('users')
        .doc(_firebaseAuth.currentUser!.uid)
        .collection('plannerHistory').doc();

    await dbClient.set(plannerModel.toJson());
    return plannerModel;
  }

  Future EditUserPlannerFromDB(PlannerModel plannerModel) async{
    final dbClient = FirebaseFirestore.instance.collection('users')
        .doc(_firebaseAuth.currentUser!.uid)
        .collection('plannerHistory').doc();

    await dbClient.set(plannerModel.toJson());
    return plannerModel;
  }

  Future getUserFromDB(String userId) {
    return FirebaseFirestore.instance.collection("users").doc(userId).get();
  }

  Future<firebase_storage.ListResult> listFiles()async{
    firebase_storage.ListResult result = await storage.ref('adrian').listAll();

    return result;
  }

  Stream<String> getPicStream(String imageName) {
    return storage.ref('${_firebaseAuth.currentUser!.uid}/uploads/$imageName').getDownloadURL().asStream();
  }


  Future<String> getPic (String imageName)async{
    String downloadURL = await storage.ref('${_firebaseAuth.currentUser!.uid}/uploads/$imageName').getDownloadURL();

    return downloadURL;
  }

}
