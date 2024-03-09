import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '/src/constants/colors.dart';
import '/src/constants/sizes.dart';
import '/src/constants/text_strings.dart';
import '/src/common_widgets/buttons/primary_button.dart';
import '/src/features/core/controllers/profile_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import '/src/features/core/screens/profile/profile_screen.dart';
import '/src/common_widgets/buttons/primary_button.dart';
import '/src/constants/sizes.dart';
import '/src/constants/text_strings.dart';
import '/src/utils/helper/helper_controller.dart';



class UpdatePasswordScreen extends StatefulWidget {
  @override
  _UpdatePasswordScreenState createState() => _UpdatePasswordScreenState();
}

class _UpdatePasswordScreenState extends State<UpdatePasswordScreen> {
  final controller = Get.put(ProfileController());
  final currentPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmNewPasswordController = TextEditingController();

  bool _isCurrentPasswordVisible = false;
  bool _isNewPasswordVisible = false;
  bool _isConfirmNewPasswordVisible = false;

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
                obscureText: !_isCurrentPasswordVisible,
                decoration: InputDecoration(
                  label: const Text("Current Password"),
                  hintText: "Enter your current password",
                  prefixIcon: const Icon(Icons.lock_outline),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isCurrentPasswordVisible ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _isCurrentPasswordVisible = !_isCurrentPasswordVisible;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 20.0),
              TextFormField(
                controller: newPasswordController,
                obscureText: !_isNewPasswordVisible,
                decoration: InputDecoration(
                  label: const Text("New Password"),
                  hintText: "Enter a new password",
                  prefixIcon: const Icon(Icons.lock_outline),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isNewPasswordVisible ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _isNewPasswordVisible = !_isNewPasswordVisible;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 20.0),
              TextFormField(
                controller: confirmNewPasswordController,
                obscureText: !_isConfirmNewPasswordVisible,
                decoration: InputDecoration(
                  label: const Text("Confirm New Password"),
                  hintText: "Re-enter your new password",
                  prefixIcon: const Icon(Icons.lock_outline),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isConfirmNewPasswordVisible ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _isConfirmNewPasswordVisible = !_isConfirmNewPasswordVisible;
                      });
                    },
                  ),
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