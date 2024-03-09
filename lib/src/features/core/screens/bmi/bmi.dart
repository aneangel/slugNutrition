import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import '../../models/profile/bmi_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '/src/features/core/screens/profile/dietary_preferences/dietary_preferences_form.dart';
import '/src/features/core/controllers/bmi_controller.dart';
import '/src/features/core/models/bmi/bmi_model.dart';
import 'package:get/get.dart';
import 'package:firebase_storage/firebase_storage.dart';

class BMICalculatorScreen extends StatefulWidget {
  @override
  _BMICalculatorScreenState createState() => _BMICalculatorScreenState();
}

class _BMICalculatorScreenState extends State<BMICalculatorScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  double _bmi = 0;
  double _heightInCm = 0;
  double _weightInKg = 0;
  String _heightUnit = 'cm'; // Default unit
  String _weightUnit = 'kg'; // Default unit
  String _selectedUnit = 'cm';
  String _selectedWUnit = 'kg';
  File? _profileImage;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();

  // Define the list of activity levels
  final List<String> _activityLevels = [
    'Sedentary (little or no exercise)',
    'Lightly active (light exercise/sports 1-3 days a week)',
    'Moderately active (moderate exercise/sports 3-5 days a week)',
    'Very active (hard exercise/sports 6-7 days a week)',
    'Super active (very hard exercise & a physical job)'
  ];

