import 'package:flutter/material.dart';
import 'package:slugnutrition/backend/controllers/menuFilterService.dart';
import 'package:slugnutrition/backend/controllers/menuItemClass.dart'; // Assuming this has FilteredMenuItem definition.
import 'package:firebase_storage/firebase_storage.dart';


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
                menuItemsWidgets.add(Card(
                  color: UCSCColors.santaCruzBlue,

                  child: ExpansionTile(
                    title: Text(
                        item.name, style: TextStyle(color: Colors.white)),
                    collapsedIconColor: UCSCColors.gold,
                    iconColor: UCSCColors.gold,
                    // Color of the icon when tile is collapsed
                    children: <Widget>[
                      // Example attributes and nutritional facts, adjust according to your data structure
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Wrap(
                              spacing: 8.0, // Space between chips
                              children: item.tags.map((tag) =>
                                  _buildAttributeIcon(tag)).toList(),
                            ),
                            Divider(),
                            Text(
                              'Nutritional Facts',
                              style: Theme.of(context).textTheme.subtitle2!.copyWith(color: Colors.white),
                            )
                            // Add your nutritional facts here
                          ],
                        ),
                      ),
                    ],
                  ),
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


  Widget _buildDishExpansionTile(FilteredMenuItem item) {
    return Card(
      margin: EdgeInsets.all(8),
      child: ExpansionTile(
        title: Text(item.name, textAlign: TextAlign.center),
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Wrap(
                  spacing: 8.0, // Space between chips
                  children: item.tags.map((tag) => _buildAttributeIcon(tag))
                      .toList(),
                ),
                Divider(),
                Text('Nutritional Facts', style: Theme
                    .of(context)
                    .textTheme
                    .subtitle1),
                Text('Calories: 100'), // Placeholder value
                Text('Protein: 20g'), // Placeholder value
                Text('Carbs: 30g'), // Placeholder value
                Text('Sugar: 10g'), // Placeholder value
              ],
            ),
          ),
        ],
      ),
    );
  }


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


