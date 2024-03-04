import 'package:flutter/material.dart';
import '/src/features/core/screens/dashboard/widgets/mealOptionsScreen.dart';

class DiningHallGrid extends StatelessWidget {
  final List<Map<String, String>> diningHalls;

  const DiningHallGrid({
    Key? key,
    required this.diningHalls,
  }) : super(key: key);

  void navigateToMealOptions(BuildContext context, String hallName) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MealOptionsScreen(hallName: hallName), // You need to define MealOptionsScreen
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(8),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
        childAspectRatio: 1,
      ),
      itemCount: diningHalls.length,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return InkWell(
          onTap: () => navigateToMealOptions(context, diningHalls[index]['name']!),
          child: Card(
            color: Color(0xFFF5F5F7),
            elevation: 10,
            shadowColor: Color.fromRGBO(0, 51, 102, 0.2),
            clipBehavior: Clip.antiAlias,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            child: Stack(
              children: <Widget>[
                Align(
                  alignment: Alignment.topRight,
                  child: Container(
                    width: 70,
                    height: 70,
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
                      color: Color(0xFF003366),
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
