import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class EditableImage extends StatefulWidget {
  final File? image;
  final double size;
  final ThemeData imagePickerTheme;
  final Border imageBorder;
  final Border editIconBorder;
  final Function(File?) onChange;

  const EditableImage({
    Key? key,
    this.image,
    required this.size,
    required this.imagePickerTheme,
    required this.imageBorder,
    required this.editIconBorder,
    required this.onChange,
  }) : super(key: key);

  @override
  _EditableImageState createState() => _EditableImageState();
}

class _EditableImageState extends State<EditableImage> {
  File? _imageFile;

  @override
  void initState() {
    super.initState();
    _imageFile = widget.image;
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
      widget.onChange(_imageFile);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: widget.imagePickerTheme,
      child: InkWell(
        onTap: _pickImage,
        child: Container(
          width: widget.size,
          height: widget.size,
          decoration: BoxDecoration(
            border: widget.imageBorder,
            shape: BoxShape.circle,
          ),
          child: _imageFile != null
              ? ClipOval(child: Image.file(_imageFile!, fit: BoxFit.cover))
              : Container(
            decoration: BoxDecoration(
              color: Colors.grey[200],
              border: widget.editIconBorder,
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.edit, color: Colors.black87),
          ),
        ),
      ),
    );
  }
}
