import 'package:flutter/material.dart';
import '/src/constants/colors.dart';
import '/src/constants/sizes.dart';
import '/src/constants/text_strings.dart';  // Assuming this file contains strings for FAQs

class FAQScreen extends StatelessWidget {
  FAQScreen({Key? key}) : super(key: key);

  final List<Map<String, dynamic>> faqs = [
    {
      'question': 'How do I customize my meal plan?',
      'answer': 'You can customize your meal plan by selecting your dietary preferences, favorite dining options, and any specific dietary restrictions you have from your profile settings. Our app will then tailor your meal plans accordingly.',
      'icon': Icons.restaurant_menu,
    },
    {
      'question': 'What if I have dietary restrictions?',
      'answer': 'Our app allows you to set dietary restrictions such as vegetarian, vegan, gluten-free, etc. Just update your dietary preferences in your profile settings, and your meal plans will be adjusted accordingly.',
      'icon': Icons.no_food,
    },
    {
      'question': 'Can I change my meal plan once it\'s set?',
      'answer': 'Yes, you can change your meal plan anytime by going to your profile settings and updating your preferences or restrictions.',
      'icon': Icons.sync_alt,
    },
    {
      'question': 'How do I edit my height and weight?',
      'answer': 'You can change your height and weight anytime by going to your profile settings and updating your height and weight.',
      'icon': Icons.height,
    },
    {
      'question': 'Are all campus dining options available to get a personalized meal for?',
      'answer': 'Yes, our app has a feature that lets you check and select what dining halls are available to your liking.',
      'icon': Icons.location_city,
    },
  ];

  @override
  Widget build(BuildContext context) {
    TextStyle answerTextStyle = TextStyle(color: Colors.grey.shade600, fontSize: 16);
    TextStyle questionTextStyle = const TextStyle(fontWeight: FontWeight.bold, fontSize: 18);

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('FAQs'),
          backgroundColor: tPrimaryColor,
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(tDefaultSpace),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: tDefaultSpace),
                  child: Text(
                    'Frequently Asked Questions',
                    style: Theme.of(context).textTheme.headline5?.copyWith(color: Colors.black),
                    textAlign: TextAlign.center,
                  ),
                ),
                ..._buildFAQItems(context, answerTextStyle, questionTextStyle),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildFAQItems(BuildContext context, TextStyle answerTextStyle, TextStyle questionTextStyle) {
    return faqs.map((faq) {
      return Card(
        elevation: 4,
        margin: const EdgeInsets.symmetric(vertical: 8),
        child: Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent), // Make built-in dividers transparent
          child: ExpansionTile(
            leading: Icon(faq['icon'], color: Colors.black),
            title: Text(faq['question'], style: questionTextStyle),
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 16.0, right: 16.0, top: 8.0), // Adjust padding as needed
                child: Divider(color: Colors.grey, thickness: 1), // Keep this Divider
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(faq['answer'], style: answerTextStyle),
              ),
            ],
          ),
        ),
      );
    }).toList();
  }

}