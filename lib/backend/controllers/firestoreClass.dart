import 'package:cloud_firestore/cloud_firestore.dart';
import 'menuItemClass.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Fetches categories and their menu items for a specific dining hall
  Future<Map<String, List<MenuItem>>> fetchCategoriesAndMenuItems(String diningHallId) async {
    Map<String, List<MenuItem>> categoriesWithMenuItems = {};
    try {
      DocumentSnapshot snapshot = await _db.collection('Dining Hall Menus').doc(diningHallId).get();
      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
      data.forEach((category, items) {
        List<MenuItem> itemList = (items as List).map((item) => MenuItem.fromJson(item)).toList();
        categoriesWithMenuItems[category] = itemList;
      });
    } catch (e) {
      print(e.toString());
    }
    return categoriesWithMenuItems;
  }

  Future<List<String>> fetchDiningHallMenuNames() async {
    List<String> menuNames = [];
    try {
      QuerySnapshot snapshot = await _db.collection('Dining Hall Menus').get();
      for (var doc in snapshot.docs) {
        String formattedName = formatDocumentName(doc.id);
        menuNames.add(formattedName);
      }
    } catch (e) {
      print(e.toString());
    }
    return menuNames;
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

    // New method to fetch user-specific menu items
  Future<Map<String, List<MenuItem>>> fetchUserSpecificMenuItems(String diningHallId, String userId) async {
    // First, fetch the user's dietary preferences
    Map<String, bool> userPreferences = await fetchUserDietaryPreferences(userId);

    // Next, fetch all menu items for the specified dining hall
    Map<String, List<MenuItem>> allMenuItems = await fetchCategoriesAndMenuItems(diningHallId);

    // Filter menu items based on user preferences
    Map<String, List<MenuItem>> filteredMenuItems = {};
    allMenuItems.forEach((category, items) {
      List<MenuItem> filteredItems = items.where((item) {
        // Check each item's attributes against user preferences
        for (var attribute in item.attributes) {
          if (userPreferences.containsKey(attribute) && !userPreferences[attribute]!) {
            // If the user has a preference that contradicts this attribute, exclude the item
            return false;
          }
        }
        return true; // Include the item if none of its attributes are contradicted by user preferences
      }).toList();
      filteredMenuItems[category] = filteredItems;
    });

    return filteredMenuItems;
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
