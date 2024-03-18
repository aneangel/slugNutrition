import 'package:flutter/material.dart';
import '../../screens/profile/dietary_preferences/dietary_preferences_form.dart';

class DietaryPreferences {
  String dietaryRestriction;
  String dietaryLaw;
  Map<String, bool> allergies;
  Map<String, bool> preferences;
  Map<String, bool> dislikes;
  bool consent;

  DietaryPreferences({
    this.dietaryRestriction = 'None',
    this.dietaryLaw = 'None',
    required this.allergies,
    required this.preferences,
    required this.dislikes,
    this.consent = false,
  });

  Map<String, dynamic> toJson() => {
    'dietaryRestriction': dietaryRestriction,
    'dietaryLaw': dietaryLaw,
    'allergies': allergies,
    'preferences': preferences,
    'dislikes': dislikes,
    'consent': consent,
  };

  factory DietaryPreferences.fromJson(Map<String, dynamic> json) {
    return DietaryPreferences(
      dietaryRestriction: json['dietaryRestriction'] ?? 'None',
      dietaryLaw: json['dietaryLaw'] ?? 'None',
      allergies: Map<String, bool>.from(json['allergies']),
      preferences: Map<String, bool>.from(json['preferences']),
      dislikes: Map<String, bool>.from(json['dislikes']),
      consent: json['consent'] ?? false,
    );
  }
}