// MenuItem class definition (make sure this matches your data structure)
class MenuItem {
  final String name;
  final List<String> attributes;

  MenuItem({required this.name, required this.attributes});

  factory MenuItem.fromJson(Map<String, dynamic> json) {
    return MenuItem(
      name: json['name'] as String,
      attributes: List<String>.from(json['attributes']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'attributes': attributes,
    };
  }
}