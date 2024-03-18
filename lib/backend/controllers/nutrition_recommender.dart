import 'package:cloud_firestore/cloud_firestore.dart';
import 'menuItemClass.dart';
import '/src/features/core/screens/profile/dietary_preferences/dietary_preferences_form.dart';
import '/src/features/core/models/profile/dietary_preferences_model.dart';
import 'menuItemClass.dart';
import 'menuFilterService.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NutritionRecommender {
  final List<MenuItem> availableItems;
  final int dailyCalories;
  final int dailyProtein;

  NutritionRecommender({
    required this.availableItems,
    required this.dailyCalories,
    required this.dailyProtein,
  });

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> recommendDailyIntake(String userId) async {
    try {
      // Fetch the user's age, gender, weight, and height from Firebase
      var userProfile = await _db.collection('users').doc(userId).get();
      var userData = userProfile.data();
      int age = userData['age'];
      String gender = userData['gender'];
      double weight = userData['weight'];
      double height = userData['height'];

      // Calculate daily needs
      double dailyCalories = calculateDailyCalorieNeeds(age, gender, weight, height);
      double dailyProtein = calculateDailyProteinNeeds(weight);

      // Now you have the calories and protein needs, you can use these to make recommendations
      // Code to recommend the best nutritious food from each dining in their respective meal types would go here.

    } catch (e) {
      print('Error recommending daily intake: $e');
    }
  }


  // Assuming a simple formula for Basal Metabolic Rate (BMR)
// Mifflin-St Jeor Equation:
// For men: BMR = 10 * weight(kg) + 6.25 * height(cm) - 5 * age(y) + 5
// For women: BMR = 10 * weight(kg) + 6.25 * height(cm) - 5 * age(y) - 161

  double calculateDailyCalorieNeeds(int age, String gender, double weight, double height) {
    double bmr;

    if (gender.toLowerCase() == "male") {
      bmr = (10 * weight) + (6.25 * height) - (5 * age) + 5;
    } else {
      bmr = (10 * weight) + (6.25 * height) - (5 * age) - 161;
    }

    // Assuming a sedentary activity level multiplier of 1.2
    double dailyCalories = bmr * 1.2;

    return dailyCalories;
  }

  double calculateDailyProteinNeeds(double weight) {
    // Recommended daily allowance (RDA) for protein is 0.8 grams per kilogram of body weight.
    // This RDA may vary depending on the individual's activity level, age, and overall health.

    double dailyProtein = weight * 0.8;

    return dailyProtein;
  }

}

// Use the recommender
var recommender = NutritionRecommender(
  availableItems: filteredMenuItems, // This would be your filtered list of items
  dailyCalories: userCaloricNeeds,
  dailyProtein: userProteinNeeds,
);

var recommendedMeals = recommender.getRecommendedMeals();
