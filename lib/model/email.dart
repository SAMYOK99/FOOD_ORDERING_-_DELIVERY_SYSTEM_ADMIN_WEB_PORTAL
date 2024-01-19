import 'package:cloud_firestore/cloud_firestore.dart';

class Email {
  late String? userId;
  String? userEmail;
  String? role;


  Email({
    this.userId,
    this.userEmail,
    this.role,
  });

  Email.fromJson(Map<String, dynamic> json) {
    userId = json["userId"];
    userEmail = json["userEmail"];
    role = json["role"];

  }


  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["userId"] = userId;
    data["userEmail"] = userEmail;
    data["role"] = role;
    return data;
  }
}
