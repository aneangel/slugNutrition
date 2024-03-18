import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '/src/common_widgets/buttons/primary_button.dart';
import '/src/features/core/controllers/profile_controller.dart';
import '/src/features/authentication/models/user_model.dart';

class UpdateProfileScreen extends StatefulWidget {
  UpdateProfileScreen({Key? key}) : super(key: key);

  @override
  _UpdateProfileScreenState createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  final ProfileController controller = Get.find<ProfileController>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneNoController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadCurrentUser();
  }

  _loadCurrentUser() async {
    // Assuming getUserData correctly fetches the current user and returns a UserModel
    final UserModel currentUser = await controller.getUserData();
    if (currentUser != UserModel.empty()) {
      _nameController.text = currentUser.fullName;
      _emailController.text = currentUser.email;
      _phoneNoController.text = currentUser.phoneNo;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: () => Get.back(), icon: const Icon(Icons.arrow_back)),
        title: const Text('Edit Profile'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Full Name'),
            ),
            const SizedBox(height: 30),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            const SizedBox(height: 30),
            TextField(
              controller: _phoneNoController,
              decoration: const InputDecoration(labelText: 'Phone Number'),
            ),
            const SizedBox(height: 30),
            TPrimaryButton(
              text: "Update Profile",
              onPressed: _updateProfile,
            ),
          ],
        ),
      ),
    );
  }

  void _updateProfile() async {
    // Assuming updateRecord accepts a UserModel and updates the user's information
    UserModel updatedUser = UserModel(
      email: _emailController.text,
      fullName: _nameController.text,
      phoneNo: _phoneNoController.text,
      // Preserve the id and password (if needed) from the original user data
      //id: controller.currentUser.id, // You need to implement currentUser in your controller
      password: controller.currentUser.password, // Handle password appropriately
    );

    await controller.updateRecord(updatedUser);
    Get.snackbar('Success', 'Profile updated successfully.');
  }
}
