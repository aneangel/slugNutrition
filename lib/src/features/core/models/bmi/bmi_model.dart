import 'package:flutter/material.dart';

class BmiData {
  final double height;
  final double weight;
  final String heightUnit; // 'cm' or 'ft'
  final String weightUnit; // 'kg' or 'lbs'
  // You can add more fields if necessary, like age, gender, etc.

  BmiData({
    required this.height,
    required this.weight,
    this.heightUnit = 'cm',
    this.weightUnit = 'kg',
  });

  // Optionally, you could add a method to calculate BMI within this class
  double calculateBmi() {
    // This is a simplified calculation assuming metric units
    if (height <= 0) return 0;
    double heightInMeters = heightUnit == 'cm' ? height / 100 : convertFeetInchesToMeters(height);
    return weight / (heightInMeters * heightInMeters);
  }

  // Helper method to convert feet and inches to meters, if you decide to include it
  double convertFeetInchesToMeters(double height) {
    // Implement conversion logic
    return height; // Placeholder
  }

  // Example method to convert this object into a map, which could be useful for Firestore
  Map<String, dynamic> toJson() {
    return {
      'height': height,
      'weight': weight,
      'heightUnit': heightUnit,
      'weightUnit': weightUnit,
    };
  }

  // Example factory method to create a BmiData object from a map
  factory BmiData.fromJson(Map<String, dynamic> json) {
    return BmiData(
      height: json['height'],
      weight: json['weight'],
      heightUnit: json['heightUnit'] ?? 'cm',
      weightUnit: json['weightUnit'] ?? 'kg',
    );
  }
}
