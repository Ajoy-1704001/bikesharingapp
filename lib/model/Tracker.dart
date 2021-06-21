// To parse this JSON data, do
//
//     final productDetailsResponse = productDetailsResponseFromJson(jsonString);
// https://app.quicktype.io/
import 'dart:convert';

Tracker TrackerResponseFromJson(String str) =>
    Tracker.fromJson(json.decode(str));

String TrackerToJson(Tracker data) => json.encode(data.toJson());

class Tracker {
  Tracker({
    this.detailed_user,
    this.message,
    this.status,
    this.isAuthenticated,
  });

  List<DetailedUser> detailed_user;
  String message;
  int isAuthenticated;
  int status;

  factory Tracker.fromJson(Map<String, dynamic> json) => Tracker(
      detailed_user: List<DetailedUser>.from(
          json["data"].map((x) => DetailedUser.fromJson(x))),
      message: json["message"],
      status: json["status"],
      isAuthenticated: json["isAuthenticated"]);

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(detailed_user.map((x) => x.toJson())),
        "message": message,
        "status": status,
        "isAuthenticated": isAuthenticated
      };
}

class DetailedUser {
  DetailedUser({this.deviceId, this.packet});

  String deviceId;
  List<Packet> packet;

  factory DetailedUser.fromJson(Map<String, dynamic> json) => DetailedUser(
        deviceId: json['deviceId'],
        packet:
            List<Packet>.from(json["packet"].map((x) => Packet.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "deviceId": deviceId,
        "packet": List<dynamic>.from(packet.map((x) => x.toJson())),
      };
}

class Packet {
  Packet({this.receive_time, this.lon, this.lat});

  String receive_time;
  String lon;
  String lat;

  factory Packet.fromJson(Map<String, dynamic> json) => Packet(
      receive_time: json['receive_time'], lon: json['lon'], lat: json['lat']);

  Map<String, dynamic> toJson() =>
      {"receive": receive_time, "lon": lon, "lat": lat};
}
