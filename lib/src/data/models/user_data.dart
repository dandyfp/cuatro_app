// To parse this JSON data, do
//
//     final userData = userDataFromJson(jsonString);

import 'dart:convert';

UserData userDataFromJson(String str) => UserData.fromJson(json.decode(str));

String userDataToJson(UserData data) => json.encode(data.toJson());

class UserData {
  String? name;
  String? email;
  String? password;
  String? role;
  String? uid;

  UserData({
    this.name,
    this.email,
    this.password,
    this.role,
    this.uid,
  });

  factory UserData.fromJson(Map<String, dynamic> json) => UserData(
        name: json["name"],
        email: json["email"],
        password: json["password"],
        role: json["role"],
        uid: json["uid"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "uid": uid,
        "email": email,
        "password": password,
        "role": role,
      };
}
