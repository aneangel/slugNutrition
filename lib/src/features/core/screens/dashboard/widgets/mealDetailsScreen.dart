import 'package:flutter/material.dart';
import 'package:slugnutrition/backend/controllers/firestoreClass.dart';
import 'package:slugnutrition/backend/controllers/menuItemClass.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MealDetailsScreen extends StatefulWidget {
  final String hallName;
  final String mealCategory;
  final Future<Map<String, List<MenuItem>>> allMenuItemsFuture;

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
  Future<List<MenuItem>>? categoryMenuItems; // Removed 'late' keyword and made it nullable
  Future<Map<String, List<MenuItem>>>? allMenuItemsFuture;

  final FirestoreService _firestoreService = FirestoreService();
  @override
  void initState() {
    super.initState();
    fetchDiningHallMenuItems();
    // print('wow');
    // printDiningHallNames();
    // // printCategories();
    // printDiningHallDetails();
    // // categoryMenuItems = Future.value(widget.allMenuItems[widget.mealCategory]);
    // allMenuItemsFuture = FirestoreService().fetchMenuItemsForDiningHall(widget.hallName);
  }

  void fetchDiningHallMenuItems() async {
    var menuItems = await _firestoreService.fetchMenuItemsForDiningHall("CollegeNineJohnR.LewisDiningHall");
    print(menuItems); // This will print the fetched menu items to your console
  }

  Future<void> printDiningHallNames() async {
    FirebaseFirestore db = FirebaseFirestore.instance; // Reference to Firestore

    try {
      // Fetch the snapshot of the collection
      print('Hieee');
      QuerySnapshot snapshot = await db.collection('Dining Hall Menus').get();

      // Iterate over the documents and print their IDs (dining hall names)
      for (var doc in snapshot.docs) {
        print(doc.id); // This prints the dining hall name
      }
    } catch (e) {
      print('Error fetching dining hall names: $e');
    }
  }


  Future<List<MenuItem>> fetchMenuItemsForCategory() async {
    FirestoreService firestoreService = FirestoreService();
    Map<String, List<MenuItem>> categoriesWithMenuItems =
    await firestoreService.fetchCategoriesAndMenuItems(widget.hallName);
    return categoriesWithMenuItems[widget.mealCategory] ?? [];
  }


  void printCategories() {
    FirestoreService firestoreService = FirestoreService();
    firestoreService.printCategoriesFromDiningHall('CollegeNineJohnR.LewisDiningHall');
  }

  void printDiningHallDetails() {
    FirestoreService firestoreService = FirestoreService();
    firestoreService.printCategoriesAndContentsFromDiningHall('CollegeNineJohnR.LewisDiningHall');
  }



  @override
  Widget build(BuildContext context) {
    // Use FutureBuilder to build UI based on future's state
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.mealCategory} Options'),
      ),
      body: FutureBuilder<Map<String, List<MenuItem>>>(
        future: widget.allMenuItemsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error.toString()}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No menu items found"));
          } else {
            // Extracting data into a list of widgets for each category and its items
            var menuItemsWidgets = <Widget>[];
            snapshot.data!.forEach((category, items) {
              // Add category name as a header
              menuItemsWidgets.add(Text(category, style: Theme.of(context).textTheme.headline6));
              // Add each item in this category
              items.forEach((item) {
                menuItemsWidgets.add(ListTile(
                  title: Text(item.name),
                  subtitle: Text('Attributes: ${item.attributes.join(', ')}'),
                ));
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
}
