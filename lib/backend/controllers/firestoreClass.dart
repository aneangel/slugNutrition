import 'package:cloud_firestore/cloud_firestore.dart';
import 'menuItemClass.dart';
import '/src/features/core/screens/profile/dietary_preferences/dietary_preferences_form.dart';
import '/src/features/core/models/profile/dietary_preferences_model.dart';
import 'menuItemClass.dart';
import 'menuFilterService.dart';
import 'package:firebase_auth/firebase_auth.dart';



class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Future<Map<String, List<FilteredMenuItem>>> fetchMenuItemsWithNutritionalFacts(String diningHallId, String mealType) async {
  //   Map<String, List<FilteredMenuItem>> filteredMenuItemsWithNutritionalFacts = {};
  //
  //   // Fetch filtered menu items (already filtered by user's dietary preferences)
  //   Map<String, List<FilteredMenuItem>> filteredMenuItems = await fetchAndFilterCategoriesForMeal(diningHallId, mealType);
  //
  //   for (var category in filteredMenuItems.keys) {
  //     List<FilteredMenuItem> updatedItems = [];
  //     for (var filteredItem in filteredMenuItems[category]!) {
  //       // Use try-catch block for error handling
  //       try {
  //         // Assuming the item's name is the document ID in the 'Nutritional Facts' collection
  //         DocumentSnapshot nutritionSnapshot = await FirebaseFirestore.instance
  //             .collection('Nutritional Facts')
  //             .doc(diningHallId) // diningHallId should be the document ID that represents the dining hall
  //             .collection(mealType) // mealType as subcollection
  //             .doc(filteredItem.name) // filteredItem.name is the dish name
  //             .get();
  //
  //         // Check if the document exists and has data
  //         if (nutritionSnapshot.exists) {
  //           Map<String, dynamic> nutritionData = nutritionSnapshot.data() as Map<String, dynamic>;
  //
  //           // Create a new FilteredMenuItem with nutritional facts
  //           FilteredMenuItem updatedItem = FilteredMenuItem(
  //             name: filteredItem.name,
  //             tags: filteredItem.tags,
  //             nutritionalFacts: nutritionData, // Add nutritionalFacts field in FilteredMenuItem class
  //           );
  //           updatedItems.add(updatedItem);
  //         } else {
  //           // Handle the case when there is no nutritional information for the item
  //           updatedItems.add(filteredItem); // Add the item without nutritional info
  //         }
  //       } catch (e) {
  //         print("Error fetching nutritional facts for item ${filteredItem.name}: $e");
  //         // You may want to handle the error differently depending on your use case
  //       }
  //     }
  //     filteredMenuItemsWithNutritionalFacts[category] = updatedItems;
  //   }
  //
  //   return filteredMenuItemsWithNutritionalFacts;
  // }




  Future<void> printMealCategoriesForAllDiningHalls() async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    CollectionReference diningHalls = db.collection('Dining_Information');
    print("Lund lele");
    QuerySnapshot diningHallSnapshot = await diningHalls.get();

    for (var diningHallDoc in diningHallSnapshot.docs) {
      print('Dining Hall: ${diningHallDoc.id}');
      var data = diningHallDoc.data() as Map<String, dynamic>?;

      ['Breakfast', 'Lunch', 'Dinner', 'Late_Night'].forEach((mealType) {
        if (data?.containsKey(mealType) == true) {
          print('  $mealType Categories:');
          var mealData = data![mealType] as Map<String, dynamic>?;
          mealData?.keys.forEach((key) {
            print('    - $key');
          });
        }
      });

      print('-------------------------------------');
    }
  }




