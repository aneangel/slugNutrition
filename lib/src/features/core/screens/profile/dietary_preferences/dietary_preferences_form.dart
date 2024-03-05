
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
    children.add(Padding(
      padding: const EdgeInsets.only(bottom: 8.0), // Add some space below the hint
      child: Text(
        "Choose items that you are allergic to: ",
        style: TextStyle(color: Colors.grey), // Make the hint text grey
      ),
    )); // Start the children list with the hint.

    _allergies.entries.forEach((entry) {
      children.add(CheckboxListTile(
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
      ));
    });

    if (_showOtherAllergyTextField) {
      children.add(TextFormField(
        key: const Key('otherAllergyField'),
        decoration: const InputDecoration(labelText: 'Specify other allergies'),
        onChanged: (value) {
          setState(() {
            _otherAllergy = value;
          });
        },
      ));
      children.add(SizedBox(height: 8));
    }

    return _buildSectionCard(title: 'Common Allergies / Intolerances', children: children);
  }





//---------------------[WIDGET]:RELIGIOUS/CULTURAL LAWS-----------------------


  Widget _buildReligiousCulturalSection() {
    List<String> dietaryLawsOptions = ['None', 'Halal', 'Kosher'];
    String? _selectedDietaryLaw; // Ensure this is null initially

    return _buildSectionCard(
      title: 'Religious or Cultural Dietary Laws',
      children: [
        SizedBox(height: 2),
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
      ],
    );
  }


//-----------------------[WIDGET]:ADDITIONAL PREFERENCES----------------------


  Widget _buildAdditionalPreferencesSection() {
    List<Widget> children = [];

    // Add a subheading under the main title
    children.add(Padding(
      padding: const EdgeInsets.only(bottom: 8.0), // Add some space below the subheading
      child: Text(
        "Indicate any additional preferences:",
        style: TextStyle(color: Colors.grey), // Customizing text color and possibly style
      ),
    ));

    // Generate CheckboxListTile for each preference
    _preferences.keys.forEach((key) {
      children.add(CheckboxListTile(
        title: Text(key),
        value: _preferences[key],
        onChanged: (bool? value) {
          setState(() {
            _preferences[key] = value!;
          });
        },
        //controlAffinity: ListTileControlAffinity.leading, // Uncomment if you want the checkbox on the left side.
      ));
    });

    // No need for the "Other" option handling here since it's removed from the map.

    return _buildSectionCard(title: 'Additional Preferences', children: children);
  }






  //--------------------[WIDGET]:FOOD DISLIKES---------------------------


  Widget _buildFoodDislikesSection() {
    List<Widget> children = [];

    // Add a hint under the heading
    children.add(Padding(
      padding: const EdgeInsets.only(bottom: 8.0), // Add some space below the hint
      child: Text(
        "Choose items that you would like to avoid:",
        style: TextStyle(color: Colors.grey), // Make the hint text grey
      ),
    ));

    // Generate CheckboxListTile for each dislike
    _dislikes.entries.forEach((entry) {
      children.add(CheckboxListTile(
        title: Text(entry.key),
        value: entry.value,
        onChanged: (bool? newValue) {
          setState(() {
            _dislikes[entry.key] = newValue!;
            if (entry.key == 'Other') {
              _showOtherDislikeTextField = newValue;
            }
          });
        },
      ));
    });

    // Add TextFormField for "Other" if it's selected
    if (_showOtherDislikeTextField) {
      children.add(TextFormField(
        key: const Key('otherDislikeField'),
        decoration: const InputDecoration(labelText: 'Specify other dislikes'),
        onChanged: (value) => setState(() => _otherDislike = value),
      ));
      children.add(SizedBox(height: 8,));
    }

    return _buildSectionCard(title: 'Food Dislikes', children: children);
  }



  //---------------------------[WIDGET]:CONSENT SECTION------------------------


  Widget _buildConsentSection() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10), // Adjust padding as needed
      child: SwitchListTile(
        title: Text(
          "I consent to the collection and use of my dietary preference information for meal planning purposes.",
          style: TextStyle(
            color: Colors.grey.shade700,
            fontSize: 11, // Adjust font size as needed
          ),
        ),
        value: _consent,
        onChanged: (bool value) {
          setState(() => _consent = value);
        },
        activeColor: Colors.green, // Color when the switch is ON
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


  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      if (_consent) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Preferences saved')),
        );
      } else {
        // Show a more specific message when consent is not given
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please accept the terms and conditions to proceed')),
        );
      }
    }
  }
}
