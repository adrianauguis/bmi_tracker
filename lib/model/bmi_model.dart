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
    this.weightClass,
    this.bmiResult,
  });

  DateTime? bmiDate;
  double? height;
  double? weight;
  String? weightClass;
  double? bmiResult;


  factory BmiModel.fromJson(Map<String, dynamic> json) => BmiModel(
    bmiDate: json["bmiDate"],
    height: json["height"].toDouble(),
    weight: json["weight"].toDouble(),
    weightClass: json["weightClass"],
    bmiResult: json["bmiResult"].toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "bmiDate": bmiDate,
    "height": height,
    "weight": weight,
    "weightClass": weightClass,
    "bmiResult": bmiResult,
  };
}
