import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '/src/features/authentication/screens/mail_verification/mail_verification.dart';
import '/src/features/authentication/screens/welcome/welcome_screen.dart';
import '/src/features/core/screens/dashboard/dashboard.dart';
import 'exceptions/t_exceptions.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '/src/features/authentication/screens/on_boarding/on_boarding_screen.dart';
import '/src/repository/user_repository/user_repository.dart';
import '/src/features/core/screens/profile/dietary_preferences/dietary_preferences_form.dart';
import 'package:slugnutrition/src/features/core/screens/bmi/bmi.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


// /// -- README(Docs[6]) -- Bindings
class AuthenticationRepository extends GetxController {
  static AuthenticationRepository get instance => Get.find();

  /// Variables
  late final Rx<User?> _firebaseUser;
  final _auth = FirebaseAuth.instance;
  final _phoneVerificationId = ''.obs;

  /// Getters
  User? get firebaseUser => _firebaseUser.value;
  String get getUserID => firebaseUser?.uid ?? "";
  String get getUserEmail => firebaseUser?.email ?? "";
  String get getDisplayName => firebaseUser?.displayName ?? "";
  String get getPhoneNo => firebaseUser?.phoneNumber ?? "";

  /// Loads when app Launch from main.dart
  @override
  void onReady() {
    _firebaseUser = Rx<User?>(_auth.currentUser);
    _firebaseUser.bindStream(_auth.userChanges());
    setInitialScreen();
    // ever(_firebaseUser, _setInitialScreen);
  }

  /// Setting initial screen
  /// Setting initial screen with onboarding check
  // Future<void> setInitialScreen() async {
  //   User? user = _auth.currentUser;
  //   if (user != null) {
  //     // User is logged in, navigate to Dashboard
  //     Get.offAll(() => const Dashboard());
  //   } else {
  //     // No user is logged in, navigate to Welcome Screen
  //     Get.offAll(() => const OnBoardingScreen());
  //   }
  // }
  Future<void> setInitialScreen() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      // Check if the user has a BMI form
      bool hasBmiData = await checkForFormData(user.email!, 'bmiForm');
      if (!hasBmiData) {
        // User needs to fill out BMI form
        Get.offAll(() => BMICalculatorScreen());
        return;
      }

      // Check if the user has a dietary preferences form
      bool hasDietaryData = await checkForFormData(user.email!, 'dietaryPreferencesForm');
      if (!hasDietaryData) {
        // User needs to fill out dietary preferences form
        Get.offAll(() => DietaryPreferencesForm());
        return;
      }