// Variable to hold the current selection
  String _selectedActivityLevel = 'Sedentary (little or no exercise)';

  int _selectedGenderIndex = 0; // 0 for male, 1 for female
  List<bool> _isSelectedGender = [
    true,
    false,
    false
  ]; // Male is selected by default

  void _handleGenderSelection(int index) {
    setState(() {
      for (int i = 0; i < _isSelectedGender.length; i++) {
        _isSelectedGender[i] = i == index;
      }
      _selectedGenderIndex = index;
    });
  }

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

  Future<void> saveBMIInfo(BMIModel bmiModel, File? profileImage) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null && user.email != null) {
      try {
        String imageUrl = '';
        // If there's a profile image selected, upload it
        if (profileImage != null) {
          var storageRef = FirebaseStorage.instance.ref().child('profileImages/${user.uid}.jpg');
          var uploadTask = await storageRef.putFile(profileImage);
          imageUrl = await uploadTask.ref.getDownloadURL();
          print("Image URL: $imageUrl"); // Log the image URL
        }

        Map<String, dynamic> bmiData = bmiModel.toJson();
        // Include the profile image URL in the data
        bmiData['profileImageUrl'] = imageUrl;

        DocumentReference userDoc = FirebaseFirestore.instance.collection('users').doc(user.email);
        await userDoc.collection('forms').doc('bmiForm').set(bmiData);
        print("BMI Data saved successfully"); // Confirm data was saved
      } catch (e) {
        print("Error saving BMI data: $e"); // Log any errors
      }
    } else {
      print("User not logged in or email is null"); // User authentication check
    }
  }


  void calculateBMI() {
    print("calculateBMI called");

    // Debugging: print the selected units
    print("Selected height unit: $_selectedUnit");
    print("Selected weight unit: $_selectedWUnit");

    // Assuming you have validation in place and users can switch between units
    if (_selectedUnit == 'cm') {
      _heightInCm = double.tryParse(_heightController.text) ?? 0;
    } else if (_selectedUnit == 'ft') {
      _heightInCm = convertFeetInchesToCm(_heightController.text);
    }

    if (_selectedWUnit == 'kg') {
      _weightInKg = double.tryParse(_weightController.text) ?? 0;
    } else if (_selectedWUnit == 'lbs') {
      _weightInKg =
          convertPoundsToKg(double.tryParse(_weightController.text) ?? 0);
    }

    // Debugging: print the parsed values
    print("Parsed height in cm: $_heightInCm");
    print("Parsed weight in kg: $_weightInKg");

    if (_heightInCm > 0 && _weightInKg > 0) {
      final heightInMeters = _heightInCm / 100;
      final bmi = _weightInKg / (heightInMeters * heightInMeters);
      print("Calculated BMI: $bmi");
      setState(() {
        _bmi = bmi;
      });
    } else {
      // Handle error: invalid height or weight input
      print("Invalid input for height or weight");
    }
    if (_heightInCm > 0 && _weightInKg > 0) {
      final bmiModel = BMIModel(
        height: _heightInCm,
        weight: _weightInKg,
        bmi: _bmi,
        activityLevel: _selectedActivityLevel,
        gender: _selectedGenderIndex == 0 ? 'Male' : (_selectedGenderIndex == 1 ? 'Female' : 'Others'),
        name: _nameController.text,
        age: int.parse(_ageController.text),
        // profileImageUrl: '', // Add this after you handle image upload
      );

      // Call a function to save this BMIModel instance to Firestore
      saveBMIInfo(bmiModel,_profileImage).then((_) {
        // Navigate to DietaryPreferencesForm upon successful saving
        // If using named routes:
        // Get.toNamed('/dietaryPreferencesForm');

        // If not using named routes:
        Get.to(() => DietaryPreferencesForm()); // Make sure you have imported DietaryPreferencesForm
      }).catchError((error) {
        // Handle errors if saving fails
        print("Error saving BMI data: $error");
      });
    } else {
      // Handle error: invalid height or weight input
      print("Invalid input for height or weight");
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
    final bmiController = Get.find<BmiController>();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('COMPLETE YOUR PROFILE'),
        backgroundColor: Colors.white,
        elevation: 0, // Removes shadow
        foregroundColor: Colors.black, // Text color
      ),
      body: Padding(
        padding: const EdgeInsets.all(25.0),
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
              SizedBox(height: 30),
              TextFormField(
                  controller: _nameController,
                  style: TextStyle(
                    color: Colors.black,
                  ),
                  decoration: InputDecoration(
                    labelStyle: TextStyle(
                      fontSize: 15,
                      color: Colors.grey.shade600,
                    ),
                    labelText: 'Name',
                    contentPadding: EdgeInsets.all(15),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                      borderSide: BorderSide(color: Colors.grey.shade400),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                      borderSide: BorderSide(color: Colors.purple),
                    ),
                    floatingLabelStyle: TextStyle(
                      color: Colors.purple,
                    ),
                  )),
              SizedBox(height: 30),
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
                  contentPadding:
                  EdgeInsets.only(left: 20, top: 14, bottom: 14),
                  // Adjust these values as needed
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
                            foregroundColor: _selectedUnit == 'cm'
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
                            foregroundColor: _selectedUnit == 'ft'
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
              SizedBox(height: 30),
              TextFormField(
                controller: _weightController,
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
                  contentPadding:
                  EdgeInsets.only(left: 20, top: 14, bottom: 14),
                  // Adjust these values as needed
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
                            foregroundColor: _selectedWUnit == 'kg'
                                ? Colors.purple
                                : Colors.grey,
                          ),
                          onPressed: () {
                            setState(() => _selectedWUnit = 'kg');
                            print('Weight unit set to $_selectedWUnit');
                          },
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
                            foregroundColor: _selectedWUnit == 'lbs'
                                ? Colors.purple
                                : Colors.grey,
                          ),
                          onPressed: () {
                            setState(() => _selectedWUnit = 'lbs');
                            print('Weight unit set to $_selectedWUnit');
                          },
                          child: Text('lbs'),
                        ),
                      ],
                    ),
                  ),
                ),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 30),
              TextFormField(
                controller: _ageController,
                decoration: InputDecoration(
                  labelStyle: TextStyle(
                    fontSize: 15,
                    color: Colors.grey
                        .shade600, // Changes the color of the labelText (placeholder)
                  ),
                  labelText: 'Age',
                  contentPadding:
                  EdgeInsets.only(left: 20, top: 14, bottom: 14),
                  // Adjust these values as needed
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
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value != null && int.tryParse(value) == null) {
                    return 'Please enter a valid age';
                  }
                  return null;
                },
              ),
              SizedBox(height: 30), // Provides spacing between input fields
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Activity Level',
                  contentPadding:
                  EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                    borderSide: BorderSide(
                      color: Colors.grey.shade400,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                    borderSide: BorderSide(color: Colors.purple),
                  ),
                  floatingLabelStyle: TextStyle(
                    color: Colors.purple,
                  ),
                ),
                value: _selectedActivityLevel,
                items: _activityLevels
                    .map<DropdownMenuItem<String>>((String level) {
                  return DropdownMenuItem<String>(
                    value: level,
                    child: Text(level, style: TextStyle(fontSize: 14)),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedActivityLevel = newValue!;
                  });
                },
                selectedItemBuilder: (BuildContext context) {
                  return _activityLevels.map<Widget>((String level) {
                    return Text(level.split(' (')[0],
                        style: TextStyle(
                            fontSize: 14)); // Extract text before the brackets
                  }).toList();
                },
              ),

              SizedBox(height: 30),
              Center(
                child: ToggleButtons(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(16.0),
                      // Add some padding for better visual appearance
                      child: Text('Male'),
                    ),
                    Padding(
                      padding: EdgeInsets.all(16.0),
                      // Add some padding for better visual appearance
                      child: Text('Female'),
                    ),
                    Padding(
                      padding: EdgeInsets.all(16.0),
                      // Add some padding for better visual appearance
                      child: Text('Others'),
                    ),
                  ],
                  onPressed: (int index) {
                    _handleGenderSelection(index);
                  },
                  isSelected: _isSelectedGender,
                  color: Colors.grey,
                  selectedColor: Colors.purple,
                  fillColor: Colors.purple.withOpacity(0.1),
                  renderBorder: false,
                  borderRadius: BorderRadius.circular(15.0),
                ),
              ),
              SizedBox(height: 40),
              Center(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 32.0),
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        // Your validation logic or function call
                        BmiData bmiData = BmiData(
                          height: double.parse(_heightController.text),
                          weight: double.parse(_weightController.text),
                          // Include other fields as necessary
                        );
                        bmiController.updateBmiData(bmiData);
                        calculateBMI();
                        Get.to(() => DietaryPreferencesForm());
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white, // Background color
                      foregroundColor: Colors.purple.shade600, // Text color
                      side: BorderSide(color: Colors.grey.shade700, width: 2), // Border color and width
                      padding: EdgeInsets.symmetric(vertical: 12.0), // Increase padding to ensure text fits well
                      textStyle: TextStyle(fontSize: 18,), // Increase fontSize here
                      // Fixed size for the button, adjust width and height as needed
                      minimumSize: Size(200, 50), // Set a minimum size for the button
                    ),
                    child: Text('Next'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}