// Importing material.dart, which contains Flutter's Material Design widgets and theme.
import 'package:flutter/material.dart';
import '/src/utils/theme/theme.dart';
import 'package:get/get.dart';
import '/src/features/authentication/screens/splash_screen/splash_screen.dart';

// The main entry point of the application. The arrow syntax is used for one-liner functions.
void main() => runApp(const App());

// The App class is a StatelessWidget, which means its properties (or configuration) cannot change.
// All StatelessWidget must override the build method.
class App extends StatelessWidget {
  // The constructor for App. It allows an optional Key to be passed in for use by the framework.
  // The "const" keyword before the constructor enables this widget to be created as a compile-time constant.
  const App({Key? key}) : super(key: key);

  @override
  // The build method describes the part of the user interface this widget represents.
  // The context parameter represents the location of this widget in the widget tree.
  Widget build(BuildContext context) {
    // MaterialApp is a predefined class in Flutter that wraps several widgets that are commonly required for material design applications.
    // It's being created with a "const" constructor here for performance optimization.
    return GetMaterialApp(
      // home is one of the properties of MaterialApp. It defines the default route of the app (i.e., the starting point).
      // AppHome is a custom widget that would represent the main screen of the app.
      theme: TAppTheme.lightTheme,
      darkTheme: TAppTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: SplashScreen(),
    );
  }
}

//
// class AppHome extends StatelessWidget {
//   const AppHome({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar:
//           AppBar(title: Text(".appable/"), leading: Icon(Icons.ondemand_video)),
//       floatingActionButton: FloatingActionButton(
//         child: Icon(Icons.add_shopping_cart_outlined),
//         onPressed: () {},
//       ),
//       body: Padding(
//         padding: EdgeInsets.all(20.0),
//         child: ListView(
//           children: [
//             Text(
//               "Heading",
//               style: Theme.of(context).textTheme.headline2,
//             ),
//             Text(
//               "Sub-heading",
//               style: Theme.of(context).textTheme.subtitle2,
//             ),
//             Text(
//               "Paragraph",
//               style: Theme.of(context).textTheme.bodyText1,
//             ),
//             ElevatedButton(
//               onPressed: () {},
//               child: Text("Elevated Button"),
//             ),
//             OutlinedButton(
//               onPressed: () {},
//               child: const Text("Outlined Button"),
//             ),
//             Padding(
//               padding: EdgeInsets.all(20.0),
//               child: Image(image: AssetImage("assets/images/omlette.png")),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
