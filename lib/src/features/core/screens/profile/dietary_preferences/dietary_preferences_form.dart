
//##################-----DIETARY-PREFERENCES-FORM------##################

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:liquid_swipe/liquid_swipe.dart';
import 'package:slugnutrition/src/constants/sizes.dart';
import 'package:get/get.dart';
import 'package:slugnutrition/src/features/core/screens/bmi/bmi.dart';
import '/src/features/core/screens/dashboard/dashboard.dart';
import '../../../models/profile/dietary_preferences_model.dart';


//---------------------------------DEFINITION----------------------------------

class DietaryPreferencesForm extends StatefulWidget {
  const DietaryPreferencesForm({Key? key}) : super(key: key);

  @override
  _DietaryPreferencesFormState createState() => _DietaryPreferencesFormState();
}


class _DietaryPreferencesFormState extends State<DietaryPreferencesForm> {
  final _formKey = GlobalKey<FormState>();
  String _selectedDietaryRestriction = 'None'; // Added for dropdown
  final Map<String, bool> _allergies = {
    'None': false,
    'Milk': false,
    'Eggs': false,
    'Fish': false,
    'Shellfish': false,
    'Peanuts': false,
    'Tree Nuts': false,
    'Dairy': false,
    'Gluten': false,
    'Soy': false,
    'Wheat': false,
    'Sesame': false,
    'Alcohol': false,
    'Other': false,
  };

  // Additional Preferences
  final Map<String, bool> _preferences = {
    'None': false,
    'Organic': false,
    'Non-GMO': false,
    'Low-Carb': false,
    'Low-Fat': false,
    'Sugar-Free': false,
    'High-Protein': false,
    'Gluten Friendly': false,
  };

  // Food Dislike/Avoid
  final Map<String, bool> _dislikes = {
    'None': false,
    'Pork': false,
    'Beef': false,
    'Halal': false,
    'Chicken': false,
    'Vegan': false,
    "Vegetarian": false,
    'Milk': false,
    'Eggs': false,
    'Fish': false,
    'Shellfish': false,
    'Peanuts': false,
    'Tree Nuts': false,
    'Dairy': false,
    'Gluten': false,
    'Soy': false,
    'Wheat': false,
    'Sesame': false,
    'Alcohol': false,
    'Other': false,
  };

  bool _showOtherAllergyTextField = false;
  String _otherAllergy = '';
  String _dietaryLaws = 'None';
  bool _showOtherDislikeTextField = false;
  String _otherDislike = '';
  bool _showOtherDietaryLawsTextField = false;
  bool _showOtherAdditionalPreferencesTextField = false;
  String _otherDietaryLaw = '';
  double _organicPreference = 0;
  String _foodDislikes = '';
  bool _consent = false;
  String? _selectedDietaryLaw = '';

  get children => null;


  //------------------------------[WIDGET]:MAIN---------------------------------


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dietary Preferences'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
          // Navigate back to BMICalculatorScreen
          // Make sure to handle any necessary data transfer
            Get.off(() => BMICalculatorScreen());
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildBasicDietaryRestrictionsSection(),
              _buildAllergiesSection(),
              _buildReligiousCulturalSection(),
              _buildAdditionalPreferencesSection(),
              _buildFoodDislikesSection(),
              _buildConsentSection(),
              _buildSubmitButton(),
            ],
          ),
        ),
      ),
    );
  }



  //---------------------------[WIDGET]:SECTION CARD----------------------------


  Widget _buildSectionCard({required String title, required List<Widget> children}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0), // Adjust the padding as needed
          child: Text(title, style: Theme.of(context).textTheme.headline6),
        ),
        ...children,
        Divider(),
      ],
    );
  }


  //--------------------[WIDGET]:BASIC DIETARY PREFERENCE----------------------


  Widget _buildBasicDietaryRestrictionsSection() {
    List<String> dietaryOptions = ['None', 'Vegetarian', 'Vegan', 'Pescatarian'];
    //String? _selectedDietaryRestriction; // Ensure this is null initially

    return _buildSectionCard(
      title: 'Basic Dietary Preferences',
      children: [
        SizedBox(height: 8),
        DropdownButtonFormField<String>(
          key: Key('dietaryRestrictionDropdown'),
          decoration: InputDecoration(
            // Use labelText for the floating label that appears when the dropdown is interacted with
            labelText: _selectedDietaryRestriction ?? 'Select your dietary preference',
            contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(15.0)),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15.0),
              borderSide: BorderSide(color: Colors.grey.shade400),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15.0),
              borderSide: BorderSide(color: Colors.purple),
            ),
            floatingLabelStyle: TextStyle(color: Colors.purple),
            floatingLabelBehavior: FloatingLabelBehavior.always, // Ensure the label always floats
          ),
          value: _selectedDietaryRestriction,
          hint: Text(
            'Select your dietary preference', // This will be shown as a hint in the dropdown button when no item is selected
            style: TextStyle(color: Colors.grey.shade500, fontWeight: FontWeight.w300), // Lighter, thinner font for the hint
          ),
          onChanged: (String? newValue) {
            setState(() {
              _selectedDietaryRestriction = newValue!;
            });
          },
          items: dietaryOptions.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
        SizedBox(height: 8),
      ],
    );
  }


