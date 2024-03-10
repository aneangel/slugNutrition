import 'package:cloud_firestore/cloud_firestore.dart';
import 'menuItemClass.dart';

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

  Future<void> printCategoriesAndContentsFromDiningHall(String diningHallId) async {
    try {
      // Get the document for the specified dining hall
      DocumentSnapshot diningHallDoc = await _db.collection('Dining Hall Menus').doc(diningHallId).get();

      // Check if the document exists and has data
      if (diningHallDoc.exists && diningHallDoc.data() != null) {
        // Cast the data to a Map<String, dynamic>
        Map<String, dynamic> data = diningHallDoc.data() as Map<String, dynamic>;

        // Access the 'categories' field, which should be a Map
        Map categories = data['categories'];
        var sortedCategories = categories.keys.toList()..sort();
        for (var categoryName in sortedCategories) {
          print('Category: $categoryName');
          List items = categories[categoryName];
          for (var item in items) {
            print('Item: ${item['name']}');
            // If 'attributes' is a list of strings, we print them directly
            if (item['attributes'] != null) {
              List attributes = item['attributes'];
              print('Attributes: $attributes');
            }
          }
        }
        // // Iterate over each category
        // categories.forEach((categoryName, categoryContents) {
        //   print('Category: $categoryName');
        //
        //   // 'categoryContents' should be a List of items
        //   List items = categoryContents;
        //   for (var item in items) {
        //     print('Item: ${item['name']}');
        //     // If 'attributes' is a list of strings, we print them directly
        //     if (item['attributes'] != null) {
        //       List attributes = item['attributes'];
        //       print('Attributes: $attributes');
        //     }
        //   }
        // });
      } else {
        print('Document does not exist or has no data');
      }
    } catch (e) {
      print('Error fetching categories and contents: $e');
    }
  }

  Future<void> printCategoriesFromDiningHall(String diningHallId) async {
    try {
      // Get the document for the specified dining hall
      DocumentSnapshot diningHallDoc = await _db.collection('Dining Hall Menus').doc(diningHallId).get();

      // Check if the document exists and has data
      if (diningHallDoc.exists && diningHallDoc.data() != null) {
        // Cast the data to a Map<String, dynamic>
        Map<String, dynamic> data = diningHallDoc.data() as Map<String, dynamic>;

        // Access the 'categories' field, which should be a Map
        Map categories = data['categories'];

        // Print each category name
        for (String category in categories.keys) {
          print(category);
        }
      } else {
        print('Document does not exist or has no data');
      }
    } catch (e) {
      print('Error fetching categories: $e');
    }
  }

  Future<Map<String, List<MenuItem>>> fetchMenuItemsForDiningHall(String diningHallId) async {
    Map<String, List<MenuItem>> allMenuItems = {};
    try {
      DocumentSnapshot snapshot = await _db.collection('Dining Hall Menus').doc(diningHallId).get();
      if (snapshot.exists && snapshot.data() != null) {
        Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
        Map<String, dynamic> categories = data['categories'];
        // print("Raw Data: $data");
        // print("Categories: $categories");
        categories.forEach((categoryName, categoryItems) {
          List<dynamic> itemsList = List.from(categoryItems);
          List<MenuItem> itemList = itemsList.map((item) => MenuItem.fromJson(Map<String, dynamic>.from(item))).toList();
          allMenuItems[categoryName] = itemList;
        });

        // Print allMenuItems before returning
        // print("Fetched data:");
        // allMenuItems.forEach((category, items) {
        //   print("Category: $category");
        //   for (var item in items) {
        //     print("Item: ${item.name}, Attributes: ${item.attributes}");
        //   }
        // });
      }
    } catch (e) {
      print('Error fetching menu items for dining hall $diningHallId: $e');
    }
    return allMenuItems;
  }



  // Fetches categories and their menu items for a specific dining hall
  Future<Map<String, List<MenuItem>>> fetchCategoriesAndMenuItems(String diningHallId) async {
    Map<String, List<MenuItem>> categoriesWithMenuItems = {};
    try {
      DocumentSnapshot snapshot = await _db.collection('Dining Hall Menus').doc(diningHallId).get();
      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
      Map<String, dynamic> categories = data['categories'];
      categories.forEach((categoryName, categoryItems) {
        List<dynamic> itemsList = List.from(categoryItems); // Casting to a List from dynamic
        List<MenuItem> itemList = itemsList.map((item) {
          // Convert each item map to a MenuItem object
          return MenuItem.fromJson(Map<String, dynamic>.from(item));
        }).toList();
        categoriesWithMenuItems[categoryName] = itemList;
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