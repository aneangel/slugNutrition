import 'package:flutter/material.dart';
import '../../screens/bmi/bmi.dart';

class BMIModel {
  double height;
  double weight;
  double bmi;
  String activityLevel;
  String gender;
  String name;
  int age;
  String profileImageUrl; // If you want to store the image URL after uploading it to Firebase Storage

  BMIModel({
    required this.height,
    required this.weight,
    required this.bmi,
    required this.activityLevel,
    required this.gender,
    required this.name,
    required this.age,
    this.profileImageUrl = '',
  });

  Map<String, dynamic> toJson() => {
    'height': height,
    'weight': weight,
    'bmi': bmi,
    'activityLevel': activityLevel,
    'gender': gender,
    'name': name,
    'age': age,
    'profileImageUrl': profileImageUrl,
  };
}