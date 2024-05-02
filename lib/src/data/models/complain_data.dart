// To parse this JSON data, do
//
//     final complainData = complainDataFromJson(jsonString);

import 'dart:convert';

ComplainData complainDataFromJson(String str) => ComplainData.fromJson(json.decode(str));

String complainDataToJson(ComplainData data) => json.encode(data.toJson());

class ComplainData {
  String? location;
  String? description;
  String? image;

  ComplainData({
    this.location,
    this.description,
    this.image,
  });

  factory ComplainData.fromJson(Map<String, dynamic> json) => ComplainData(
        location: json["location"],
        description: json["description"],
        image: json["image"],
      );

  Map<String, dynamic> toJson() => {
        "location": location,
        "description": description,
        "image": image,
      };
}
