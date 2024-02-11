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


// class SplashScreen extends StatelessWidget {
//   const SplashScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final controller = Get.put(FadeInAnimationController());
//     controller.startSplashAnimation();
//
//     return SafeArea(
//       child: Scaffold(
//         body: Stack(
//           children: [
//           TFadeInAnimation(
//           durationInMs: 1600,
//           animate: TAnimatePosition(
//             topAfter: 0,
//             topBefore: -30,
//             leftBefore: -30,
//             leftAfter: 15,
//           ),
//           child: SizedBox(
//             width: 200.0, // Specify the width you want
//             height: 200.0, // And the height you want
//             child: Image(
//               image: AssetImage(tSplashTopIcon),
//             ),
//           ),
//         ),
//         TFadeInAnimation(
//           durationInMs: 1600,
//           animate: TAnimatePosition(
//             topBefore: 135,
//             topAfter: 135,
//             leftAfter: tDefaultSpace,
//             leftBefore: -80,
//           ),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 tAppTagLine,
//                 style: Theme
//                     .of(context)
//                     .textTheme
//                     .displayMedium,
//               )
//             ],
//           ),
//         ),
//         TFadeInAnimation(
//           durationInMs: 1600,
//           animate: TAnimatePosition(bottomBefore: 140, bottomAfter: 140),
//           child: FractionallySizedBox(
//           widthFactor: 0.8, // Takes 80% of the parent's width.
//           child: Image(
//             image: AssetImage(tSplashImage),
//             fit: BoxFit.contain, // Or BoxFit.cover depending on your need.
//           ),
//         ),
//       ),
//       TFadeInAnimation(
//         durationInMs: 1600,
//         animate: TAnimatePosition(
//             bottomBefore: 40,
//             bottomAfter: 40,
//             rightBefore: tDefaultSize,
//             rightAfter: tDefaultSize),
//         child: Container(
//           width: tSplashContainerSize,
//           height: tSplashContainerSize,
//           decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(100),
//               color: tPrimaryColor),
//         ),
//       ),
//       ],
//     ),)
//     ,
//     );
//   }
// }

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool animate = false;

  @override
  void initState() {
    startAnimation();
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

  Future startAnimation() async {
    await Future.delayed(Duration(milliseconds: 500));
    setState(() {
      animate = true;
    });
    await Future.delayed(Duration(milliseconds: 5000));
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => OnBoardingScreen()),
    );
  }
}
