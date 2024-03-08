import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '/src/constants/colors.dart';
import '/src/constants/sizes.dart';
import '/src/constants/text_strings.dart';
import '/src/common_widgets/buttons/primary_button.dart';
import '/src/features/core/controllers/profile_controller.dart';

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
        leading: IconButton(onPressed: () => Get.back(), icon: const Icon(Icons.arrow_back)),
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

  void _updatePassword() {
    // Use controller for backend?
    // Make sure to validate the current password, new password, and confirm new password fields
  }
}
