
//##################-----DIETARY-PREFERENCES-FORM------##################

import 'package:flutter/material.dart';
import 'package:slugnutrition/src/constants/sizes.dart';


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
    'Peanuts': false,
    'Tree Nuts': false,
    'Dairy': false,
    'Eggs': false,
    'Gluten': false,
    'Shellfish': false,
    'Soy': false,
    'Other': false,
  };

  // Additional Preferences
  final Map<String, bool> _preferences = {
    'Organic': false,
    'Non-GMO': false,
    'Low-Carb': false,
    'Low-Fat': false,
    'Sugar-Free': false,
    'High-Protein': false,
    'Other': false,
  };

  bool _showOtherAllergyTextField = false;
  String _otherAllergy = '';
  String _dietaryLaws = 'None';
  bool _showOtherDietaryLawsTextField = false;
  bool _showOtherAdditionalPreferencesTextField = false;
  String _otherDietaryLaw = '';
  double _organicPreference = 0;
  String _foodDislikes = '';
  bool _consent = false;

  get children => null;


  //------------------------------[WIDGET]:MAIN---------------------------------


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dietary Preferences'),
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
    String? _selectedDietaryRestriction; // Ensure this is null initially

    return _buildSectionCard(
      title: 'Basic Dietary Preferences',
      children: [
        SizedBox(height: 8),
        DropdownButtonFormField<String>(
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
              _selectedDietaryRestriction = newValue;
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
    List<Widget> children = [];
    _allergies.entries.forEach((entry) {
      children.add(
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 8), // Space before the dropdown
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: entry.key, // This will be shown as a floating label
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
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                ),
                // The value is always null so the hint is displayed
                value: null,
                hint: Text(
                  entry.key,
                  style: TextStyle(
                    color: Colors.grey.shade500, // Lighter text color
                    fontWeight: FontWeight.w300, // Thinner font weight
                  ),
                ),
                onChanged: (String? newValue) {
                  setState(() {
                    _allergies[entry.key] = newValue == "Yes";
                    if (entry.key == 'Other') {
                      _showOtherAllergyTextField = newValue == "Yes";
                    }
                  });
                },
                items: ['Yes', 'No'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              SizedBox(height: 8), // Space after the dropdown
            ],
          )
      );
    });

    if (_showOtherAllergyTextField) {
      children.add(
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 2), // Space before the "Other" text field
            TextFormField(
              key: const Key('otherAllergyField'),
              decoration: const InputDecoration(labelText: 'Specify other allergies'),
              onChanged: (value) => setState(() => _otherAllergy = value),
            ),
            SizedBox(height: 8), // Space after the "Other" text field
          ],
        ),
      );
    }

    return _buildSectionCard(title: 'Common Allergies and Intolerances', children: children);
  }


//---------------------[WIDGET]:RELIGIOUS/CULTURAL LAWS-----------------------


  Widget _buildReligiousCulturalSection() {
    List<String> dietaryLawsOptions = ['None', 'Halal', 'Kosher', 'Other'];
    String? _selectedDietaryLaw; // Ensure this is null initially

    return _buildSectionCard(
      title: 'Religious or Cultural Dietary Laws',
      children: [
        SizedBox(height: 8),
        DropdownButtonFormField<String>(
          decoration: InputDecoration(
            // Use labelText for the floating label that appears when the dropdown is interacted with
            labelText: _selectedDietaryLaw ?? 'Select your dietary law',
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
          value: _selectedDietaryLaw,
          hint: Text(
            'Select your dietary law', // This will be shown as a hint in the dropdown button when no item is selected
            style: TextStyle(color: Colors.grey.shade500, fontWeight: FontWeight.w300), // Lighter, thinner font for the hint
          ),
          onChanged: (String? newValue) {
            setState(() {
              _selectedDietaryLaw = newValue;
              _showOtherDietaryLawsTextField = newValue == 'Other';
            });
          },
          items: dietaryLawsOptions.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
        SizedBox(height: 8),
        if (_showOtherDietaryLawsTextField)
          Column(
            children: [
              SizedBox(height: 4), // Add gap before the text field
              TextFormField(
                key: const Key('otherDietaryLawField'),
                decoration: const InputDecoration(labelText: 'Please specify'),
                onChanged: (value) => _otherDietaryLaw = value,
              ),
              SizedBox(height: 8), // Space after the text field
            ],
          ),
      ],
    );
  }


//-----------------------[WIDGET]:ADDITIONAL PREFERENCES----------------------


  Widget _buildAdditionalPreferencesSection() {
    List<Widget> children = _preferences.keys.map((String key) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 8), // Space before the dropdown
          DropdownButtonFormField<String>(
            decoration: InputDecoration(
              labelText: key,
              contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(15.0)),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15.0), borderSide: BorderSide(color: Colors.grey.shade400)),
              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15.0), borderSide: BorderSide(color: Colors.purple)),
              floatingLabelStyle: TextStyle(color: Colors.purple),
              floatingLabelBehavior: FloatingLabelBehavior.always, // Ensures the label always floats
            ),
            value: null, // The value is always null so the hint is displayed
            hint: Text(key, style: TextStyle(color: Colors.grey.shade500, fontWeight: FontWeight.w300)), // Style for the hint
            onChanged: (String? newValue) {
              setState(() {
                _preferences[key] = newValue == "Yes";
                if (key == "Other") {
                  _showOtherAdditionalPreferencesTextField = newValue == "Yes";
                }
              });
            },
            items: ['Yes', 'No'].map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
          SizedBox(height: 8), // Space after the dropdown
        ],
      );
    }).toList();

    // Check if the text field for "Other" preferences needs to be shown
    if (_showOtherAdditionalPreferencesTextField) {
      // Add a Column widget to wrap the TextFormField
      children.add(
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              key: Key('otherPreferencesField'),
              decoration: InputDecoration(labelText: 'Specify other preferences'),
              onChanged: (value) {
                // Update your state to reflect the change
              },
            ),
            SizedBox(height: 8), // Space after the text field
          ],
        ),
      );
    }

    return _buildSectionCard(title: 'Additional Preferences', children: children);
  }


  //--------------------[WIDGET]:FOOD DISLIKES---------------------------


  Widget _buildFoodDislikesSection() {
    return _buildSectionCard(
      title: 'Food Dislikes',
      children: [
        TextFormField(
          decoration: const InputDecoration(labelText: 'Foods you dislike or avoid'),
          onChanged: (value) => setState(() => _foodDislikes = value),
        ),
      ],
    );
  }


  //---------------------------[WIDGET]:CONSENT SECTION------------------------


  Widget _buildConsentSection() {
    return SwitchListTile(
      title: const Text("I consent to the collection and use of my dietary preference information for meal planning purposes."),
      value: _consent,
      onChanged: (bool value) => setState(() => _consent = value),
    );
  }


//---------------------------[WIDGET]:SUBMIT BUTTON--------------------------


  Widget _buildSubmitButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Center(
        child: ElevatedButton(
          onPressed: _submitForm,
          child: const Text('Save Preferences'),
        ),
      ),
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      if (_consent) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Preferences saved')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please agree to the consent to proceed')),
        );
      }
    }
  }
}
