// class MenuItem {
//   final String name;
//   final List<String> attributes;

//   MenuItem({required this.name, required this.attributes});

// factory MenuItem.fromJson(Map<String, dynamic> json) {
// return MenuItem(
// name: json['name'],
// attributes: List<String>.from(json['attributes']),
// );
// }

// @override
// String toString() {
// return 'MenuItem{name: $name, attributes: $attributes}';
// }
// }

class MenuItem {
  final String name;
  final List<String> attributes;
  final Map<String, dynamic> nutritionalFacts;

  MenuItem({
    required this.name,
    required this.attributes,
    required this.nutritionalFacts,
  });

  factory MenuItem.fromJson(Map<String, dynamic> json) {
    return MenuItem(
      name: json['name'],
      attributes: List<String>.from(json['attributes']),
      nutritionalFacts: json['nutritionalFacts'] ?? {}, // Use an empty map if nutritionalFacts is not provided
    );
  }

  @override
  String toString() {
    return 'MenuItem{name: $name, attributes: $attributes, nutritionalFacts: $nutritionalFacts}';
  }
}
