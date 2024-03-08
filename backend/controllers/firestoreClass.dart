// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'menu_item.dart';
//
// class FirestoreService {
//   final FirebaseFirestore _db = FirebaseFirestore.instance;
//
//   Future<Map<String, List<MenuItem>>> fetchMenuItems(String diningHallId) async {
//     Map<String, List<MenuItem>> menuItems = {};
//     try {
//       DocumentSnapshot snapshot = await _db.collection('Dining Hall Menus').doc(diningHallId).get();
//       Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
//       data.forEach((category, items) {
//         List<MenuItem> itemList = (items as List).map((item) => MenuItem.fromJson(item)).toList();
//         menuItems[category] = itemList;
//       });
//     } catch (e) {
//       print(e.toString());
//     }
//     return menuItems;
//   }
// }
