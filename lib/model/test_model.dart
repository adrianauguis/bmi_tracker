// To parse this JSON data, do
//
//     final testModel = testModelFromJson(jsonString);

import 'dart:convert';

TestModel? testModelFromJson(String str) => TestModel.fromJson(json.decode(str));

String testModelToJson(TestModel? data) => json.encode(data!.toJson());

class TestModel {
  TestModel({
    this.id,
    this.ordinal,
    this.name,
    this.yearsInOffice,
    this.vicePresidents,
    this.photo,
  });

  int? id;
  int? ordinal;
  String? name;
  String? yearsInOffice;
  List<String?>? vicePresidents;
  String? photo;

  factory TestModel.fromJson(Map<String, dynamic> json) => TestModel(
    id: json["id"],
    ordinal: json["ordinal"],
    name: json["name"],
    yearsInOffice: json["yearsInOffice"],
    vicePresidents: json["vicePresidents"] == null ? [] : List<String?>.from(json["vicePresidents"]!.map((x) => x)),
    photo: json["photo"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "ordinal": ordinal,
    "name": name,
    "yearsInOffice": yearsInOffice,
    "vicePresidents": vicePresidents == null ? [] : List<dynamic>.from(vicePresidents!.map((x) => x)),
    "photo": photo,
  };
}
