import 'package:flutter/material.dart';
import '/src/constants/image_strings.dart';
import '/src/constants/sizes.dart';
import '/src/constants/text_strings.dart';
import '/src/constants/colors.dart';
import 'package:get/get.dart';
import '/src/features/authentication/screens/welcome/welcome_screen.dart';
import '/src/features/authentication/screens/on_boarding/on_boarding_screen.dart';
import '../../../../utils/animations/fade_in_animation/animation_design.dart';
import '../../../../utils/animations/fade_in_animation/fade_in_animation_controller.dart';
import '../../../../utils/animations/fade_in_animation/fade_in_animation_model.dart';
import '/src/features/authentication/screens/mail_verification/mail_verification.dart';
import '/src/repository/authentication_repository/authentication_repository.dart';
import '/src/features/core/screens/dashboard/dashboard.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool animate = false;

  @override
  void initState() {
    super.initState();
    startAnimation();
  }

  Future startAnimation() async {
    await Future.delayed(Duration(milliseconds: 500));
    if (!mounted) return; // Check here as well, since setState should not be called if the widget is unmounted
    setState(() {
      animate = true;
    });
    await Future.delayed(Duration(milliseconds: 2500)); // Adjust the timing based on your preference

    if (!mounted) return; // Ensure the widget is still mounted before proceeding
    // Check user authentication status and navigate accordingly
    checkAuthenticationStatus();
  }


  void checkAuthenticationStatus() async {
    final authRepo = AuthenticationRepository.instance; // Ensure AuthenticationRepository is initialized in your app
    final isLoggedIn = authRepo.firebaseUser != null;
    final isEmailVerified = authRepo.firebaseUser?.emailVerified ?? false;

    if (!isLoggedIn) {
      // User not logged in, go to OnBoardingScreen or WelcomeScreen
      navigateTo(const OnBoardingScreen());
    } else if (isLoggedIn && !isEmailVerified) {
      // User logged in but email not verified, go to MailVerification
      navigateTo(const MailVerification());
    } else {
      // User logged in and email verified, go to Dashboard
      navigateTo(const Dashboard());
    }
  }

  void navigateTo(Widget page) {
    if (mounted) {
      print("Navigating to ${page.runtimeType}");
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => page));
    } else {
      print("Widget is unmounted, not navigating");
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
          children: [
            AnimatedPositioned(
              duration: const Duration(milliseconds: 1600),
              top: animate ? 0 : -30,
              left: animate ? 15 : -30,
              child: SizedBox(
                width: 200.0, // Specify the width you want
                height: 200.0, // And the height you want
                child: Image(
                  image: AssetImage(tSplashTopIcon),
                ),
              ),
            ),
            AnimatedPositioned(
              duration: const Duration(milliseconds: 1600),
              top: 135,
              left: animate ? tDefaultSize : -80,
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 1600),
                opacity: animate ? 1 : 0,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tAppTagLine,
                      style: Theme
                          .of(context)
                          .textTheme
                          .headline6,
                    )
                  ],
                ),
              ),
            ),
            AnimatedPositioned(
              duration: const Duration(milliseconds: 1600),
              bottom: 140,
              left: 0,
              right: 0,
              child: FractionallySizedBox(
                widthFactor: 0.8, // Takes 80% of the parent's width.
                child: Image(
                  image: AssetImage(tSplashImage),
                  fit: BoxFit
                      .contain, // Or BoxFit.cover depending on your need.
                ),
              ),
            ),
            AnimatedPositioned(
              duration: const Duration(milliseconds: 1600),
              bottom: 40,
              right: tDefaultSize,
              child: Container(
                width: tSplashContainerSize,
                height: tSplashContainerSize,
                decoration: BoxDecoration(
                  color: tPrimaryColor,
                  borderRadius: BorderRadius.circular(100),
                ),
              ),
            )
          ],
        ));
  }
}
