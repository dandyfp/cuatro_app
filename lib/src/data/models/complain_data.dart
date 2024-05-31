// To parse this JSON data, do
//
//     final complainData = complainDataFromJson(jsonString);

import 'dart:convert';
import 'dart:io';

ComplainData complainDataFromJson(String str) => ComplainData.fromJson(json.decode(str));

String complainDataToJson(ComplainData data) => json.encode(data.toJson());

class ComplainData {
  File? imageFeedback;
  String? uid;
  String? location;
  String? description;
  String? image;
  String? status;
  String? idUser;
  String? imgDate;
  String? feedbackDate;
  String? feedbackImage;
  String? feedbackDescription;
  String? name;
  String? whatsapp;
  String? typeTrash;
  String? rating;

  ComplainData({
    this.location,
    this.description,
    this.image,
    this.uid,
    this.idUser,
    this.status,
    this.imgDate,
    this.feedbackDate,
    this.feedbackImage,
    this.feedbackDescription,
    this.imageFeedback,
    this.name,
    this.whatsapp,
    this.typeTrash,
    this.rating,
  });

  factory ComplainData.fromJson(Map<String, dynamic> json) => ComplainData(
        location: json["location"],
        description: json["description"],
        image: json["image"],
        uid: json["uid"],
        status: json["status"],
        idUser: json["idUser"],
        imgDate: json["imgDate"],
        feedbackImage: json["imageFeedback"],
        feedbackDate: json["dateFeedback"],
        feedbackDescription: json["descFeedback"],
        whatsapp: json["whatsapp"],
        name: json["name"],
        typeTrash: json["typeTrash"],
        rating: json["rating"],
      );

  Map<String, dynamic> toJson() => {
        "location": location,
        "description": description,
        "image": image,
        "uid": uid,
        "idUser": idUser,
        "status": status,
        "imageDate": imgDate,
        'imageFeedback': feedbackImage,
        'descFeedback': feedbackDescription,
        'dateFeedback': feedbackDate,
        'name': name,
        'whatsapp': whatsapp,
        'typeTrash': typeTrash,
        'rating': rating,
      };
}
