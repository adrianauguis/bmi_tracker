// To parse this JSON data, do
//
//     final bmiModel = bmiModelFromJson(jsonString);

import 'dart:convert';

BmiModel? bmiModelFromJson(String str) => BmiModel.fromJson(json.decode(str));

String bmiModelToJson(BmiModel? data) => json.encode(data!.toJson());

class BmiModel {
  BmiModel({
    this.bmiDate,
    this.height,
    this.weight,
    this.age,
    this.weightClass,
    this.result,
  });

  DateTime? bmiDate;
  double? height;
  double? weight;
  int? age;
  String? weightClass;
  double? result;


  factory BmiModel.fromJson(Map<String, dynamic> json) => BmiModel(
    bmiDate: json["bmiDate"],
    height: json["height"].toDouble(),
    weight: json["weight"].toDouble(),
    age: json["age"],
    weightClass: json["weightClass"],
    result: json["result"].toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "bmiDate": bmiDate,
    "height": height,
    "weight": weight,
    "age": age,
    "weightClass": weightClass,
    "result": result,
  };
}
