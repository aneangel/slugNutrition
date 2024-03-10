import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import '/src/features/authentication/models/user_model.dart';
import '../authentication_repository/exceptions/t_exceptions.dart';

class UserRepository extends GetxController {
  static UserRepository get instance => Get.find();

  final _db = FirebaseFirestore.instance;

  /// Store user data
  Future<void> createUser(UserModel user) async {
    try {
      // It is recommended to use Authentication Id as DocumentId of the Users Collection.
      // To store a new user you first have to authenticate and get uID (e.g: Check Authentication Repository)
      // Add user like this: await _db.collection("Users").doc(uID).set(user.toJson());
      await recordExist(user.email) ? throw "Record Already Exists" : await _db.collection("Users").add(user.toJson());
    } on FirebaseAuthException catch (e) {
      final result = TExceptions.fromCode(e.code);
      throw result.message;
    } on FirebaseException catch (e) {
      throw e.message.toString();
    } catch (e) {
      throw e.toString().isEmpty ? 'Something went wrong. Please Try Again' : e.toString();
    }
  }
  Future<bool> hasBmiData(String userId) async {
    try {
      var doc = await _db.collection("Users").doc(userId).get();
      if (!doc.exists) {
        throw "User not found.";
      }
      // Assuming the BMI data is stored under a field named 'bmi'
      return doc.data()!.containsKey('bmi') && doc.data()!['bmi'] != null;
    } catch (e) {
      print(e); // Handle the error or log it
      return false; // Assuming no data exists if there's an error
    }
  }

  /// Check if user's dietary preferences exist
  Future<bool> hasDietaryPreferences(String userId) async {
    try {
      var doc = await _db.collection("Users").doc(userId).get();
      if (!doc.exists) {
        throw "User not found.";
      }
      // Assuming the dietary preferences are stored under a field named 'dietaryPreferences'
      return doc.data()!.containsKey('dietaryPreferences') && doc.data()!['dietaryPreferences'] != null;
    } catch (e) {
      print(e); // Handle the error or log it
      return false; // Assuming no data exists if there's an error
    }
  }
  /// Fetch User Specific details
  Future<UserModel> getUserDetails(String email) async {
    try {
      // It is recommended to use Authentication Id as DocumentId of the Users Collection.
      // Then when fetching the record you only have to get user authenticationID uID and query as follows.
      // final snapshot = await _db.collection("Users").doc(uID).get();

      final snapshot = await _db.collection("Users").where("Email", isEqualTo: email).get();
      if (snapshot.docs.isEmpty) throw 'No such user found';

      // Single will throw exception if there are two entries when result return.
      // In case of multiple entries use .first to pick the first one without exception.
      final userData = snapshot.docs.map((e) => UserModel.fromSnapshot(e)).single;
      return userData;
    } on FirebaseAuthException catch (e) {
      final result = TExceptions.fromCode(e.code);
      throw result.message;
    } on FirebaseException catch (e) {
      throw e.message.toString();
    } catch (e) {
      throw e.toString().isEmpty ? 'Something went wrong. Please Try Again' : e.toString();
    }
  }

  /// Fetch All Users
  Future<List<UserModel>> allUsers() async {
    try {
      final snapshot = await _db.collection("Users").get();
      final users = snapshot.docs.map((e) => UserModel.fromSnapshot(e)).toList();
      return users;
    } on FirebaseAuthException catch (e) {
      final result = TExceptions.fromCode(e.code);
      throw result.message;
    } on FirebaseException catch (e) {
      throw e.message.toString();
    } catch (_) {
      throw 'Something went wrong. Please Try Again';
    }
  }

  /// Update User details
  Future<void> updateUserRecord(UserModel user) async {
    try {
      await _db.collection("Users").doc(user.id).update(user.toJson());
    } on FirebaseAuthException catch (e) {
      final result = TExceptions.fromCode(e.code);
      throw result.message;
    } on FirebaseException catch (e) {
      throw e.message.toString();
    } catch (_) {
      throw 'Something went wrong. Please Try Again';
    }
  }

  /// Delete User Data
  Future<void> deleteUser(String id) async {
    try {
      await _db.collection("Users").doc(id).delete();
    } on FirebaseAuthException catch (e) {
      final result = TExceptions.fromCode(e.code);
      throw result.message;
    } on FirebaseException catch (e) {
      throw e.message.toString();
    } catch (_) {
      throw 'Something went wrong. Please Try Again';
    }
  }

  /// Check if user exists with email or phoneNo
  Future<bool> recordExist(String email) async {
    try {
      final snapshot = await _db.collection("Users").where("Email", isEqualTo: email).get();
      return snapshot.docs.isEmpty ? false : true;
    } catch (e) {
      throw "Error fetching record.";
    }
  }

  // This method fetches the currently logged-in user's UID.
  Future<String?> fetchCurrentUserId() async {
    try {
      final User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        // User is signed in
        return currentUser.uid; // Return the UID of the currently logged-in user
      } else {
        // No user is signed in
        return null;
      }
    } catch (e) {
      print("Error fetching current user's UID: $e");
      return null;
    }
  }
}