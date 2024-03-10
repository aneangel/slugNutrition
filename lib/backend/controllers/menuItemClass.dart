class MenuItem {
  final String name;
  final List<String> attributes;

  MenuItem({required this.name, required this.attributes});

  factory MenuItem.fromJson(Map<String, dynamic> json) {
    return MenuItem(
      name: json['name'],
      attributes: List<String>.from(json['attributes']),
    );
  }
}
