// To parse this JSON data, do
//
//     final plannerModel = plannerModelFromJson(jsonString);

import 'dart:convert';

PlannerModel plannerModelFromJson(String str) => PlannerModel.fromJson(json.decode(str));

String plannerModelToJson(PlannerModel data) => json.encode(data.toJson());

class PlannerModel {
  PlannerModel({
    this.type,
    this.title,
    this.description,
    this.calendarOutput,
  });

  String? type;
  String? title;
  String? description;
  String? calendarOutput;

  factory PlannerModel.fromJson(Map<String, dynamic> json) => PlannerModel(
    type: json["type"],
    title: json["title"],
    description: json["description"],
    calendarOutput: json["calendarOutput"],
  );

  Map<String, dynamic> toJson() => {
    "type": type,
    "title": title,
    "description": description,
    "calendarOutput": calendarOutput,
  };
}
