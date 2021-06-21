// To parse this JSON data, do
//
//     final productDetailsResponse = productDetailsResponseFromJson(jsonString);
// https://app.quicktype.io/
import 'dart:convert';

GPS GPSResponseFromJson(String str) => GPS.fromJson(json.decode(str));

String GPSToJson(GPS data) => json.encode(data.toJson());

class GPS {
  GPS({
    this.detailed_user,
    this.message,
    this.status,
    this.isAuthenticated,
  });

  DetailedUser detailed_user;
  String message;
  int isAuthenticated;
  int status;

  factory GPS.fromJson(Map<String, dynamic> json) => GPS(
      detailed_user: DetailedUser.fromJson(json["data"]),
      message: json["message"],
      status: json["status"],
      isAuthenticated: json["isAuthenticated"]);

  Map<String, dynamic> toJson() => {
        "data": detailed_user.toJson(),
        "message": message,
        "status": status,
        "isAuthenticated": isAuthenticated
      };
}

class DetailedUser {
  DetailedUser({this.user_token_text, this.user_static_token, this.user_type});

  String user_token_text;
  String user_static_token;
  String user_type;
  factory DetailedUser.fromJson(Map<String, dynamic> json) => DetailedUser(
      user_token_text: json['user_token_text'],
      user_static_token: json['user_static_token'],
      user_type: json['user_type'].toString());

  Map<String, dynamic> toJson() => {
        "user_token_text": user_token_text,
        "user_static_token": user_static_token,
        "user_type": user_type
      };
}
