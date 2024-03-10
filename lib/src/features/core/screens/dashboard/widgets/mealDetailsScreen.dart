import 'package:flutter/material.dart';
import 'package:slugnutrition/backend/controllers/menuItemClass.dart';
import 'package:slugnutrition/backend/controllers/firestoreClass.dart';

class MealDetailsScreen extends StatefulWidget {
  final String hallName;
  final String mealCategory;

  MealDetailsScreen({Key? key, required this.hallName, required this.mealCategory}) : super(key: key);

  @override
  _MealDetailsScreenState createState() => _MealDetailsScreenState();
}

class _MealDetailsScreenState extends State<MealDetailsScreen> {
  late Future<Map<String, List<MenuItem>>> mealItems;

  @override
  void initState() {
    super.initState();
    FirestoreService firestoreService = FirestoreService();
    // Assuming you have a way to get the userId, for example, from a logged-in user session
    String userId = "some_user_id";
    mealItems = firestoreService.fetchUserSpecificMenuItems(widget.hallName, userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.mealCategory} Options'),
      ),
      body: FutureBuilder<Map<String, List<MenuItem>>>(
        future: mealItems,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}"));
            }

            // Filter the items for the selected meal category
            List<MenuItem> itemsForCategory = snapshot.data![widget.mealCategory] ?? [];

            return ListView.builder(
              itemCount: itemsForCategory.length,
              itemBuilder: (context, index) {
                MenuItem item = itemsForCategory[index];
                return ListTile(
                  title: Text(item.name),
                  subtitle: Text('Calories:'),
                  // Add more details as needed
                );
              },
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
