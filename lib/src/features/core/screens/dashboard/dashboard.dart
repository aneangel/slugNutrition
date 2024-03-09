import 'package:flutter/material.dart';
import 'package:slugnutrition/src/features/core/screens/profile/dietary_preferences/dietary_preferences_form.dart';
import '/src/constants/image_strings.dart';
import '/src/constants/sizes.dart';
import '/src/constants/text_strings.dart';
import '/src/features/core/screens/dashboard/widgets/appbar.dart';
import '/src/features/core/screens/dashboard/widgets/diningHallGrid.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '/src/features/core/screens/dashboard/widgets/banners.dart';
import '/src/features/core/screens/dashboard/widgets/categories.dart';
import '/src/features/core/screens/dashboard/widgets/search.dart';
import '/src/features/core/screens/dashboard/widgets/top_courses.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({Key? key}) : super(key: key);

  String getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good Morning';
    } else if (hour < 16) {
      return 'Good Afternoon';
    } else {
      return 'Good Evening';
    }
  }

  String capitalize(String s) => s[0].toUpperCase() + s.substring(1);

  Future<String> getUserName() async {
    User? user = FirebaseAuth.instance.currentUser;
    String userName = "user"; // Default fallback name
    if (user != null) {
      try {
        DocumentSnapshot bmiForm = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.email)
            .collection('forms')
            .doc('bmiForm')
            .get();

        if (bmiForm.exists) {
          Map<String, dynamic>? data = bmiForm.data() as Map<String, dynamic>?;
          if (data != null && data.containsKey('name')) {
            userName = capitalize(data['name']);
          }
        }
      } catch (e) {
        print("Error fetching user name: $e");
      }
    }
    return userName;
  }

  @override
  Widget build(BuildContext context) {
    final txtTheme = Theme.of(context).textTheme;
    final isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;
    //Dark mode
    // Example dining hall data - ideally, this would come from a model or service
    final List<Map<String, String>> diningHalls = [
      {
        'name': ' Oakes \n Rachel-Carson',
        'image': 'assets/images/dashboard/oc.png',
        // Replace with your actual image paths
      },
      {
        'name': ' Porter \n Kresge',
        'image': 'assets/images/dashboard/pk.png',
      },
      {
        'name': ' College 9\n John R Lewis',
        'image': 'assets/images/dashboard/cj.png',
      },
      {
        'name': ' Cowell \n Stevenson',
        'image': 'assets/images/dashboard/cs.png',
      },
      {
        'name': ' Crown \n Merrill',
        'image': 'assets/images/dashboard/cm.png',
      },
      {
        'name': ' Cafés',
        'image': 'assets/images/dashboard/cafe.png',
      },
    ];

    return SafeArea(
      child: Scaffold(
        appBar: DashboardAppBar(isDark: isDark),
        body: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Text(tDashboardTitle, style: txtTheme.bodyMedium),
              Text.rich(
                TextSpan(
                  children: <InlineSpan>[
                    WidgetSpan(
                      child: FutureBuilder<String>(
                        future: getUserName(),
                        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                          String displayName = snapshot.hasData ? snapshot.data! : "User";
                          return Text(
                            '${getGreeting()}, $displayName!',
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.normal,
                              color: Colors.black,
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Text(tDashboardHeading, style: txtTheme.displayMedium),
              const SizedBox(height: tDashboardPadding),

              // Wrapped GridView.builder in an Expanded widget
              DiningHallGrid(diningHalls: diningHalls)
            ],
          ),
        ),
      ),
    );
  }
}
