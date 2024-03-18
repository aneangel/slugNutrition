import 'package:flutter/material.dart';

class UserModel {
  final String? email;
  final String? password;
  final String? fullName;
  final String? phoneNo;

  UserModel({this.email, this.password, this.fullName, this.phoneNo});

  Map<String, dynamic> toJson() => {
    'email': email,
    'fullName': fullName,
    'phoneNo': phoneNo,
    // You might not want to save the password in Firestore for security reasons
    // 'password': password,
  };
}