//--------------------[WIDGET]:COMMON ALLERGIES------------------------------


  Widget _buildAllergiesSection() {
    bool _noneSelected = _allergies['None'] ?? false;

    return _buildSectionCard(
      title: 'Common Allergies / Intolerances',
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Text(
            "Choose items that you are allergic to:",
            style: TextStyle(color: Colors.grey),
          ),
        ),
        CheckboxListTile(
          key: Key('allergyNone'), // Key for the "None" checkbox
          title: Text('None'),
          value: _noneSelected,
          onChanged: (bool? newValue) {
            setState(() {
              _noneSelected = newValue!;
              _allergies.forEach((key, _) {
                if (key != 'None') _allergies[key] = false;
              });
              _allergies['None'] = _noneSelected;
            });
          },
        ),
        AnimatedOpacity(
          opacity: _noneSelected ? 0.0 : 1.0,
          duration: Duration(milliseconds: 500),
          child: AnimatedSize(
            duration: Duration(milliseconds: 500),
            child: Visibility(
              visible: !_noneSelected,
              child: Column(
                children: _allergies.entries
                    .where((entry) => entry.key != 'None')
                    .map((entry) => CheckboxListTile(
                  key: Key('allergy${entry.key}'), // Dynamic key for each allergy checkbox
                  title: Text(entry.key),
                  value: entry.value,
                  onChanged: (bool? newValue) {
                    setState(() {
                      _allergies[entry.key] = newValue!;
                      if (entry.key == 'Other') {
                        _showOtherAllergyTextField = newValue!;
                      }
                    });
                  },
                ))
                    .toList(),
              ),
            ),
          ),
        ),
        Visibility(
          visible: !_noneSelected && _showOtherAllergyTextField,
          child: AnimatedOpacity(
            opacity: _showOtherAllergyTextField ? 1.0 : 0.0,
            duration: Duration(milliseconds: 500),
            child: Column(
              children: [
                TextFormField(
                  key: const Key('otherAllergyField'),
                  decoration: const InputDecoration(labelText: 'Specify other allergies'),
                  onChanged: (value) {
                    setState(() {
                      _otherAllergy = value;
                    });
                  },
                ),
                SizedBox(height: 8),
              ],
            ),
          ),
        ),
      ],
    );
  }


//---------------------[WIDGET]:RELIGIOUS/CULTURAL LAWS-----------------------


  Widget _buildReligiousCulturalSection() {
    List<String> dietaryLawsOptions = ['None', 'Halal', 'Kosher'];
    // Ensure _selectedDietaryLaw is initialized to a valid value or null
    //String? _selectedDietaryLaw; // Make it nullable to allow no selection initially

    return _buildSectionCard(
      title: 'Religious or Cultural Dietary Laws',
      children: [
        SizedBox(height: 2),
        DropdownButtonFormField<String>(
          key: Key('religiousCulturalLawsDropdown'),
          decoration: InputDecoration(
            labelText: 'Select your dietary law',
            contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(15.0)),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15.0),
              borderSide: BorderSide(color: Colors.grey.shade400),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15.0),
              borderSide: BorderSide(color: Colors.purple),
            ),
            floatingLabelStyle: TextStyle(color: Colors.purple),
          ),
          value: _dietaryLaws, // This can be null, indicating no selection
          onChanged: (String? newValue) {
            setState(() {
              _dietaryLaws = newValue!;
            });
          },
          items: dietaryLawsOptions.map((value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
        SizedBox(height: 8),
      ],
    );
  }



