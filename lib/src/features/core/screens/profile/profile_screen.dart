import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:slugnutrition/src/features/authentication/screens/on_boarding/on_boarding_screen.dart';
import 'package:slugnutrition/src/features/core/screens/bmi/bmi.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '/src/common_widgets/buttons/primary_button.dart';
import '/src/constants/sizes.dart';
import '/src/constants/text_strings.dart';
import '/src/features/core/screens/profile/update_profile_screen.dart';
import '/src/features/core/screens/profile/update_dietary_preferences.dart';
import '/src/features/core/screens/profile/update_bmi.dart';
import '/src/features/core/screens/profile/widgets/image_with_icon.dart';
import '/src/features/core/screens/profile/widgets/profile_menu.dart';
import '/src/features/core/screens/profile/all_users.dart';
import '/src/features/core/screens/profile/dietary_preferences/dietary_preferences_form.dart';
import '../../../../repository/authentication_repository/authentication_repository.dart';
import '/src/features/core/screens/update_password/updatepassword.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '/src/features/core/screens/faq/faq.dart';
import '/src/features/core/controllers/profile_controller.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  Future<String?> getUserProfileImageUrl() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.email)
            .get();
        Map<String, dynamic>? userData = userDoc.data() as Map<String, dynamic>?;
        return userData?['profileImageUrl']; // Adjust the field name if necessary
      } catch (e) {
        print("Error fetching user profile image URL: $e");
        return null;
      }
    }
    return null;
  }



  Future<String> getUserName() async {
  User? user = FirebaseAuth.instance.currentUser;
  String userName = "No Name Available"; // Default value
  if (user != null) {
  try {
  DocumentSnapshot bmiForm = await FirebaseFirestore.instance
      .collection('users')
      .doc(user.email)
      .collection('forms')
      .doc('bmiForm')
      .get();

  if (bmiForm.exists) {
  Map<String, dynamic>? data = bmiForm.data() as Map<String, dynamic>?;
  if (data != null && data.containsKey('name')) {
  userName = data['name'];
  }
  }
  } catch (e) {
  print("Error fetching user name: $e");
  }
  }
  return userName;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: () => Get.back(), icon: const Icon(LineAwesomeIcons.angle_left)),
        title: Text(tProfile, style: Theme.of(context).textTheme.headlineMedium),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(tDefaultSpace),
          child: Column(
            children: [
              /// -- IMAGE with ICON
              FutureBuilder<String?>(
                future: getUserProfileImageUrl(),
                builder: (BuildContext context, AsyncSnapshot<String?> snapshot) {
                  return ImageWithIcon(
                    imageUrl: snapshot.data,
                    onImageUpdate: () {
                      // Handle profile image update
                    },
                  );
                },
              ),
              const SizedBox(height: 10),
              FutureBuilder<String>(
                future: getUserName(),
                builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return Text(snapshot.data ?? "No Name Available", style: Theme.of(context).textTheme.headlineMedium);
                  } else {
                    // While waiting for the async operation to complete, show a loading indicator.
                    return CircularProgressIndicator();
                  }
                },
              ),
              const SizedBox(height: 5),
              Text(FirebaseAuth.instance.currentUser?.email ?? "No email available", style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: 20),

              TPrimaryButton(
                  isFullWidth: false,
                  width: 200,
                  text: tEditProfile,
                  onPressed: () => Get.to(() => UpdateProfileScreen())
              ),
              const SizedBox(height: 30),
              const Divider(),
              const SizedBox(height: 10),

              /// -- MENU
              ProfileMenuWidget(title: "Update Password", icon: LineAwesomeIcons.key, onPress: () => Get.to(() => UpdatePasswordScreen())),
              ProfileMenuWidget(title: "Update BMI", icon: LineAwesomeIcons.address_card, onPress: () => Get.to(() => UpdateBMIScreen())),
              ProfileMenuWidget(
                  title: "Update Dietary Preferences", icon: LineAwesomeIcons.utensils, onPress: () => Get.to(() => UpdateDietaryPreferencesForm())),
              const Divider(),
              const SizedBox(height: 10),
              ProfileMenuWidget(title: "FAQs", icon: LineAwesomeIcons.question_circle, onPress: () => Get.to(() => FAQScreen())),
              ProfileMenuWidget(
                title: "Delete Account",
                icon: LineAwesomeIcons.trash, // Choose an appropriate icon
                textColor: Colors.red,
                endIcon: false,
                onPress: () => _showDeleteUserModal(context),
              ),
              ProfileMenuWidget(
                title: "Logout",
                icon: LineAwesomeIcons.alternate_sign_out,
                textColor: Colors.red,
                endIcon: false,
                onPress: () => _showLogoutModal(),
              ),

            ],
          ),
        ),
      ),
    );
  }

  _showDeleteUserModal(BuildContext context) {
    Get.defaultDialog(
      title: "Delete Account",
      content: Text("This will permanently delete your account and all associated data. Are you sure you want to proceed?"),
      onCancel: () => Get.back(),
      onConfirm: () {
        Get.back(); // Close the dialog
        _promptForReauthentication(context); // Prompt for re-authentication
      },
      textCancel: "Cancel",
      textConfirm: "Delete",
      confirmTextColor: Colors.white,
      buttonColor: Colors.red, // Check if this named parameter exists in your version or adjust accordingly
    );
  }
  _promptForReauthentication(BuildContext context) {
    TextEditingController passwordController = TextEditingController();

    // Show dialog to enter password
    Get.defaultDialog(
      title: "Re-authenticate",
      content: Column(
        children: [
          Text("Please enter your password to confirm."),
          TextField(
            controller: passwordController,
            obscureText: true,
            decoration: InputDecoration(labelText: "Password"),
          ),
        ],
      ),
      onCancel: () => Get.back(),
      onConfirm: () async {
        Get.back(); // Close the dialog
        try {
          String email = FirebaseAuth.instance.currentUser!.email!;
          AuthCredential credential = EmailAuthProvider.credential(email: email, password: passwordController.text);
          await FirebaseAuth.instance.currentUser!.reauthenticateWithCredential(credential);
          // Re-authentication successful, proceed with account deletion
          await _deleteUserAccount();
        } catch (error) {
          Get.snackbar("Error", "Re-authentication failed. Please try again.");
        }
      },
      textCancel: "Cancel",
      textConfirm: "Confirm",
      confirmTextColor: Colors.white,
    );
  }

  Future<void> _deleteUserAccount() async {
    try {
      await FirebaseAuth.instance.currentUser!.delete();
      // Handle post-deletion logic, e.g., navigate to login screen
      Get.offAll(() => OnBoardingScreen()); // Assuming you have a LoginScreen
    } catch (error) {
      Get.snackbar("Error", "Failed to delete account. Please try again.");
    }
  }


  _showLogoutModal() {
    Get.defaultDialog(
      title: "LOGOUT",
      titleStyle: const TextStyle(fontSize: 20),
      content: const Padding(
        padding: EdgeInsets.symmetric(vertical: 15.0),
        child: Text("Are you sure, you want to Logout?"),
      ),
      confirm: TPrimaryButton(
        isFullWidth: false,
        onPressed: () => AuthenticationRepository.instance.logout(),
        text: "Yes",
      ),
      cancel: SizedBox(width: 100, child: OutlinedButton(onPressed: () => Get.back(), child: const Text("No"))),
    );
  }
}
