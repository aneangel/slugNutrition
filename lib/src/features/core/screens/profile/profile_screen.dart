import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:slugnutrition/src/features/core/screens/bmi/bmi.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '/src/common_widgets/buttons/primary_button.dart';
import '/src/constants/sizes.dart';
import '/src/constants/text_strings.dart';
import '/src/features/core/screens/profile/update_profile_screen.dart';
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
              const ImageWithIcon(),
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
              ProfileMenuWidget(title: "Update BMI", icon: LineAwesomeIcons.address_card, onPress: () => Get.to(() => BMICalculatorScreen())),
              ProfileMenuWidget(
                  title: "Update Dietary Preferences", icon: LineAwesomeIcons.utensils, onPress: () => Get.to(() => DietaryPreferencesForm())),
              const Divider(),
              const SizedBox(height: 10),
              ProfileMenuWidget(title: "FAQs", icon: LineAwesomeIcons.question_circle, onPress: () => Get.to(() => FAQScreen())),
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
