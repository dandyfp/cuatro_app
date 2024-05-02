import 'dart:convert';

AuthRequest authRequestFromJson(String str) => AuthRequest.fromJson(json.decode(str));

String authRequestToJson(AuthRequest data) => json.encode(data.toJson());

class AuthRequest {
  String? name;
  String? email;
  String? password;

  AuthRequest({
    this.name,
    this.email,
    this.password,
  });

  factory AuthRequest.fromJson(Map<String, dynamic> json) => AuthRequest(
        name: json["name"],
        email: json["email"],
        password: json["password"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "email": email,
        "password": password,
      };
}
