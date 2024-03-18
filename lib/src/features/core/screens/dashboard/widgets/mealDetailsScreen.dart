import 'package:flutter/material.dart';
import 'package:slugnutrition/backend/controllers/menuFilterService.dart';
import 'package:slugnutrition/backend/controllers/menuItemClass.dart'; // Ensure this has the MenuItem definition
import 'package:slugnutrition/backend/controllers/firestoreClass.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MealDetailsScreen extends StatefulWidget {
  final String hallName;
  final String mealCategory;
  final Future<Map<String, List<FilteredMenuItem>>> allMenuItemsFuture; // Use MenuItem here

  const MealDetailsScreen({
    Key? key,
    required this.hallName,
    required this.mealCategory,
    required this.allMenuItemsFuture,
  }) : super(key: key);

  @override
  _MealDetailsScreenState createState() => _MealDetailsScreenState();
}

// class _MealDetailsScreenState extends State<MealDetailsScreen> {

//   @override
//   Widget build(BuildContext context) {
//     // Use FutureBuilder to build UI based on future's state
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('${widget.mealCategory} Options'),
//       ),
//       body: FutureBuilder<Map<String, List<FilteredMenuItem>>>(
//         future: widget.allMenuItemsFuture,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             return Center(child: Text("Error: ${snapshot.error.toString()}"));
//           } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//             return const Center(child: Text("No menu items found"));
//           } else {
//             // Extracting data into a list of widgets for each category and its items
//             var menuItemsWidgets = <Widget>[];
//             snapshot.data!.forEach((category, items) {
//               // Add category name as a header
//               menuItemsWidgets.add(Text(category, style: Theme.of(context).textTheme.headline6));
//               // Add each item in this category
//               items.forEach((item) {
//                 menuItemsWidgets.add(ListTile(
//                   title: Text(item.name),
//                   subtitle: Text('Attributes: ${item.tags.join(', ')}'),
//                 ));
//               });
//               // Add spacing after each category
//               menuItemsWidgets.add(SizedBox(height: 10));
//             });

//             return SingleChildScrollView(
//               child: Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Column(children: menuItemsWidgets),
//               ),
//             );
//           }
//         },
//       ),
//     );
//   }
// }

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
            var menuItemsWidgets = <Widget>[];
            snapshot.data!.forEach((category, items) {
              // Add category name as a header
              menuItemsWidgets.add(Text(category, style: Theme.of(context).textTheme.headline6));
              // Add each item in this category, including its nutritional facts
              items.forEach((FilteredMenuItem item) {
                menuItemsWidgets.add(Card(
                  margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                  child: ExpansionTile(
                    title: Text(item.name),
                    subtitle: Text('Attributes: ${item.tags.join(', ')}'),
                    children: [
                      if (item.nutritionalFacts != null) ...[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: item.nutritionalFacts!.entries.map((e) => Text('${e.key}: ${e.value}')).toList(),
                          ),
                        ),
                      ],
                    ],
                  ),
                ));
              });
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
