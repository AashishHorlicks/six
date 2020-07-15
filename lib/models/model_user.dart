import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';

// To parse this JSON data, do
// final user = userFromJson(jsonString);

User userFromJson(String str) {
  final jsonData = json.decode(str);
  return User.fromJson(jsonData);
}

String userToJson(User data) {
  final dyn = data.toJson();
  return json.encode(dyn);
}

class User {
  String uid;
  String username;
  String email;
  bool isPaidForTest;

  User({
    this.uid,
    this.username,
    this.email,
    this.isPaidForTest,
  });

  factory User.fromJson(Map<String, dynamic> json) => new User(
        uid: json["uid"],
        username: json["username"],
        email: json["email"],
        isPaidForTest: json["isPaidForTest"],
      );

  Map<String, dynamic> toJson() => {
        "uid": uid,
        "username": username,
        "email": email,
        "isPaidForTest": isPaidForTest,
      };

  factory User.fromDocument(DocumentSnapshot doc) {
    return User.fromJson(doc.data);
  }
}
