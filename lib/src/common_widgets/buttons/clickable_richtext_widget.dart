import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constants/colors.dart';


class ClickableRichTextWidget extends StatelessWidget {
  const ClickableRichTextWidget({
    required this.text1,
    required this.text2,
    required this.onPressed,
    Key? key,
  }) : super(key: key);

  final String text1, text2;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text.rich(
          TextSpan(
            children: [
              TextSpan(text: '${text1.tr}? ', style: Theme.of(context).textTheme.bodyMedium),
              TextSpan(
                text: text2.tr,
                style: Theme.of(context).textTheme.titleLarge!.apply(color: tFacebookBgColor),
              ),
            ],
          ),
        ),
      ),
    );
  }
}