import 'package:cloud_firestore/cloud_firestore.dart';
import 'menuItemClass.dart';
import '/src/features/core/screens/profile/dietary_preferences/dietary_preferences_form.dart';
import '/src/features/core/models/profile/dietary_preferences_model.dart';
import 'menuItemClass.dart';
import 'menuFilterService.dart';
import 'package:firebase_auth/firebase_auth.dart';



class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // // Fetches categories and their menu items for a specific dining hall
  // Future<Map<String, List<MenuItem>>> fetchCategoriesAndMenuItems(String diningHallId) async {
  //   Map<String, List<MenuItem>> categoriesWithMenuItems = {};
  //   try {
  //     DocumentSnapshot snapshot = await _db.collection('Dining Hall Menus').doc(diningHallId).get();
  //     Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
  //     data.forEach((category, items) {
  //       List<MenuItem> itemList = (items as List).map((item) => MenuItem.fromJson(item)).toList();
  //       categoriesWithMenuItems[category] = itemList;
  //     });
  //   } catch (e) {
  //     print(e.toString());
  //   }
  //   return categoriesWithMenuItems;
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









  // Fetches categories and their menu items for a specific dining hall
  // Future<Map<String, List<MenuItem>>> fetchCategoriesAndMenuItems(String diningHallId) async {
  //   Map<String, List<MenuItem>> categoriesWithMenuItems = {};
  //   try {
  //     DocumentSnapshot snapshot = await _db.collection('Dining Hall Menus').doc(diningHallId).get();
  //     Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
  //     data.forEach((category, items) {
  //       List<MenuItem> itemList = (items as List).map((item) => MenuItem.fromJson(item)).toList();
  //       categoriesWithMenuItems[category] = itemList;
  //     });
  //   } catch (e) {
  //     print(e.toString());
  //   }
  //   return categoriesWithMenuItems;
  // }
  //
  // Future<List<String>> fetchDiningHallMenuNames() async {
  //   List<String> menuNames = [];
  //   try {
  //     QuerySnapshot snapshot = await _db.collection('Dining Hall Menus').get();
  //     for (var doc in snapshot.docs) {
  //       String formattedName = formatDocumentName(doc.id);
  //       menuNames.add(formattedName);
  //     }
  //   } catch (e) {
  //     print(e.toString());
  //   }
  //   return menuNames;
  // }

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

    // New method to fetch user-specific menu items
  // Future<Map<String, List<MenuItem>>> fetchUserSpecificMenuItems(String diningHallId, String userId) async {
  //   // First, fetch the user's dietary preferences
  //   Map<String, bool> userPreferences = await fetchUserDietaryPreferences(userId);
  //
  //   // Next, fetch all menu items for the specified dining hall
  //   Map<String, List<MenuItem>> allMenuItems = await fetchCategoriesAndMenuItems(diningHallId);
  //
  //   // Filter menu items based on user preferences
  //   Map<String, List<MenuItem>> filteredMenuItems = {};
  //   allMenuItems.forEach((category, items) {
  //     List<MenuItem> filteredItems = items.where((item) {
  //       // Check each item's attributes against user preferences
  //       for (var attribute in item.attributes) {
  //         if (userPreferences.containsKey(attribute) && !userPreferences[attribute]!) {
  //           // If the user has a preference that contradicts this attribute, exclude the item
  //           return false;
  //         }
  //       }
  //       return true; // Include the item if none of its attributes are contradicted by user preferences
  //     }).toList();
  //     filteredMenuItems[category] = filteredItems;
  //   });
  //
  //   return filteredMenuItems;
  // }

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
