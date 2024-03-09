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
}
