// To parse this JSON data, do
//
//     final profile = profileFromJson(jsonString);

import 'dart:convert';

import 'package:flutter/material.dart';

Profile profileFromJson(String str) => Profile.fromJson(json.decode(str));

String profileToJson(Profile data) => json.encode(data.toJson());

class Profile {
  Profile({
    this.fullName,
    this.age,
    this.birthdate,
    this.gender,
    this.email,
    this.phoneNum,
    this.address,
  });

  String? fullName;
  int? age;
  String? birthdate;
  String? gender;
  String? email;
  String? phoneNum;
  String? address;

  factory Profile.fromJson(Map<String, dynamic> json) => Profile(
    fullName: json["fullName"],
    age: json["age"],
    birthdate: json["birthdate"],
    gender: json["gender"],
    email: json["email"],
    phoneNum: json["phoneNum"],
    address: json["address"],
  );

  Map<String, dynamic> toJson() => {
    "fullName": fullName,
    "age": age,
    "birthdate": birthdate,
    "gender": gender,
    "email": email,
    "phoneNum": phoneNum,
    "address": address,
  };
}
