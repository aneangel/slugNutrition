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
}