//   Future<Map<String, List<MenuItem>>> fetchMenuItemsForDiningHall(String diningHallId) async {
//     Map<String, List<MenuItem>> allMenuItems = {};
//     try {
//       DocumentSnapshot snapshot = await _db.collection('dining_hall_information').doc(diningHallId).get();
//       if (snapshot.exists && snapshot.data() != null) {
//         Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
//         Map<String, dynamic> categories = data['categories'];
//         print("Raw Data: $data");
//         print("Categories: $categories");
//         categories.forEach((categoryName, categoryItems) {
//           List<dynamic> itemsList = List.from(categoryItems);
//           List<MenuItem> itemList = itemsList.map((item) => MenuItem.fromJson(Map<String, dynamic>.from(item))).toList();
//           allMenuItems[categoryName] = itemList;
//         });
//
//         // Sort the categories by their names
//         var sortedKeys = allMenuItems.keys.toList()..sort();
//         Map<String, List<MenuItem>> sortedAllMenuItems = {};
//         for (var key in sortedKeys) {
//           sortedAllMenuItems[key] = allMenuItems[key]!;
//         }
//
// // Return the sorted map instead
//         return sortedAllMenuItems;
//
//         // Print allMenuItems before returning
//         // print("Fetched data:");
//         // allMenuItems.forEach((category, items) {
//         //   print("Category: $category");
//         //   for (var item in items) {
//         //     print("Item: ${item.name}, Attributes: ${item.attributes}");
//         //   }
//         // });
//       }
//     } catch (e) {
//       print('Error fetching menu items for dining hall $diningHallId: $e');
//     }
//     return {}; // Return an empty map if there was an error or no data
//   }
  Future<Map<String, List<MenuItem>>> fetchCategoriesForMeal(String diningHallId, String mealType) async {
    Map<String, List<MenuItem>> allCategories = {};
    try {
      // Reference to the meal type subcollection
      CollectionReference mealTypeRef = _db.collection('Dining_Information')
          .doc(diningHallId)
          .collection(mealType);

      // Get all documents within the meal type subcollection
      QuerySnapshot querySnapshot = await mealTypeRef.get();
      for (var doc in querySnapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        List<MenuItem> itemList = List.from(data['dishes'])
            .map((item) => MenuItem.fromJson(Map<String, dynamic>.from(item)))
            .toList();
        allCategories[doc.id] = itemList;
      }
    } catch (e) {
      print("Error fetching categories for meal: $e");
    }
    return allCategories;
  }

  Future<DietaryPreferences> getUserDietaryPreferences() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot snapshot = await _db.collection('users')
          .doc(user.email)
          .collection('forms')
          .doc('dietaryPreferencesForm')
          .get();

      if (snapshot.exists && snapshot.data() != null) {
        return DietaryPreferences.fromJson(snapshot.data() as Map<String, dynamic>);
      }
    }
    throw Exception('User not found or user dietary preferences not set');
  }

  Future<Map<String, List<FilteredMenuItem>>> fetchAndFilterCategoriesForMeal(String diningHallId, String mealType) async {
    try {
      // Fetch user dietary preferences
      DietaryPreferences userPrefs = await getUserDietaryPreferences();
      print('die: $userPrefs');

      // Fetch menu items
      Map<String, List<MenuItem>> allCategories = await fetchCategoriesForMeal(diningHallId, mealType);
      print('allCategfories: $allCategories');

      // Filter menu items based on user preferences
      Map<String, List<FilteredMenuItem>> filteredCategories = {};
      allCategories.forEach((category, items) {
        List<FilteredMenuItem> filteredItems = MenuFilterService().filterMenuItems(
          menuItems: items.map((item) => FilteredMenuItem(name: item.name, tags: item.attributes)).toList(), // Convert MenuItem to FilteredMenuItem
          preferences: userPrefs,
        );
        if (filteredItems.isNotEmpty) {
          filteredCategories[category] = filteredItems;
        }
      });
      print("Filterd: $filteredCategories");
      return filteredCategories;
    } catch (e) {
      print("Error fetching and filtering categories for meal: $e");
      return {};
    }
  }

  Future<Map<String, dynamic>> fetchNutritionalFactsForItem(String itemName) async {
    // Get a reference to the Firestore instance
    FirebaseFirestore db = FirebaseFirestore.instance;

    try {
      // Try to get the document for the item
      DocumentSnapshot snapshot = await db.collection('Nutritional Facts').doc(itemName).get();

      // If the document exists, return its data
      if (snapshot.exists) {
        return snapshot.data() as Map<String, dynamic>;
      } else {
        // If the document doesn't exist, return an empty map
        print("No nutritional facts found for $itemName");
        return {};
      }
    } catch (e) {
      // If there's an error, print it and return an empty map
      print("Error fetching nutritional facts for $itemName: $e");
      return {};
    }
  }



  // Method to reformat document names
  String formatDocumentName(String docId) {
    String formattedName = docId
        .replaceAll("CollegeNineJohnR.LewisDiningHall", "College Nine and John R. Lewis")
        .replaceAll("CowellStevensonDiningHall", "Cowell and Stevenson")
        .replaceAll("CrownMerrillDiningHall", "Crown and Merrill")
        .replaceAll("PorterKresgeDiningHall", "Porter and Kresge")
        .replaceAll("RachelCarsonOakesDiningHall", "Rachel Carson and Oakes")
        // This regex looks for groups of uppercase letters and ensures a space is inserted before, unless it's at the start
        .replaceAllMapped(RegExp(r'(?<!^)(?=[A-Z][a-z])'), (match) => ' ');

    return formattedName.trim(); // Trim any leading or trailing spaces
    }

  // Helper method to fetch user dietary preferences
  Future<Map<String, bool>> fetchUserDietaryPreferences(String userId) async {
    Map<String, bool> preferences = {};
    try {
      DocumentSnapshot snapshot = await _db.collection('users').doc(userId).collection('forms').doc('dietaryPreferencesForm').get();
      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
      data.forEach((key, value) {
        if (value is Map) {
          value.forEach((innerKey, innerValue) {
            if (innerValue is bool) {
              preferences[innerKey] = innerValue;
            }
          });
        }
      });
    } catch (e) {
      print(e.toString());
    }
    return preferences;
  }

  // Fetches categories for a specific dining hall
  Future<List<Map<String, dynamic>>> fetchCategories(String diningHallId) async {
    List<Map<String, dynamic>> categoriesList = [];

    try {
      DocumentSnapshot snapshot = await _db.collection('Dining Hall Menus').doc(diningHallId).get();
      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
      var categories = data['categories'] as Map<String, dynamic>;
      categories.forEach((categoryName, items) {
        // each category has an array of items and you want to get the name of the first item.
        String itemName = (items as List).isNotEmpty ? items[0]['name'] : 'No Item';
        categoriesList.add({
          'name': categoryName,
          'itemName': itemName, // This could represent a title or description for the category
        });
      });
    } catch (e) {
      print(e.toString());
    }
    return categoriesList;
  }
}
