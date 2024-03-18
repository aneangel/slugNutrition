import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '/src/features/authentication/models/user_model.dart';
import '/src/repository/user_repository/user_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../repository/authentication_repository/authentication_repository.dart';

class SignUpController extends GetxController {
  static SignUpController get to => Get.find();

  GlobalKey<FormState> signupFormKey = GlobalKey<FormState>();
  final email = TextEditingController();
  final password = TextEditingController();
  final fullName = TextEditingController();
  final phoneNo = TextEditingController();
  final isLoading = false.obs;
  final showPassword = false.obs; // Add this line
  final isFacebookLoading = false.obs; // Add this line
  final isGoogleLoading = false.obs; // Add this line

  Future<void> createUser() async {
    if (!signupFormKey.currentState!.validate()) return;
    isLoading(true);

    try {
      // Register the user with email and password
      await AuthenticationRepository.instance.registerWithEmailAndPassword(email.text.trim(), password.text.trim());

      // Create a UserModel instance with the user's data
      final user = UserModel(
        email: email.text.trim(),
        fullName: fullName.text.trim(),
        phoneNo: phoneNo.text.trim(),
      );

      // Store the user's profile form data in Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.email) // Use the user's email as the document ID
          .collection('forms')
          .doc('profile_form')
          .set(user.toJson());

      // Handle successful registration (e.g., navigate to another screen or show a success message)
    } catch (e) {
      Get.snackbar("Error", e.toString(), snackPosition: SnackPosition.BOTTOM, duration: const Duration(seconds: 5));
    } finally {
      isLoading(false);
    }
  }

  /// [PhoneNoAuthentication]
  Future<void> phoneAuthentication(String phoneNo) async {
    try {
      await AuthenticationRepository.instance.phoneAuthentication(phoneNo);
    } catch (e) {
      throw e.toString();
    }
  }
}
