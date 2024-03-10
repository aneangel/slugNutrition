import 'package:flutter/material.dart';
import 'package:slugnutrition/backend/controllers/menuItemClass.dart';
import 'package:slugnutrition/backend/controllers/firestoreClass.dart';
import 'package:slugnutrition/src/repository/user_repository/user_repository.dart';
import 'package:slugnutrition/src/features/authentication/screens/login/login_screen.dart';

class MealDetailsScreen extends StatefulWidget {
  final String hallName;
  final String mealCategory;

  MealDetailsScreen({Key? key, required this.hallName, required this.mealCategory}) : super(key: key);

  @override
  _MealDetailsScreenState createState() => _MealDetailsScreenState();
}

class _MealDetailsScreenState extends State<MealDetailsScreen> {
  Future<Map<String, List<MenuItem>>>? mealItems; // Changed from 'late' to nullable

  @override
  void initState() {
    super.initState();
    fetchMealData();
  }

  void fetchMealData() async {
    FirestoreService firestoreService = FirestoreService();
    String? userId = await UserRepository.instance.fetchCurrentUserId();
    if (userId == null) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    } else {
      setState(() {
        mealItems = firestoreService.fetchUserSpecificMenuItems(widget.hallName, userId);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.mealCategory} Options'),
      ),
      body: mealItems == null 
        ? Center(child: CircularProgressIndicator()) // Show loading indicator while mealItems is null
        : FutureBuilder<Map<String, List<MenuItem>>>(
            future: mealItems,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text("Error: ${snapshot.error}"));
              } else {
                // Filter the items for the selected meal category
                List<MenuItem> itemsForCategory = snapshot.data?[widget.mealCategory] ?? [];

                return ListView.builder(
                  itemCount: itemsForCategory.length,
                  itemBuilder: (context, index) {
                    MenuItem item = itemsForCategory[index];
                    return ListTile(
                      title: Text(item.name),
                      subtitle: Text('Calories: '), // Assuming calories is a field
                      // Add more details as needed
                    );
                  },
                );
              }
            },
          ),
    );
  }
}
