import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import '/src/constants/sizes.dart';
import '/src/repository/authentication_repository/authentication_repository.dart';

import '../../../../constants/text_strings.dart';
import '../../controllers/mail_verification_controller.dart';

class MailVerification extends StatelessWidget {
  const MailVerification({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(MailVerificationController());
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(
              top: tDefaultSpace * 5, left: tDefaultSpace, right: tDefaultSpace, bottom: tDefaultSpace * 2),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(LineAwesomeIcons.envelope_open, size: 100),
              const SizedBox(height: tDefaultSpace * 2),
              Text(tEmailVerificationTitle.tr, style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: tDefaultSpace),
              Text(
                tEmailVerificationSubTitle.tr,
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: tDefaultSpace * 2),
              SizedBox(
                width: 200,
                child: OutlinedButton(child: Text(tContinue.tr), onPressed: () => controller.manuallyCheckEmailVerificationStatus()),
              ),
              const SizedBox(height: tDefaultSpace * 2),
              TextButton(
                onPressed: () => controller.sendVerificationEmail(),
                child: Text(tResendEmailLink.tr),
              ),
              TextButton(
                onPressed: () => AuthenticationRepository.instance.logout(),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(LineAwesomeIcons.alternate_long_arrow_left),
                    const SizedBox(width: 5),
                    Text(tBackToLogin.tr.toLowerCase()),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
