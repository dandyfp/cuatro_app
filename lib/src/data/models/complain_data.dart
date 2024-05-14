// To parse this JSON data, do
//
//     final complainData = complainDataFromJson(jsonString);

import 'dart:convert';

ComplainData complainDataFromJson(String str) => ComplainData.fromJson(json.decode(str));

String complainDataToJson(ComplainData data) => json.encode(data.toJson());

class ComplainData {
  String? uid;
  String? location;
  String? description;
  String? image;
  String? status;
  String? idUser;
  String? imgDate;

  ComplainData({
    this.location,
    this.description,
    this.image,
    this.uid,
    this.idUser,
    this.status,
    this.imgDate,
  });

  factory ComplainData.fromJson(Map<String, dynamic> json) => ComplainData(
        location: json["location"],
        description: json["description"],
        image: json["image"],
        uid: json["uid"],
        status: json["status"],
        idUser: json["idUser"],
        imgDate: json["imgDate"],
      );

  Map<String, dynamic> toJson() => {
        "location": location,
        "description": description,
        "image": image,
        "uid": uid,
        "idUser": idUser,
        "status": status,
        "imageDate": imgDate,
      };
}
