class Schools {
  late String name;
  late String location;

  Schools({required this.name, required this.location});

  News.fromMap(Map<String, dynamic>? map) {
    title = map?['title'] ?? '';
    content = map?['description'] ?? '';
  }
}
