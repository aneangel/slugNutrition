import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '/src/constants/colors.dart';
import '/src/constants/sizes.dart';
import '/src/constants/text_strings.dart';
import '/src/common_widgets/buttons/primary_button.dart';
import '/src/features/core/controllers/profile_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '/src/features/core/screens/profile/profile_screen.dart';


class UpdatePasswordScreen extends StatelessWidget {
  UpdatePasswordScreen({super.key});

  final controller = Get.put(ProfileController());
  final currentPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmNewPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: () => Get.off(() => ProfileScreen()), icon: const Icon(Icons.arrow_back)),
        title: Text("Update Password", style: Theme.of(context).textTheme.headlineMedium),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(tDefaultSpace),
          child: Column(
            children: [
              const SizedBox(height: tDefaultSpace * 2),
              TextFormField(
                controller: currentPasswordController,
                obscureText: true,
                decoration: const InputDecoration(
                  label: Text("Current Password"),
                  hintText: "Enter your current password",
                  prefixIcon: Icon(Icons.lock_outline),
                ),
              ),
              const SizedBox(height: 20.0),
              TextFormField(
                controller: newPasswordController,
                obscureText: true,
                decoration: const InputDecoration(
                  label: Text("New Password"),
                  hintText: "Enter a new password",
                  prefixIcon: Icon(Icons.lock_outline),
                ),
              ),
              const SizedBox(height: 20.0),
              TextFormField(
                controller: confirmNewPasswordController,
                obscureText: true,
                decoration: const InputDecoration(
                  label: Text("Confirm New Password"),
                  hintText: "Re-enter your new password",
                  prefixIcon: Icon(Icons.lock_outline),
                ),
              ),
              const SizedBox(height: 30.0),
              TPrimaryButton(
                isFullWidth: true,
                text: "Update Password",
                onPressed: () => _updatePassword(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _updatePassword() async {
    final currentPassword = currentPasswordController.text.trim();
    final newPassword = newPasswordController.text.trim();
    final confirmNewPassword = confirmNewPasswordController.text.trim();

    // Step 1: Validate input fields
    if (currentPassword.isEmpty || newPassword.isEmpty || confirmNewPassword.isEmpty) {
      Get.snackbar('Error', 'Please fill in all fields.');
      return;
    }

    // Step 2: Check password match
    if (newPassword != confirmNewPassword) {
      Get.snackbar('Error', 'New passwords do not match.');
      return;
    }

    // Step 3: Re-authenticate the user with current password
    try {
      final user = FirebaseAuth.instance.currentUser;
      final credential = EmailAuthProvider.credential(
        email: user!.email!, // Assuming the user's email is not null
        password: currentPassword,
      );

      await user.reauthenticateWithCredential(credential);

      // Step 4: Update password
      await user.updatePassword(newPassword);
      Get.snackbar('Success', 'Password updated successfully.');
    } catch (error) {
      Get.snackbar('Error', 'Failed to update password. Make sure your current password is correct.');
    }
  }
}