import 'package:flutter/material.dart';
import 'mealDetailsScreen.dart';

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
      'name': 'Late Night',
      'image': 'assets/images/meals/lateNight.png',
    },
    // ... other meal options ...
  ];

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
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MealDetailsScreen(
                      hallName: hallName,
                      mealCategory: mealOptions[index]['name']!,
                    ),
                  ),
                );
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