//-----------------------[WIDGET]:ADDITIONAL PREFERENCES----------------------


  Widget _buildAdditionalPreferencesSection() {
    bool _noneSelectedForPreferences = _preferences['None'] ?? false;

    return _buildSectionCard(
      title: 'Additional Preferences',
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Text(
            "Indicate any additional preferences:",
            style: TextStyle(color: Colors.grey),
          ),
        ),
        CheckboxListTile(
          key: Key('preferenceNone'), // Key for the "None" checkbox
          title: Text('None'),
          value: _noneSelectedForPreferences,
          onChanged: (bool? newValue) {
            setState(() {
              _noneSelectedForPreferences = newValue!;
              if (_noneSelectedForPreferences) {
                _preferences.forEach((key, value) {
                  _preferences[key] = false;
                });
              }
              _preferences['None'] = _noneSelectedForPreferences;
            });
          },
        ),
        AnimatedSize(
          duration: Duration(milliseconds: 500),
          child: Visibility(
            visible: !_noneSelectedForPreferences,
            child: Column(
              children: _preferences.entries.where((entry) => entry.key != 'None').map((entry) {
                return CheckboxListTile(
                  key: Key('preference${entry.key.replaceAll(' ', '')}'), // Dynamic key for each preference checkbox
                  title: Text(entry.key),
                  value: entry.value,
                  onChanged: (bool? newValue) {
                    setState(() {
                      _preferences[entry.key] = newValue!;
                    });
                  },
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }





  //--------------------[WIDGET]:FOOD DISLIKES---------------------------


  Widget _buildFoodDislikesSection() {
    bool _noneSelectedForDislikes = _dislikes['None'] ?? false;

    return _buildSectionCard(
      title: 'Food Dislikes',
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Text(
            "Choose items that you would like to avoid:",
            style: TextStyle(color: Colors.grey),
          ),
        ),
        CheckboxListTile(
          key: Key('dislikeNone'), // Key for the "None" checkbox
          title: Text('None'),
          value: _noneSelectedForDislikes,
          onChanged: (bool? newValue) {
            setState(() {
              _noneSelectedForDislikes = newValue!;
              if (_noneSelectedForDislikes) {
                _dislikes.forEach((key, value) {
                  _dislikes[key] = false;
                });
              }
              _dislikes['None'] = _noneSelectedForDislikes;
            });
          },
        ),
        AnimatedSize(
          duration: Duration(milliseconds: 500),
          child: Visibility(
            visible: !_noneSelectedForDislikes,
            child: Column(
              children: _dislikes.entries.where((entry) => entry.key != 'None').map((entry) {
                return CheckboxListTile(
                  key: Key('dislike${entry.key.replaceAll(' ', '')}'), // Dynamic key for each dislike checkbox
                  title: Text(entry.key),
                  value: entry.value,
                  onChanged: (bool? newValue) {
                    setState(() {
                      _dislikes[entry.key] = newValue!;
                      if (entry.key == 'Other') {
                        _showOtherDislikeTextField = newValue!;
                      }
                    });
                  },
                );
              }).toList(),
            ),
          ),
        ),
        Visibility(
          visible: !_noneSelectedForDislikes && _showOtherDislikeTextField,
          child: Column(
            children: [
              TextFormField(
                key: const Key('otherDislikeField'),
                decoration: const InputDecoration(labelText: 'Specify other dislikes'),
                onChanged: (value) {
                  setState(() {
                    _otherDislike = value;
                  });
                },
              ),
              SizedBox(height: 8),
            ],
          ),
        ),
      ],
    );
  }




  //---------------------------[WIDGET]:CONSENT SECTION------------------------


  Widget _buildConsentSection() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10), // Adjust padding as needed
      child: SwitchListTile(
        key: Key('consentSwitch'),
        title: Text(
          "I consent to the collection and use of my dietary preference information for meal planning purposes.",
          style: TextStyle(
            color: Colors.grey.shade600,
            fontSize: 12, // Adjust font size as needed
          ),
        ),
        value: _consent,
        onChanged: (bool value) {
          setState(() => _consent = value);
        },
        activeColor: Colors.teal, // Color when the switch is ON
        inactiveThumbColor: Colors.grey.shade400, // Color when the switch is OFF
        inactiveTrackColor: Colors.grey.shade300, // Track color when the switch is OFF
      ),
    );
  }




//---------------------------[WIDGET]:SUBMIT BUTTON--------------------------


  Widget _buildSubmitButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Center(
        child: Tooltip(
          message: !_consent ? 'Please accept the terms and conditions to proceed' : '',
          child: AnimatedContainer(
            duration: Duration(milliseconds: 500), // Duration of the color transition
            width: 220, // Increase the button width to avoid cutting out text
            height: 60, // Increase the button height for a larger tap target
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30), // Rounded corners
              color: _consent ? Colors.black : Colors.grey.shade200, // Dynamic background color based on `_consent`
            ),
            child: ElevatedButton(
              key: Key('submitButton'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent, // Make the button itself transparent to show the AnimatedContainer color
                disabledForegroundColor: Colors.grey.shade200.withOpacity(0.38),
                disabledBackgroundColor: Colors.grey.shade200.withOpacity(0.12), // Color when the button is disabled
                shadowColor: Colors.transparent, // No shadow
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30), // Match the border radius of the AnimatedContainer
                ),
                padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 40.0), // Adjust padding to ensure text fits well
              ),
              onPressed: () {
                if (_consent) {
                  _submitForm();
                } else {
                  // Show a Snackbar if the consent is not given when the button is clicked
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Please accept the terms and conditions to proceed')),
                  );
                }
              },
              child: Text(
                'Save Preferences',
                style: TextStyle(color: _consent ? Colors.white : Colors.grey.shade600, fontSize: 16), // Dynamic text color and size
              ),
            ),
          ),
        ),
      ),
    );
  }



  //----------------------[FUNCTION]:SUBMIT FORM-----------------------------


  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      if (_consent) {
        _formKey.currentState!.save(); // Save the form state if you're using FormFields with onSaved properties.

        User? user = FirebaseAuth.instance.currentUser; // Get the currently logged-in user.

        if (user != null && user.email != null) {
          // Prepare the DietaryPreferences object
          DietaryPreferences form = DietaryPreferences(
            dietaryRestriction: _selectedDietaryRestriction,
            dietaryLaw: _dietaryLaws,
            allergies: _allergies,
            preferences: _preferences,
            dislikes: _dislikes,
            consent: _consent,
          );

          try {
            Map<String, dynamic> formData = form.toJson();
            // Check if the user's dietary preferences document already exists
            DocumentSnapshot userPreferences = await FirebaseFirestore.instance
                .collection('users')
                .doc(user.email)
                .collection('forms')
                .doc('dietaryPreferencesForm')
                .get();

            if (userPreferences.exists) {
              // Update the existing document
              await FirebaseFirestore.instance
                  .collection('users')
                  .doc(user.email)
                  .collection('forms')
                  .doc('dietaryPreferencesForm')
                  .update(formData);
            } else {
              // Create a new document if it doesn't exist
              await FirebaseFirestore.instance
                  .collection('users')
                  .doc(user.email)
                  .collection('forms')
                  .doc('dietaryPreferencesForm')
                  .set(formData);
            }

            // Show success message or navigate
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Success'),
                  content: Text('Your preferences have been successfully saved.'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(); // Close the dialog
                        Get.offAll(() => Dashboard()); // Navigate to the Dashboard
                      }, // Close the dialog
                      child: Text('OK'),
                    ),
                  ],
                );
              },
            );
          } catch (e) {
            // Handle errors if Firestore submission fails
            print(e); // For debugging, print the error
            // Show an error dialog or handle the error appropriately
          }
        }
      } else {
        // Show a dialog asking the user to accept the terms and conditions
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Consent Required'),
              content: Text('Please accept the terms and conditions to proceed.'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(), // Close the dialog
                  child: Text('Understood'),
                ),
              ],
            );
          },
        );
      }
    }
  }







}
