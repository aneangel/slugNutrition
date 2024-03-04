import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class BMICalculatorScreen extends StatefulWidget {
  @override
  _BMICalculatorScreenState createState() => _BMICalculatorScreenState();
}

class _BMICalculatorScreenState extends State<BMICalculatorScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  double _bmi = 0;
  String _selectedUnit = 'cm';
  String _selectedWUnit = 'kg';
  File? _profileImage;

  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    // Let user select photo from gallery
    final pickedFile = await _picker.pickImage(
      source: ImageSource.gallery, // or ImageSource.camera for camera
      maxWidth: 400,
      maxHeight: 400,
      imageQuality: 100,
    );

    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _heightController.addListener(_formatHeightInput);
  }

  @override
  void dispose() {
    _heightController.removeListener(_formatHeightInput);
    _heightController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  void _formatHeightInput() {
    if (_selectedUnit == 'ft') {
      final text = _heightController.text;
      // Regex to match feet and optional inches with or without quotes
      final regex = RegExp(r'^(\d+)' r"'?" r'(\d{0,2})' r'"?$');

      if (regex.hasMatch(text)) {
        final match = regex.firstMatch(text)!;
        String feet = match.group(1)!;
        String inches = match.group(2)!;

        // Check if the last character is a digit or a quote
        bool isLastCharDigit = text.isNotEmpty && '0123456789'.contains(text[text.length - 1]);

        // If inches are 2 digits long, or the last character is not a digit, auto-format with a closing quote
        if (inches.length == 2 || (!isLastCharDigit && inches.isNotEmpty)) {
          inches += '"';
        }

        // Rebuild the formatted text only if inches are present or the last character is a quote
        if (inches.isNotEmpty || text.endsWith('"')) {
          String formattedText = "$feet'$inches";
          // Update the controller text without moving the cursor to the end
          TextEditingValue value = TextEditingValue(
            text: formattedText,
            selection: TextSelection.collapsed(offset: _heightController.selection.baseOffset),
          );

          // Prevent cursor from moving to the end when deleting characters
          if (value.text.length >= _heightController.value.text.length || text.endsWith('"')) {
            _heightController.value = value;
          }
        }
      }
    }
  }


  double convertFeetInchesToCm(String feetInches) {
    final parts = feetInches.split("'");
    if (parts.length >= 1) {
      final feet = int.parse(parts[0]);
      final inches = parts.length > 1 ? int.parse(parts[1].replaceAll('"', '')) : 0;
      return ((feet * 12) + inches) * 2.54;
    }
    return 0;
  }

  double convertPoundsToKg(double pounds) {
    return pounds * 0.453592;
  }

  void calculateBMI() {
    double heightInCm;
    if (_selectedUnit == 'ft') {
      heightInCm = convertFeetInchesToCm(_heightController.text);
    } else {
      heightInCm = double.parse(_heightController.text);
    }

    final weightInKg = _selectedWUnit == 'lbs'
        ? convertPoundsToKg(double.parse(_weightController.text))
        : double.parse(_weightController.text);

    if (heightInCm > 0) {
      final heightInMeters = heightInCm / 100;
      setState(() {
        _bmi = weightInKg / (heightInMeters * heightInMeters);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BMI Calculator'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Center(
                child: GestureDetector(
                  onTap: _pickImage,
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.grey.shade200,
                    backgroundImage: _profileImage != null
                        ? FileImage(_profileImage!)
                        : null,
                    child: _profileImage == null
                        ? Icon(Icons.camera_alt, color: Colors.grey.shade800)
                        : null,
                  ),
                ),
              ),
              TextFormField(
                controller: _heightController,
                decoration: InputDecoration(
                  labelText: 'Height (${_selectedUnit == 'cm' ? 'cm' : 'ft'})',
                ),
                keyboardType: TextInputType.number,
              ),
              Row(
                children: [
                  TextButton(
                    onPressed: () => setState(() => _selectedUnit = 'cm'),
                    child: Text('cm', style: TextStyle(color: _selectedUnit == 'cm' ? Colors.blue : Colors.grey)),
                  ),
                  TextButton(
                    onPressed: () => setState(() => _selectedUnit = 'ft'),
                    child: Text('ft', style: TextStyle(color: _selectedUnit == 'ft' ? Colors.blue : Colors.grey)),
                  ),
                ],
              ),
              TextFormField(
                controller: _weightController,
                decoration: InputDecoration(
                  labelText: 'Weight (${_selectedWUnit == 'kg' ? 'kg' : 'lbs'})',
                ),
                keyboardType: TextInputType.number,
              ),
              Row(
                children: [
                  TextButton(
                    onPressed: () => setState(() => _selectedWUnit = 'kg'),
                    child: Text('kg', style: TextStyle(color: _selectedWUnit == 'kg' ? Colors.blue : Colors.grey)),
                  ),
                  TextButton(
                    onPressed: () => setState(() => _selectedWUnit = 'lbs'),
                    child: Text('lbs', style: TextStyle(color: _selectedWUnit == 'lbs' ? Colors.blue : Colors.grey)),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      calculateBMI();
                    }
                  },
                  child: const Text('Calculate BMI'),
                ),
              ),
              Center(
                child: _bmi > 0 ? Text('Your BMI is ${_bmi.toStringAsFixed(2)}') : Container(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}