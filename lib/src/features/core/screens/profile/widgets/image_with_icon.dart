import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import '/src/constants/colors.dart';
import '/src/constants/image_strings.dart';

class ImageWithIcon extends StatelessWidget {
  final String? imageUrl;
  final VoidCallback onImageUpdate;

  const ImageWithIcon({
    Key? key,
    this.imageUrl,
    required this.onImageUpdate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          width: 120,
          height: 120,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: imageUrl != null
                ? Image.network(imageUrl!, fit: BoxFit.cover)
                : const Image(image: AssetImage(tProfileImage)), // Fallback image
          ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: GestureDetector(
            onTap: onImageUpdate,
            child: Container(
              width: 35,
              height: 35,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  color: tPrimaryColor
              ),
              child: const Icon(LineAwesomeIcons.alternate_pencil, color: Colors.black, size: 20),
            ),
          ),
        ),
      ],
    );
  }
}
