import 'package:flutter/material.dart';
import 'package:slugnutrition/src/features/core/screens/profile/dietary_preferences/dietary_preferences_form.dart';
import '/src/constants/image_strings.dart';
import '/src/constants/sizes.dart';
import '/src/constants/text_strings.dart';
import '/src/features/core/screens/dashboard/widgets/appbar.dart';
import '/src/features/core/screens/dashboard/widgets/diningHallGrid.dart';
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
              Text('${getGreeting()}, User!',
                  style: TextStyle(
                    fontSize: 16.0, // Example font size, adjust as needed
                    fontWeight: FontWeight.normal, // Ensures text is not bold
                    color: Colors.black, // Example text color, adjust as needed
                  )),
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
