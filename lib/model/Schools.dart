class Schools {
  late String name;
  late String location;

  Schools({required this.name, required this.location});

  Schools.fromMap(Map<String, dynamic>? map) {
    name = map?['SCHUL_NM'] ?? '';
    location = map?['ORG_RDNMA'] ?? '';
  }
}
