import 'package:flutter/material.dart';
import '/src/constants/colors.dart';
import '/src/constants/image_strings.dart';
import '/src/constants/sizes.dart';
import '/src/constants/text_strings.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '/src/features/authentication/screens/login/login_screen.dart';
import '../../../../../common_widgets/form/form_header_widget.dart';

class ForgetPasswordMailScreen extends StatefulWidget {
  const ForgetPasswordMailScreen({Key? key}) : super(key: key);

  @override
  _ForgetPasswordMailScreenState createState() => _ForgetPasswordMailScreenState();
}

class _ForgetPasswordMailScreenState extends State<ForgetPasswordMailScreen> {
  late TextEditingController emailController; // Controller is defined here in the state class

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController(); // Initialized here
  }

  @override
  void dispose() {
    emailController.dispose(); // Don't forget to dispose of the controller
    super.dispose();
  }

  Future<void> sendPasswordResetEmail(BuildContext context) async {
    final String email = emailController.text.trim();
    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your email address')),
      );
      return;
    }
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password reset email sent')),
      );

      // After showing the snackbar message, navigate to the login screen
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.message}')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An unexpected error occurred. Please try again later.')),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    //Just In-case if you want to replace the Image Color for Dark Theme
    final brightness = MediaQuery.of(context).platformBrightness;
    final bool isDark = brightness == Brightness.dark;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),
          ),
          iconTheme: IconThemeData(
            color: Colors.white, // Set your desired color here
          ),
          backgroundColor: isDark ? tPrimaryColor : tSecondaryColor, // Adjust the AppBar color based on the theme
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(tDefaultSpace),
            child: Column(
              children: [
                const SizedBox(height: tDefaultSpace),
                FormHeaderWidget(
                  imageColor: isDark ? tPrimaryColor : tSecondaryColor,
                  image: tForgetPasswordImage,
                  title: tForgetPassword,
                  subTitle: tForgetPasswordSubTitle,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  heightBetween: 30.0,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: tFormHeight),
                Form(
                  child: Column(
                    children: [
                      TextFormField(
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          label: Text(tEmail),
                          hintText: 'Enter Your Email', // Assuming tEmailHint is defined, else use 'Enter your email'
                          prefixIcon: Icon(Icons.mail_outline_rounded),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email';
                          }
                          // Add more validation logic if needed
                          return null;
                        },
                      ),
                      const SizedBox(height: 20.0),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () => sendPasswordResetEmail(context),
                          child: const Text(tNext),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
