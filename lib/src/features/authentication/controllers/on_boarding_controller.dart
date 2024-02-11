import 'package:get/get.dart';
import 'package:liquid_swipe/PageHelpers/LiquidController.dart';
import '../../../constants/colors.dart';
import '../../../constants/image_strings.dart';
import '../../../constants/text_strings.dart';
import '../models/model_on_boarding.dart';
import '/src/features/authentication/screens/on_boarding/on_boarding_page_widget.dart';
import '/src/features/authentication/screens/welcome/welcome_screen.dart'; // Ensure you have this screen defined

class OnBoardingController extends GetxController {
  final LiquidController controller = LiquidController();
  RxInt currentPage = 0.obs;

  // Functions to trigger Skip, Next, and onPageChange events
  void skip() {
    // Navigate to WelcomeScreen if on the last page or skipping
    Get.offAll(() => WelcomeScreen()); // Replace WelcomeScreen() with your next screen widget
  }

  void animateToNextSlide() {
    if (currentPage.value < pages.length - 1) {
      controller.animateToPage(page: currentPage.value + 1);
    } else {
      // Already on the last page, navigate to WelcomeScreen
      Get.offAll(() => WelcomeScreen()); // This ensures navigation to the WelcomeScreen
    }
  }

  void onPageChangedCallback(int activePageIndex) {
    currentPage.value = activePageIndex;
    // If the user reaches the last page and attempts to swipe further, navigate to the welcome screen
    if (currentPage.value == pages.length - 1) {
      // You can delay the navigation to give a smooth transition or a hint to the user
      Future.delayed(Duration(milliseconds: 500), () {
        // Check again if still on the last page to avoid race conditions
        if (currentPage.value == pages.length - 1) {
          Get.offAll(() => WelcomeScreen());
        }
      });
    }
  }

  // Your pages initialization
  final pages = [
    OnBoardingPageWidget(
      model: OnBoardingModel(
        image: tOnBoardingImage1,
        title: tOnBoardingTitle1,
        subTitle: tOnBoardingSubTitle1,
        counterText: tOnBoardingCounter1,
        bgColor: tOnBoardingPage1Color,
      ),
    ),
    OnBoardingPageWidget(
      model: OnBoardingModel(
        image: tOnBoardingImage2,
        title: tOnBoardingTitle2,
        subTitle: tOnBoardingSubTitle2,
        counterText: tOnBoardingCounter2,
        bgColor: tOnBoardingPage2Color,
      ),
    ),
    OnBoardingPageWidget(
      model: OnBoardingModel(
        image: tOnBoardingImage3,
        title: tOnBoardingTitle3,
        subTitle: tOnBoardingSubTitle3,
        counterText: tOnBoardingCounter3,
        bgColor: tOnBoardingPage3Color,
      ),
    ),
  ];
}

// import 'package:get/get.dart';
// import 'package:liquid_swipe/PageHelpers/LiquidController.dart';
// import '../../../constants/colors.dart';
// import '../../../constants/image_strings.dart';
// import '../../../constants/text_strings.dart';
// import '../models/model_on_boarding.dart';
// import '../screens/on_boarding/on_boarding_page_widget.dart';
//
// class OnBoardingController extends GetxController{
//
//   //Variables
//   final controller = LiquidController();
//   RxInt currentPage = 0.obs;
//
//   //Functions to trigger Skip, Next and onPageChange Events
//   skip() => controller.jumpToPage(page: 2);
//   animateToNextSlide() => controller.animateToPage(page: controller.currentPage + 1);
//   onPageChangedCallback(int activePageIndex) => currentPage.value = activePageIndex;
//
//   //Three Onboarding Pages
//   final pages = [
//     OnBoardingPageWidget(
//       model: OnBoardingModel(
//         image: tOnBoardingImage1,
//         title: tOnBoardingTitle1,
//         subTitle: tOnBoardingSubTitle1,
//         counterText: tOnBoardingCounter1,
//         bgColor: tOnBoardingPage1Color,
//       ),
//     ),
//     OnBoardingPageWidget(
//       model: OnBoardingModel(
//         image: tOnBoardingImage2,
//         title: tOnBoardingTitle2,
//         subTitle: tOnBoardingSubTitle2,
//         counterText: tOnBoardingCounter2,
//         bgColor: tOnBoardingPage2Color,
//       ),
//     ),
//     OnBoardingPageWidget(
//       model: OnBoardingModel(
//         image: tOnBoardingImage3,
//         title: tOnBoardingTitle3,
//         subTitle: tOnBoardingSubTitle3,
//         counterText: tOnBoardingCounter3,
//         bgColor: tOnBoardingPage3Color,
//       ),
//     ),
//   ];
// }