import 'dart:convert';
import 'dart:io';

AuthRequest authRequestFromJson(String str) => AuthRequest.fromJson(json.decode(str));

String authRequestToJson(AuthRequest data) => json.encode(data.toJson());

class AuthRequest {
  String? name;
  String? email;
  String? password;
  String? whatsapp;
  String? imageProfile;
  File? imageFile;
  File? identityFile;

  AuthRequest({
    this.name,
    this.email,
    this.password,
    this.whatsapp,
    this.imageProfile,
    this.imageFile,
    this.identityFile,
  });

  factory AuthRequest.fromJson(Map<String, dynamic> json) => AuthRequest(
        name: json["name"],
        email: json["email"],
        password: json["password"],
        imageProfile: json["imageProfile"],
        whatsapp: json["whatsapp"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "email": email,
        "password": password,
        "whatsapp": whatsapp,
        "imageProfile": imageProfile,
      };
}
