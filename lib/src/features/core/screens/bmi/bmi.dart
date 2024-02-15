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
  String _heightUnit = 'cm'; // Default unit
  String _weightUnit = 'kg'; // Default unit
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

  void calculateBMI() {
    final heightInCm =
        convertFeetInchesToCm(_heightController.text); // Height conversion
    final weightInKg = convertPoundsToKg(
        double.parse(_weightController.text)); // Weight conversion

    if (heightInCm > 0) {
      final heightInMeters = heightInCm / 100;
      final bmi = weightInKg / (heightInMeters * heightInMeters);
      // Use the BMI value for your logic
      print("BMI is $bmi");
    } else {
      // Handle error: invalid height input
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
    String text = _heightController.text;

    // This is a basic implementation and might need adjustments
    // to handle edge cases and improve usability.
    if (_selectedUnit == 'ft' &&
        text.isNotEmpty &&
        !text.contains("'") &&
        text.length <= 2) {
      text += "'"; // Append a single quote to indicate feet
      _heightController.value = TextEditingValue(
        text: text,
        selection: TextSelection.collapsed(offset: text.length),
      );
    }
  }

  double convertFeetInchesToCm(String feetInches) {
    final parts = feetInches.split("'");
    if (parts.length == 2) {
      final feet = int.parse(parts[0]);
      final inches = int.parse(parts[1]);
      return ((feet * 12) + inches) * 2.54; // Convert total inches to cm
    }
    return 0; // Default to 0 or handle error appropriately
  }

  double convertPoundsToKg(double pounds) {
    return pounds * 0.453592;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('BMI Calculator'),
        backgroundColor: Colors.white,
        elevation: 0, // Removes shadow
        foregroundColor: Colors.black, // Text color
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
              SizedBox(height: 20),
              TextFormField(
                controller: _heightController,
                style: TextStyle(
                  color:
                      Colors.black, // This sets the input text color to black
                ),
                decoration: InputDecoration(
                  labelStyle: TextStyle(
                    fontSize: 15,
                    color: Colors.grey
                        .shade600, // Changes the color of the labelText (placeholder)
                  ),
                  labelText: 'Height',
                  contentPadding: EdgeInsets.only(
                      left: 20,
                      top: 14,
                      bottom: 14), // Adjust these values as needed
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                    borderSide: BorderSide(
                        color: Colors.grey.shade400), // Default Border Color
                  ),
                  focusedBorder: OutlineInputBorder(
                    // Border style when the input field is focused
                    borderRadius: BorderRadius.circular(15.0),
                    borderSide: BorderSide(color: Colors.purple),
                  ),
                  floatingLabelStyle: TextStyle(
                    color: Colors
                        .purple, // Optional: Use this to change floating label color when focused
                  ),
                  suffixIcon: Container(
                    width:
                        150, // Give it an appropriate size to fit the buttons
                    child: Row(
                      mainAxisAlignment:
                          MainAxisAlignment.end, // Align to the right
                      children: [
                        TextButton(
                          style: TextButton.styleFrom(
                            primary: _selectedUnit == 'cm'
                                ? Colors.purple
                                : Colors.grey,
                          ),
                          onPressed: () => setState(() => _selectedUnit = 'cm'),
                          child: Text('cm'),
                        ),
                        Container(
                          height:
                              20, // Adjust the height to fit within the input field
                          child: VerticalDivider(
                            color: Colors.black, // Color of the vertical bar
                            width: 20, // Space it takes horizontally
                            thickness: 1, // Thickness of the bar
                          ),
                        ),
                        TextButton(
                          style: TextButton.styleFrom(
                            primary: _selectedUnit == 'ft'
                                ? Colors.purple
                                : Colors.grey,
                          ),
                          onPressed: () => setState(() => _selectedUnit = 'ft'),
                          child: Text('ft'),
                        ),
                      ],
                    ),
                  ),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value != null && value.contains("'")) {
                    final parts = value.split("'");
                    if (parts.length == 2) {
                      final feet = int.tryParse(parts[0]);
                      final inches = int.tryParse(parts[1]);
                      if (feet == null || inches == null) {
                        return 'Invalid format';
                      }
                      if (inches >= 11) {
                        return 'Inches must be less than 12';
                      }
                    } else {
                      return 'Invalid format';
                    }
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                style: TextStyle(
                  color:
                      Colors.black, // This sets the input text color to black
                ),
                decoration: InputDecoration(
                  labelStyle: TextStyle(
                    fontSize: 15,
                    color: Colors.grey
                        .shade600, // Changes the color of the labelText (placeholder)
                  ),
                  labelText: 'Weight',
                  contentPadding: EdgeInsets.only(
                      left: 20,
                      top: 14,
                      bottom: 14), // Adjust these values as needed
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                    borderSide: BorderSide(
                        color: Colors.grey.shade400), // Default Border Color
                  ),
                  focusedBorder: OutlineInputBorder(
                    // Border style when the input field is focused
                    borderRadius: BorderRadius.circular(15.0),
                    borderSide: BorderSide(color: Colors.purple),
                  ),
                  floatingLabelStyle: TextStyle(
                    color: Colors
                        .purple, // Optional: Use this to change floating label color when focused
                  ),
                  suffixIcon: Container(
                    width:
                        150, // Give it an appropriate size to fit the buttons
                    child: Row(
                      mainAxisAlignment:
                          MainAxisAlignment.end, // Align to the right
                      children: [
                        TextButton(
                          style: TextButton.styleFrom(
                            primary: _selectedWUnit == 'kg'
                                ? Colors.purple
                                : Colors.grey,
                          ),
                          onPressed: () =>
                              setState(() => _selectedWUnit = 'kg'),
                          child: Text('kg'),
                        ),
                        Container(
                          height:
                              20, // Adjust the height to fit within the input field
                          child: VerticalDivider(
                            color: Colors.black, // Color of the vertical bar
                            width: 20, // Space it takes horizontally
                            thickness: 1, // Thickness of the bar
                          ),
                        ),
                        TextButton(
                          style: TextButton.styleFrom(
                            primary: _selectedWUnit == 'lbs'
                                ? Colors.purple
                                : Colors.grey,
                          ),
                          onPressed: () =>
                              setState(() => _selectedWUnit = 'lbs'),
                          child: Text('lbs'),
                        ),
                      ],
                    ),
                  ),
                ),
                keyboardType: TextInputType.number,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      calculateBMI();
                    }
                  },
                  child: Text('Calculate BMI'),
                ),
              ),
              if (_bmi > 0)
                Text(
                  'Your BMI is ${_bmi.toStringAsFixed(2)}',
                  style: TextStyle(
                    color: Colors.black, // Set the text color to black
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
