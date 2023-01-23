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
    this.gender,
    this.email,
  });

  String? fullName;
  int? age;
  String? gender;
  String? email;

  factory Profile.fromJson(Map<String, dynamic> json) => Profile(
    fullName: json["fullName"],
    age: json["age"],
    gender: json["gender"],
    email: json["email"],
  );

  Map<String, dynamic> toJson() => {
    "fullName": fullName,
    "age": age,
    "gender": gender,
    "email": email,
  };
}
