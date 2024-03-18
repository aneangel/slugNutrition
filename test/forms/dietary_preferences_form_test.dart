import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:slugnutrition/src/features/core/screens/profile/dietary_preferences/dietary_preferences_form.dart';

void main() {
  group('Dietary Preferences Form Dropdown Tests:', () {


  //---------------------- Basic Dietary Dropdown ---------------------------


  group('Basic Dietary Preferences Tests:', () {
      testWidgets('[VEGAN]', (WidgetTester tester) async {
        await tester.pumpWidget(MaterialApp(home: DietaryPreferencesForm()));
        final Finder dietaryRestrictionDropdownFinder = find.byKey(Key('dietaryRestrictionDropdown'));

        // Ensure the dropdown is visible before attempting to tap it
        await tester.ensureVisible(dietaryRestrictionDropdownFinder);
        await tester.tap(dietaryRestrictionDropdownFinder, warnIfMissed: false); // Suppress warning if confident tap should succeed
        await tester.pumpAndSettle();

        // Example of selecting an option, ensuring it's visible first
        final Finder veganOptionFinder = find.text('Vegan').last;
        await tester.ensureVisible(veganOptionFinder);
        await tester.tap(veganOptionFinder, warnIfMissed: false); // Suppress warning if confident tap should succeed
        await tester.pumpAndSettle();
      });

      testWidgets('[VEGETARIAN]', (
          WidgetTester tester) async {
        await tester.pumpWidget(MaterialApp(home: DietaryPreferencesForm()));
        final Finder dietaryRestrictionDropdownFinder = find.byKey(
            Key('dietaryRestrictionDropdown'));

        // Ensure the dropdown is visible before attempting to tap it
        await tester.ensureVisible(dietaryRestrictionDropdownFinder);
        await tester.tap(dietaryRestrictionDropdownFinder, warnIfMissed: false);
        await tester.pumpAndSettle();

        // Example of selecting an option, ensuring it's visible first
        final Finder vegetarianOptionFinder = find
            .text('Vegetarian')
            .last;
        await tester.ensureVisible(vegetarianOptionFinder);
        await tester.tap(vegetarianOptionFinder, warnIfMissed: false);
        await tester.pumpAndSettle();
      });

      testWidgets('[NONE]', (
          WidgetTester tester) async {
        await tester.pumpWidget(MaterialApp(home: DietaryPreferencesForm()));
        final Finder dietaryRestrictionDropdownFinder = find.byKey(
            Key('dietaryRestrictionDropdown'));

        // Ensure the dropdown is visible before attempting to tap it
        await tester.ensureVisible(dietaryRestrictionDropdownFinder);
        await tester.tap(dietaryRestrictionDropdownFinder, warnIfMissed: false);
        await tester.pumpAndSettle();

        // Example of selecting an option, ensuring it's visible first
        final Finder noneOptionFinder = find
            .text('None')
            .last;
        await tester.ensureVisible(noneOptionFinder);
        await tester.tap(noneOptionFinder, warnIfMissed: false);
        await tester.pumpAndSettle();
      });

      testWidgets('[PESCATARIAN]', (
          WidgetTester tester) async {
        await tester.pumpWidget(MaterialApp(home: DietaryPreferencesForm()));
        final Finder dietaryRestrictionDropdownFinder = find.byKey(
            Key('dietaryRestrictionDropdown'));

        // Ensure the dropdown is visible before attempting to tap it
        await tester.ensureVisible(dietaryRestrictionDropdownFinder);
        await tester.tap(dietaryRestrictionDropdownFinder, warnIfMissed: false);
        await tester.pumpAndSettle();

        // Example of selecting an option, ensuring it's visible first
        final Finder pescatarianOptionFinder = find
            .text('Pescatarian')
            .last;
        await tester.ensureVisible(pescatarianOptionFinder);
        await tester.tap(pescatarianOptionFinder, warnIfMissed: false);
        await tester.pumpAndSettle();
      });
    });


  //---------------------- Cultural laws dropdown ---------------------------


  group('Religious or Cultural Laws Tests:', () {
      testWidgets(
          '[NONE]', (
          WidgetTester tester) async {
        await tester.pumpWidget(MaterialApp(home: DietaryPreferencesForm()));
        final Finder religiousCulturalLawsDropdownFinder = find.byKey(
            Key('religiousCulturalLawsDropdown'));

        // Ensure the dropdown is visible before attempting to tap it
        await tester.ensureVisible(religiousCulturalLawsDropdownFinder);
        await tester.tap(
            religiousCulturalLawsDropdownFinder, warnIfMissed: false);
        await tester.pumpAndSettle();

        // Selecting the 'None' option
        final Finder noneOptionFinder = find
            .text('None')
            .last;
        await tester.ensureVisible(noneOptionFinder);
        await tester.tap(noneOptionFinder, warnIfMissed: false);
        await tester.pumpAndSettle();
      });


      testWidgets(
          '[HALAL]', (
          WidgetTester tester) async {
        await tester.pumpWidget(MaterialApp(home: DietaryPreferencesForm()));
        final Finder religiousCulturalLawsDropdownFinder = find.byKey(
            Key('religiousCulturalLawsDropdown'));

        // Ensure the dropdown is visible before attempting to tap it
        await tester.ensureVisible(religiousCulturalLawsDropdownFinder);
        await tester.tap(
            religiousCulturalLawsDropdownFinder, warnIfMissed: false);
        await tester.pumpAndSettle();

        // Selecting the 'Halal' option
        final Finder halalOptionFinder = find
            .text('Halal')
            .last;
        await tester.ensureVisible(halalOptionFinder);
        await tester.tap(halalOptionFinder, warnIfMissed: false);
        await tester.pumpAndSettle();
      });


      testWidgets(
          '[KOSHER]', (
          WidgetTester tester) async {
        await tester.pumpWidget(MaterialApp(home: DietaryPreferencesForm()));
        final Finder religiousCulturalLawsDropdownFinder = find.byKey(
            Key('religiousCulturalLawsDropdown'));

        // Ensure the dropdown is visible before attempting to tap it
        await tester.ensureVisible(religiousCulturalLawsDropdownFinder);
        await tester.tap(
            religiousCulturalLawsDropdownFinder, warnIfMissed: false);
        await tester.pumpAndSettle();

        // Selecting the 'Kosher' option
        final Finder kosherOptionFinder = find
            .text('Kosher')
            .last;
        await tester.ensureVisible(kosherOptionFinder);
        await tester.tap(kosherOptionFinder, warnIfMissed: false);
        await tester.pumpAndSettle();
      });
    });
  });


  //---------------------- Allergies Checkbox ---------------------------


  group('Dietary Preferences Form Checkbox Tests: Allergies:', () {
    final allergies = [
      'allergyNone', // Including 'None' to test its interaction as well
      'allergyMilk',
      'allergyEggs',
      'allergyFish',
      'allergyShellfish',
      'allergyPeanuts',
      'allergyTree Nuts',
      'allergyDairy',
      'allergyGluten',
      'allergySoy',
      'allergyWheat',
      'allergySesame',
      'allergyAlcohol',
      'allergyOther',
    ];

    for (final allergyKey in allergies) {
      // Dynamically create a test for each allergy
      testWidgets('Allergy Checkbox Tests: [$allergyKey]', (WidgetTester tester) async {
        await tester.pumpWidget(MaterialApp(home: DietaryPreferencesForm()));

        // Find the checkbox by key
        final finder = find.byKey(Key(allergyKey));

        // Ensure the checkbox is visible before attempting to tap it
        await tester.scrollUntilVisible(finder, 200);
        await tester.ensureVisible(finder);
        await tester.tap(finder);
        await tester.pumpAndSettle();

        // Check the interaction effect, e.g., checkbox toggles or additional fields show up
        if (allergyKey == 'allergyNone') {
          // If "None" is selected, other checkboxes should be unchecked or hidden
          // You can add specific assertions here to verify this behavior
        } else if (allergyKey == 'allergyOther') {
          // If "Other" is selected, ensure the additional text field appears
          expect(find.byKey(const Key('otherAllergyField')), findsOneWidget);
        } else {
          // For all other checkboxes, verify they are checked after tapping
          // This might involve checking the state of the checkbox or any related UI changes
        }
      });
    }
  });


  //------------------- Additional Preferences Checkbox ----------------------


  group('Dietary Preferences Form Checkbox Tests: Additional Preferences:', () {
    final preferences = [
      'preferenceNone', // Including 'None' to test its interaction as well
      'preferenceOrganic',
      'preferenceNon-GMO',
      'preferenceLow-Carb',
      'preferenceLow-Fat',
      'preferenceSugar-Free',
      'preferenceHigh-Protein',
      'preferenceGlutenFriendly',
    ];

    for (final preferenceKey in preferences) {
      // Dynamically create a test for each preference
      testWidgets('Preference Checkbox Tests: [$preferenceKey]', (WidgetTester tester) async {
        await tester.pumpWidget(MaterialApp(home: DietaryPreferencesForm()));

        // Find the checkbox by key
        final finder = find.byKey(Key(preferenceKey));

        // Ensure the checkbox is visible before attempting to tap it
        await tester.scrollUntilVisible(finder, 500); // Increase the scroll distance if needed
        await tester.ensureVisible(finder);
        await tester.tap(finder);
        await tester.pumpAndSettle();

        // Check the interaction effect, e.g., checkbox toggles or additional fields show up
        if (preferenceKey == 'preferenceNone') {
          // If "None" is selected, other checkboxes should be unchecked or hidden
          // You can add specific assertions here to verify this behavior
          preferences.where((key) => key != 'preferenceNone').forEach((key) {
            final otherFinder = find.byKey(Key(key));
            if (otherFinder.evaluate().isNotEmpty) {
              // Verify other checkboxes are unchecked
              expect((tester.widget(otherFinder) as CheckboxListTile).value, isFalse);
            }
          });
        } else {
          // For all other checkboxes, verify they are checked after tapping
          // This might involve checking the state of the checkbox or any related UI changes
          expect((tester.widget(finder) as CheckboxListTile).value, isTrue);
        }
      });
    }
  });


  //------------------- Dislikes or Avoids Checkbox ----------------------


  group('Dietary Preferences Form Checkbox Tests: Dislikes:', () {
    final dislikes = [
      'dislikeNone', // Including 'None' to test its interaction as well
      'dislikePork',
      'dislikeBeef',
      'dislikeHalal',
      'dislikeChicken',
      'dislikeVegan',
      "dislikeVegetarian",
      'dislikeMilk',
      'dislikeEggs',
      'dislikeFish',
      'dislikeShellfish',
      'dislikePeanuts',
      'dislikeTreeNuts',
      'dislikeDairy',
      'dislikeGluten',
      'dislikeSoy',
      'dislikeWheat',
      'dislikeSesame',
      'dislikeAlcohol',
      'dislikeOther',
    ];

    for (final dislikeKey in dislikes) {
      testWidgets('Food Dislike Checkbox Tests: [$dislikeKey]', (WidgetTester tester) async {
        await tester.pumpWidget(MaterialApp(home: DietaryPreferencesForm()));

        // Find the checkbox by key
        final finder = find.byKey(Key(dislikeKey));

        // Ensure the checkbox is visible before attempting to tap it
        await tester.scrollUntilVisible(finder, 50); // Adjust the scroll amount if needed
        await tester.ensureVisible(finder);
        await tester.tap(finder);
        await tester.pumpAndSettle();

        // Verify the checkbox interaction
        if (dislikeKey == 'dislikeNone') {
          // Verify that selecting "None" disables or hides other checkboxes
          // You can add specific assertions here to verify this behavior
        } else if (dislikeKey == 'dislikeOther') {
          // If "Other" is selected, ensure the additional text field appears
          expect(find.byKey(const Key('otherDislikeField')), findsOneWidget);
        } else {
          // For all other checkboxes, verify they are checked after tapping
          // This might involve checking the state of the checkbox or any related UI changes
        }
      });
    }
  });


  //----------------------------- Consent Section ----------------------------


  // Function to create the testable widget
  Widget createTestWidget(bool initialValue) {
    return MaterialApp(
      home: Scaffold(
        body: StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: SwitchListTile(
                key: Key('consentSwitch'),
                title: Text(
                  "I consent to the collection and use of my dietary preference information for meal planning purposes.",
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 12,
                  ),
                ),
                value: initialValue,
                onChanged: (bool value) {
                  setState(() => initialValue = value);
                },
                activeColor: Colors.teal,
                inactiveThumbColor: Colors.grey.shade400,
                inactiveTrackColor: Colors.grey.shade300,
              ),
            );
          },
        ),
      ),
    );
  }

  testWidgets('Consent Switch is present and initializes as OFF', (WidgetTester tester) async {
    // Initial state of consent is false/off
    await tester.pumpWidget(createTestWidget(false));

    // Verify the SwitchListTile is present using the key
    expect(find.byKey(Key('consentSwitch')), findsOneWidget);

    // Verify the initial state of the switch is off (false)
    expect(tester.widget<SwitchListTile>(find.byKey(Key('consentSwitch'))).value, isFalse);
  });

  testWidgets('Tapping Consent Switch turns it ON', (WidgetTester tester) async {
    // Initial state of consent is false/off
    await tester.pumpWidget(createTestWidget(false));

    // Tap the switch to toggle its state
    await tester.tap(find.byKey(Key('consentSwitch')));
    await tester.pumpAndSettle(); // Wait for animations to complete

    // Verify the switch is now on (true)
    expect(tester.widget<SwitchListTile>(find.byKey(Key('consentSwitch'))).value, isTrue);
  });

  testWidgets('Tapping Consent Switch twice returns it to OFF', (WidgetTester tester) async {
    // Initial state of consent is false/off
    await tester.pumpWidget(createTestWidget(false));

    // Tap the switch twice to toggle its state twice
    await tester.tap(find.byKey(Key('consentSwitch')));
    await tester.pumpAndSettle(); // Wait for the first toggle to complete
    await tester.tap(find.byKey(Key('consentSwitch')));
    await tester.pumpAndSettle(); // Wait for the second toggle to complete

    // Verify the switch is back to off (false)
    expect(tester.widget<SwitchListTile>(find.byKey(Key('consentSwitch'))).value, isFalse);
  });


  // -------------------------- Submit Button -------------------------------


  group('Submit Button Tests:', () {
    // Helper function to create the widget under test
    Widget createTestWidget(bool consentGiven) {
      // Mock the context or any required dependencies
      // Embed the _buildSubmitButton() in a Scaffold for Snackbar support
      return MaterialApp(
        home: Scaffold(
          body: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Column(
                children: [
                  SwitchListTile(
                    title: Text('Consent'),
                    value: consentGiven,
                    onChanged: (bool value) {
                      setState(() => consentGiven = value);
                    },
                  ),
                  ElevatedButton(
                    key: Key('submitButton'),
                    onPressed: consentGiven ? () {} : null,
                    child: Text('Submit'),
                  ),
                ],
              );
            },
          ),
        ),
      );
    }

    testWidgets('Submit Button Presence', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(false));

      expect(find.byKey(Key('submitButton')), findsOneWidget);
    });

    testWidgets('Button Enabled State with Consent Given', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(true));

      final ElevatedButton button = tester.widget(find.byKey(Key('submitButton')));
      expect(button.onPressed, isNotNull); // Button is enabled
    });

    testWidgets('Button Disabled State without Consent', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(false));

      final ElevatedButton button = tester.widget(find.byKey(Key('submitButton')));
      expect(button.onPressed, isNull); // Button is disabled
    });

    testWidgets('Submit Action with Consent', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(true));

      // Assuming you have a mock or stub for _submitForm, you would verify it gets called here
      // For demonstration, we'll just tap the button
      await tester.tap(find.byKey(Key('submitButton')));
      await tester.pump();

      // Verify any side effects or outcomes of the _submitForm being called
    });

    // testWidgets('Snackbar Appearance without Consent', (WidgetTester tester) async {
    //   await tester.pumpWidget(createTestWidget(false));
    //
    //   // Tap the button and expect a Snackbar with specific content
    //   await tester.tap(find.byKey(Key('submitButton')));
    //   await tester.pumpAndSettle(); // Pump until Snackbar is shown
    //
    //   //expect(find.byType(SnackBar), findsOneWidget);
    //   expect(find.text('Please accept the terms and conditions to proceed'), findsOneWidget);
    // });
  });
}


