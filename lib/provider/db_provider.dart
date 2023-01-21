import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_bmi/model/bmi_model.dart';
import 'package:final_bmi/model/profile_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:io' as io;

class DBProvider {
  static Database? _database;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<Database?> get database async {
    // If database exists, return database
    if (_database != null) return _database!;

    // If database don't exists, create one
    _database = await initDB();

    return _database;
  }

  initDB() async {
    io.Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, 'bmi.db');
    var db = await openDatabase(path, version: 1, onCreate: _createDatabase);
    return db;
  }

  _createDatabase(Database database, int version) async {
    await database.execute(
        "CREATE TABLE bmiHistory(id INTEGER PRIMARY KEY AUTOINCREMENT, "
        "height DOUBLE NOT NULL, weight DOUBLE NOT NULL, age INTEGER NOT NULL,"
        "weightClass TEXT NOT NULL, result DOUBLE NOT NULL);");

    await database.execute(
        "CREATE TABLE profile(id INTEGER PRIMARY KEY AUTOINCREMENT, "
        "fullName TEXT NOT NULL, birthdate TEXT NOT NULL, age INTEGER NOT NULL,"
        "gender TEXT NOT NULL, email TEXT NOT NULL, phoneNum TEXT NOT NULL, address TEXT NOT NULL);");
  }

  Future<BmiModel> insertBMI(BmiModel bmiModel) async {
    var dbClient = await database;
    await dbClient!.insert('bmiHistory', bmiModel.toJson());
    return bmiModel;
  }


  Future<Profile> insertProfile(Profile profile) async {
    var dbClient = await database;
    await dbClient!.insert('profile', profile.toJson());
    return profile;
  }

  Future<BmiModel> createData(BmiModel bmiModel) async {
    final dbClient = FirebaseFirestore.instance.collection('users').doc(_firebaseAuth.currentUser!.uid).collection('bmiHistory').doc();

    await dbClient.set(bmiModel.toJson());
    return bmiModel;
  }

  Future<List<Profile>> getProfileList() async {
    var dbClient = await database;
    List<Map<String, Object?>> queryResult =
        await dbClient!.rawQuery('SELECT * FROM profile');

    return queryResult.map((e) => Profile.fromJson(e)).toList();
  }

  Future<List<BmiModel>> getBMIList() async {
    var dbClient = await database;
    List<Map<String, Object?>> queryResult =
        await dbClient!.rawQuery('SELECT * FROM bmiHistory');

    return queryResult.map((e) => BmiModel.fromJson(e)).toList();
  }

  Future<int> deleteBMI(int id) async {
    var dbClient = await database;
    return await dbClient!
        .delete('bmiHistory', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> deleteDatabase() async {
    io.Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, 'bmi.db');
    databaseFactory.deleteDatabase(path);
  }

// Future<int> updateBMI(BmiModel BmiModel) async {
//   var dbClient = await database;
//   return await dbClient!.update('bmiHistory', BmiModel.toJson(),
//       where: 'id = ?', whereArgs: [BmiModel.id]);
// }
}
