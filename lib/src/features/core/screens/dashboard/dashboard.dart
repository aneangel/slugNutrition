import 'package:flutter/material.dart';
import '/src/constants/image_strings.dart';
import '/src/constants/sizes.dart';
import '/src/constants/text_strings.dart';
import '/src/features/core/screens/dashboard/widgets/appbar.dart';
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
              GridView.builder(
                padding: const EdgeInsets.all(8), // Padding inside the GridView
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // Number of columns
                  crossAxisSpacing: 20, // Horizontal space between tiles
                  mainAxisSpacing: 20, // Vertical space between tiles
                  childAspectRatio: 1, // Aspect ratio of the tiles
                ),
                itemCount: diningHalls.length,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return Card(
                    color: Color(0xFFF5F5F7), // Very light gray with a slight blue undertone
                    elevation: 10,
                    shadowColor: Color.fromRGBO(0, 51, 102, 0.2), // Soft shadow with a hint of blue
                    clipBehavior: Clip.antiAlias,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Stack(
                      children: <Widget>[
                        Align(
                          alignment: Alignment.topRight, // Align the image to the top right corner
                          child: Container(
                            width: 70, // Adjust the size as needed
                            height: 70, // Adjust the size as needed
                            child: Image.asset(
                              diningHalls[index]['image']!,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Positioned(
                          left: 8,
                          bottom: 8,
                          child: Text(
                            diningHalls[index]['name']!,
                            style: TextStyle(
                              color: Color(0xFF003366), // Navy blue for text
                              fontWeight: FontWeight.bold, // Make the text bold
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// class Dashboard extends StatelessWidget {
//   const Dashboard({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     //Variables
//     final txtTheme = Theme.of(context).textTheme;
//     final isDark = MediaQuery.of(context).platformBrightness == Brightness.dark; //Dark mode

//     final List<Map<String, String>> diningHalls = [
//       {
//         'name': 'Oakes & Rachel-Carson',
//         'image': 'assets/dining_hall_1.jpg', // Replace with your actual image paths
//       },
//       {
//         'name': 'Porter & Kresge',
//         'image': 'assets/dining_hall_2.jpg',
//       },
//       {
//         'name': 'College 9 & John R Lewis',
//         'image': 'assets/dining_hall_3.jpg',
//       },
//       {
//         'name': 'Crown & Merill',
//         'image': 'assets/dining_hall_4.jpg',
//       },
//       {
//         'name': 'Cowell & Stevenson',
//         'image': 'assets/dining_hall_5.jpg',
//       },
//       {
//         'name': 'Cafes',
//         'image': 'assets/Cafe.png',
//       },
//     ];

//     return SafeArea(
//       child: Scaffold(
//         appBar: AppBar(
//           title: Text('Dining Hall'),
//         ),
//         /// Create a new Header

//         body: SingleChildScrollView(
//           child: Container(
//             padding: const EdgeInsets.all(tDashboardPadding),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [

//                 // New code

//                 // Old code
//                 //Heading
//                 Text(tDashboardTitle, style: txtTheme.bodyMedium),
//                 Text(tDashboardHeading, style: txtTheme.displayMedium),
//                 const SizedBox(height: tDashboardPadding),

//                 //Search Box
//                 DashboardSearchBox(txtTheme: txtTheme),
//                 const SizedBox(height: tDashboardPadding),

//                 //Categories
//                 DashboardCategories(txtTheme: txtTheme),
//                 const SizedBox(height: tDashboardPadding),

//                 //Banners
//                 DashboardBanners(txtTheme: txtTheme, isDark: isDark),
//                 const SizedBox(height: tDashboardPadding),

//                 //Top Course
//                 Text(tDashboardTopCourses, style: txtTheme.headlineMedium?.apply(fontSizeFactor: 1.2)),
//                 DashboardTopCourses(txtTheme: txtTheme, isDark: isDark)
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