      // If the user has both forms, navigate to Dashboard
      Get.offAll(() => Dashboard());
    } else {
      // No user is logged in, navigate to Welcome Screen
      Get.offAll(() => OnBoardingScreen());
    }
  }

  Future<bool> checkForFormData(String userEmail, String formName) async {
    try {
      // Attempt to get the form document
      DocumentSnapshot formDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userEmail)
          .collection('forms')
          .doc(formName)
          .get();
      // The form exists if the document snapshot exists
      return formDoc.exists;
    } catch (e) {
      // If there's an error accessing Firestore, handle it here
      print("Error checking for form data: $e");
      return false;
    }
  }





  /* ---------------------------- Email & Password sign-in ---------------------------------*/

  /// [EmailAuthentication] - LOGIN
  Future<void> loginWithEmailAndPassword(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      Get.offAll(() => const Dashboard());
    } on FirebaseAuthException catch (e) {
      final result = TExceptions.fromCode(e.code); // Throw custom [message] variable
      throw result.message;
    } catch (_) {
      const result = TExceptions();
      throw result.message;
    }
  }

  /// [EmailAuthentication] - REGISTER
  Future<void> registerWithEmailAndPassword(String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(email: email, password: password);
      await sendEmailVerification();
      // Navigate to the MailVerification screen
      Get.offAll(() => const MailVerification());
    } on FirebaseAuthException catch (e) {
      final ex = TExceptions.fromCode(e.code);
      throw ex.message;
    } catch (_) {
      const ex = TExceptions();
      throw ex.message;
    }
  }

  /// [EmailVerification] - MAIL VERIFICATION
  Future<void> sendEmailVerification() async {
    try {
      await _auth.currentUser?.sendEmailVerification();
    } on FirebaseAuthException catch (e) {
      final ex = TExceptions.fromCode(e.code);
      throw ex.message;
    } catch (_) {
      const ex = TExceptions();
      throw ex.message;
    }
  }

  /* ---------------------------- Federated identity & social sign-in ---------------------------------*/

  /// [GoogleAuthentication] - GOOGLE
  Future<UserCredential?> signInWithGoogle() async {
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      // Once signed in, return the UserCredential
      return await FirebaseAuth.instance.signInWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      final ex = TExceptions.fromCode(e.code);
      throw ex.message;
    } catch (_) {
      const ex = TExceptions();
      throw ex.message;
    }
  }

  ///[FacebookAuthentication] - FACEBOOK
  Future<UserCredential> signInWithFacebook() async {
    try {
      // Trigger the sign-in flow
      final LoginResult loginResult = await FacebookAuth.instance.login(permissions: ['email']);

      // Create a credential from the access token
      final AccessToken accessToken = loginResult.accessToken!;
      final OAuthCredential facebookAuthCredential = FacebookAuthProvider.credential(accessToken.token);

      // Once signed in, return the UserCredential
      return FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
    } on FirebaseAuthException catch (e) {
      throw e.message!;
    } on FormatException catch (e) {
      throw e.message;
    } catch (e) {
      throw 'Something went wrong. Try again!';
    }
  }

  /// [PhoneAuthentication] - LOGIN
  loginWithPhoneNo(String phoneNumber) async {
    try {
      await _auth.signInWithPhoneNumber(phoneNumber);
    } on FirebaseAuthException catch (e) {
      final ex = TExceptions.fromCode(e.code);
      throw ex.message;
    } catch (e) {
      throw e.toString().isEmpty ? 'Unknown Error Occurred. Try again!' : e.toString();
    }
  }

  /// [PhoneAuthentication] - REGISTER
  Future<void> phoneAuthentication(String phoneNo) async {
    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNo,
        verificationCompleted: (credential) async {
          await _auth.signInWithCredential(credential);
        },
        codeSent: (verificationId, resendToken) {
          _phoneVerificationId.value = verificationId;
        },
        codeAutoRetrievalTimeout: (verificationId) {
          _phoneVerificationId.value = verificationId;
        },
        verificationFailed: (e) {
          final result = TExceptions.fromCode(e.code);
          throw result.message;
        },
      );
    } on FirebaseAuthException catch (e) {
      final result = TExceptions.fromCode(e.code);
      throw result.message;
    } catch (e) {
      throw e.toString().isEmpty ? 'Unknown Error Occurred. Try again!' : e.toString();
    }
  }

  /// [PhoneAuthentication] - VERIFY PHONE NO BY OTP
  Future<bool> verifyOTP(String otp) async {
    var credentials = await _auth.signInWithCredential(
      PhoneAuthProvider.credential(verificationId: _phoneVerificationId.value, smsCode: otp),
    );
    return credentials.user != null ? true : false;
  }

  /* ---------------------------- ./end Federated identity & social sign-in ---------------------------------*/

  /// [LogoutUser] - Valid for any authentication.
  Future<void> logout() async {
    String errorMessage = '';

    // Attempt to sign out from Google.
    try {
      await GoogleSignIn().signOut();
    } catch (e) {
      errorMessage += 'Google sign out failed; ';
    }

    // Attempt to sign out from Firebase.
    try {
      await FirebaseAuth.instance.signOut();
    } catch (e) {
      errorMessage += 'Firebase sign out failed; ';
    }

    if (errorMessage.isNotEmpty) {
      throw Exception(errorMessage);
    } else {
      // Navigate to the Welcome Screen only if all sign out operations succeeded.
      Get.offAll(() => const OnBoardingScreen());
    }
  }

}