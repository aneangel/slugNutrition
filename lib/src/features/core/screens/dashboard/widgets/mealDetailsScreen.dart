import 'package:flutter/material.dart';
import 'package:slugnutrition/backend/controllers/menuFilterService.dart';
import 'package:slugnutrition/backend/controllers/menuItemClass.dart'; // Assuming this has FilteredMenuItem definition.
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class UCSCColors {
  static const santaCruzBlue = Color(0xFF124559);
  static const gold = Color(0xFFF29813); // Using vibrant option for demonstration
}

class MealDetailsScreen extends StatefulWidget {
  final String hallName;
  final String mealCategory;
  final Future<Map<String, List<FilteredMenuItem>>> allMenuItemsFuture;

  const MealDetailsScreen({
    Key? key,
    required this.hallName,
    required this.mealCategory,
    required this.allMenuItemsFuture,
  }) : super(key: key);

  @override
  _MealDetailsScreenState createState() => _MealDetailsScreenState();
}

class _MealDetailsScreenState extends State<MealDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.mealCategory} Options'),
      ),
      body: FutureBuilder<Map<String, List<FilteredMenuItem>>>(
        future: widget.allMenuItemsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error.toString()}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No menu items found"));
          } else {
            List<Widget> menuItemsWidgets = [];
            snapshot.data!.forEach((category, items) {
              // Category title
              menuItemsWidgets.add(
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    category,
                    style: Theme
                        .of(context)
                        .textTheme
                        .headline6!
                        .copyWith(
                        color: Colors.black, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
              );

              // List of items for this category
              items.forEach((item) {
                // Use the _buildDishExpansionTile method to create the widget for each item
                Widget dishWidget = _buildDishExpansionTile(item);

                // Add the returned widget to your list of widgets
                menuItemsWidgets.add(dishWidget);
              });

              // Add spacing after each category
              menuItemsWidgets.add(SizedBox(height: 10));
            });

            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(children: menuItemsWidgets),
              ),
            );
          }
        },
      ),
    );
  }


  // This function is assumed to be in the _MealDetailsScreenState class

  Widget _buildDishExpansionTile(FilteredMenuItem item) {
    return Card(
      color: UCSCColors.santaCruzBlue,
      child: ExpansionTile(
        title: Text(item.name, style: TextStyle(color: Colors.white)),
        iconColor: UCSCColors.gold,
        collapsedIconColor: UCSCColors.gold,
        children: <Widget>[
          FutureBuilder<Map<String, dynamic>>(
      future: fetchNutritionalFacts(widget.hallName, widget.mealCategory, item.name),
      builder: (context, snapshot) {
        print("FutureBuilder snapshot state: ${snapshot.connectionState}, hasData: ${snapshot.hasData}, hasError: ${snapshot.hasError}");

        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          print("Error: ${snapshot.error}");
          return Text("Error: ${snapshot.error}");
        } else if (snapshot.hasData) {
          // Assuming your nutritional facts data structure matches your needs
          Map<String, dynamic> nutritionalFacts = snapshot.data!;

          print("Nutritional Facts: $nutritionalFacts");
          return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Wrap(
                        spacing: 8.0, // Space between icons
                        children: item.tags.map((tag) => _buildAttributeIcon(tag)).toList(),
                      ),
                      Divider(color: Colors.white),
                      Text(
                        'Nutritional Facts',
                        style: Theme.of(context).textTheme.subtitle1!.copyWith(color: UCSCColors.gold),
                      ),
                      // Display each nutritional fact
                      if (nutritionalFacts.containsKey('Calories')) Text('Calories: ${nutritionalFacts['Calories']}', style: TextStyle(color: Colors.white)),
                      if (nutritionalFacts.containsKey('Protein')) Text('Protein: ${nutritionalFacts['Protein']}g', style: TextStyle(color: Colors.white)),
                      if (nutritionalFacts.containsKey('Tot. Carb.')) Text('Carbs: ${nutritionalFacts['Tot. Carb.']}g', style: TextStyle(color: Colors.white)),
                      if (nutritionalFacts.containsKey('Sugars')) Text('Sugar: ${nutritionalFacts['Sugars']}g', style: TextStyle(color: Colors.white)),
                      // Add more nutritional facts as needed
                    ],
                  ),
                );
              } else {
                return Text("No nutritional facts found", style: TextStyle(color: Colors.white));
              }
            },
          ),
        ],
      ),
    );
  }


  Future<Map<String, dynamic>> fetchNutritionalFacts(String diningHallName, String mealType, String itemName) async {
    FirebaseFirestore db = FirebaseFirestore.instance; // Get instance of Firestore

    try {
      // Navigate to the specific document based on dining hall name, meal type, and item name
      DocumentSnapshot snapshot = await db.collection('Nutritional Facts')
          .doc(diningHallName)
          .collection(mealType)
          .doc(itemName)
          .get();

      if (snapshot.exists && snapshot.data() != null) {
        // If the document exists and has data, extract the attributes subfield for nutritional facts
        Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
        Map<String, dynamic> attributes = data['attributes'] ?? {};

        // Return the attributes map which contains nutritional facts
        return attributes;
      } else {
        // If the document does not exist, log a message and return an empty map
        print("No nutritional facts found for item: $itemName in $mealType of $diningHallName");
        return {};
      }
    } catch (e) {
      // If there is any error, log the error and return an empty map
      print("Error fetching nutritional facts for item: $itemName in $mealType of $diningHallName - $e");
      return {};
    }
  }

//   Future<Map<String, dynamic>> fetchNutritionalFacts(String diningHallName, String mealType, String itemName) async {
//   FirebaseFirestore db = FirebaseFirestore.instance;
//
//   try {
//     DocumentSnapshot snapshot = await db.collection('Nutritional Facts')
//         .doc(diningHallName)
//         .collection(mealType)
//         .doc(itemName)
//         .get();
//
//     if (snapshot.exists && snapshot.data() != null) {
//       Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
//       // Assuming 'Attributes' is a Map and 'Name' is a field in the document.
//       if (data.containsKey('Attributes') && data['Name'] == itemName) {
//         return data['Attributes'] as Map<String, dynamic>;
//       } else {
//         print("Attributes not found or name mismatch for item: $itemName");
//         return {};
//       }
//     } else {
//       print("No nutritional facts found for item: $itemName in $mealType of $diningHallName");
//       return {};
//     }
//   } catch (e) {
//     print("Error fetching nutritional facts for item: $itemName in $mealType of $diningHallName - $e");
//     return {};
//   }
// }







  Future<String> getAttributeImageUrl(String attributeTag) async {
    // Convert attributeTag to lowercase to match the file names in Firebase Storage
    String formattedTag = attributeTag.toLowerCase();
    String imageUrl = await FirebaseStorage.instance.ref('$formattedTag.gif').getDownloadURL();
    return imageUrl;
  }

  Widget _buildAttributeIcon(String tag) {
    return FutureBuilder(
      future: getAttributeImageUrl(tag),
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.hasData) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(12), // Adjust the radius to your liking
            child: Image.network(
              snapshot.data!,
              width: 25,
              height: 25,
              fit: BoxFit.cover,
            ),
          );
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return SizedBox(
            width: 30,
            height: 30,
            child: CircularProgressIndicator(),
          );
        } else {
          return Icon(Icons.error); // If the image doesn't load, you can return an error icon
        }
      },
    );
  }


}


