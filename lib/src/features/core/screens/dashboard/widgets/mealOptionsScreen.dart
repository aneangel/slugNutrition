import 'package:flutter/material.dart';
import 'mealDetailsScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:slugnutrition/backend/controllers/firestoreClass.dart';
import 'package:slugnutrition/backend/controllers/menuFilterService.dart'; // Assume this is where your MenuFilterService is defined

class MealOptionsScreen extends StatelessWidget {
  final String hallName;

  MealOptionsScreen({Key? key, required this.hallName}) : super(key: key);

  final List<Map<String, String>> mealOptions = [
    {
      'name': 'Breakfast',
      'image': 'assets/images/meals/breakfast1.png',
    },
    {
      'name': 'Lunch',
      'image': 'assets/images/meals/lunch.png',
    },
    {
      'name': 'Dinner',
      'image': 'assets/images/meals/chicken.png',
    },
    {
      'name': 'Late_Night',
      'image': 'assets/images/meals/lateNight.png',
    },
    // ... other meal options ...
  ];

  // // A method to navigate to MealDetailsScreen after fetching all menu items
  // // Inside MealOptionsScreen, when you navigate:
  // void navigateToMealDetails(BuildContext context, String mealCategory) async {
  //   FirestoreService firestoreService = FirestoreService();
  //   var allMenuItemsFuture = firestoreService.fetchMenuItemsForDiningHall(hallName);
  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(
  //       builder: (context) => MealDetailsScreen(
  //         hallName: hallName,
  //         mealCategory: mealCategory,
  //         allMenuItemsFuture: allMenuItemsFuture,
  //       ),
  //     ),
  //   );
  // }

  String formatHallName(String hallName) {
    // Adjust this method based on your hallName patterns and Firestore document IDs
    return hallName.replaceAll(RegExp(r'\s+|\n'), '');
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(hallName),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(25),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // Number of columns
          crossAxisSpacing: 30, // Horizontal space between items
          mainAxisSpacing: 30, // Vertical space between items
          childAspectRatio: 1, // Aspect ratio of the grid tiles
        ),
        itemCount: mealOptions.length,
        itemBuilder: (context, index) {
          return Card(
            elevation: 10,
            shadowColor: Colors.grey.withOpacity(0.5), // Custom shadow color
            clipBehavior: Clip.antiAlias,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: InkWell(
              onTap: () async {
                String formattedHallName = formatHallName(hallName);
                // print("Formatted hallName OP: $formattedHallName");
                // print("hallname OP: $hallName");// Debug print
                var mealName = mealOptions[index]['name'] ?? 'defaultMealName';
                // print("mealName: $mealName");
                var filteredMenuItemsFuture = FirestoreService().fetchAndFilterCategoriesForMeal(formatHallName(hallName), mealName);
                filteredMenuItemsFuture.then((filteredData) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MealDetailsScreen(
                        hallName: hallName,
                        mealCategory: mealName,
                        allMenuItemsFuture: Future.value(filteredData), // Pass the filtered data to MealDetailsScreen
                      ),
                    ),
                  );
                }).catchError((error) {
                  print("Error fetching and filtering data: $error");
                });
              },
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: Image.asset(
                      mealOptions[index]['image']!,
                      width: 90,
                      height: 90,
                    ),
                  ),
                  Positioned(
                    left: 8,
                    bottom: 8,
                    child: Text(
                      mealOptions[index]['name']!,
                      style: TextStyle(
                        color: Color(0xFF003366),
                        fontWeight: FontWeight.bold,// Dark blue text color
                        fontSize: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
