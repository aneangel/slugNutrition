import 'package:cloud_firestore/cloud_firestore.dart';
import 'menuItemClass.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:liquid_swipe/liquid_swipe.dart';
import 'package:slugnutrition/src/constants/sizes.dart';
import 'package:get/get.dart';
import 'package:slugnutrition/src/features/core/screens/bmi/bmi.dart';
import '/src/features/core/screens/dashboard/dashboard.dart';
import '/src/features/core/models/profile/dietary_preferences_model.dart';
import '/src/features/core/screens/profile/dietary_preferences/dietary_preferences_form.dart';


class FilteredMenuItem {
  final String name;
  final List<String> tags; // Example: ['vegan', 'containsPeanuts']
  Map<String, dynamic>? nutritionalFacts;

  FilteredMenuItem({required this.name, required this.tags, this.nutritionalFacts});

  factory FilteredMenuItem.fromJson(Map<String, dynamic> json) {
    return FilteredMenuItem(
      name: json['name'],
      tags: List<String>.from(json['tags']),
    );
  }
}



class MenuFilterService {
  List<FilteredMenuItem> filterMenuItems({
    required List<FilteredMenuItem> menuItems,
    required DietaryPreferences preferences,
  }) {
    var filteredItems = menuItems.where((item) {
      print("Filtering item: ${item.name}");
      var meetsRestrictions = _meetsDietaryRestrictions(item, preferences.dietaryRestriction);
      var containsAllergens = _containsAllergens(item, preferences.allergies);
      var isDisliked = _isDisliked(item, preferences.dislikes);
      var matchesAdditionalPreferences = _matchesAdditionalPreferences(item, preferences.preferences);

      var shouldInclude = meetsRestrictions && !containsAllergens && !isDisliked && matchesAdditionalPreferences;
      print("Should include '${item.name}': $shouldInclude");
      return shouldInclude;
    }).toList();

    return filteredItems;
  }

  bool _meetsDietaryRestrictions(FilteredMenuItem item, String dietaryRestriction) {
    bool meets = false;
    switch (dietaryRestriction.toLowerCase()) {
      case 'vegan':
        meets = item.tags.contains('vegan');
        break;
      case 'vegetarian':
        meets = item.tags.contains('vegetarian');
        break;
      default:
        meets = true;
        break;
    }
    print("Meets dietary restrictions (${dietaryRestriction}): $meets");
    return meets;
  }

  bool _containsAllergens(FilteredMenuItem item, Map<String, bool> allergies) {
    // If "None" is true, it means no allergies, so return false for contains allergens.
    if (allergies['None'] == true) {
      return false;
    }

    // Check for specific allergies.
    bool contains = allergies.entries.any((entry) {
      // Skip the "None" entry.
      if (entry.key != "None") {
        return entry.value && item.tags.any((tag) => tag.toLowerCase().contains(entry.key.toLowerCase()));
      }
      return false;
    });
    print("Contains allergens: $contains");
    return contains;
  }

  bool _isDisliked(FilteredMenuItem item, Map<String, bool> dislikes) {
    // If "None" is true, it means no dislikes, so return false for is disliked.
    if (dislikes['None'] == true) {
      return false;
    }

    // Check for specific dislikes.
    bool isDisliked = dislikes.entries.any((entry) {
      // Skip the "None" entry.
      if (entry.key != "None") {
        return entry.value && item.tags.any((tag) => tag.toLowerCase().contains(entry.key.toLowerCase()));
      }
      return false;
    });
    print("Is disliked: $isDisliked");
    return isDisliked;
  }

  bool _matchesAdditionalPreferences(FilteredMenuItem item, Map<String, bool> preferences) {
    // Check if the user has any specific preferences selected other than "None".
    var hasSpecificPreferences = preferences.entries.any((entry) => entry.key != "None" && entry.value);

    // If no specific preferences, return true for all items.
    if (!hasSpecificPreferences) return true;

    // Otherwise, only include items that match the selected preferences.
    return preferences.entries.every(
          (entry) {
        // Skip checking if "None" is selected or if the preference is not selected.
        if (entry.key == "None" || !entry.value) return true;

        // Check if the item matches the preference.
        return item.tags.contains(entry.key.toLowerCase());
      },
    );
  }

}
