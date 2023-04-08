class Schools {
  late String name;
  late String location;
  late String code;

  Schools({required this.name, required this.location, required this.code});

  Schools.fromMap(Map<String, dynamic>? map) {
    name = map?['SCHUL_NM'] ?? '';
    location = map?['ORG_RDNMA'] ?? '';
    code = map?['SD_SCHUL_CODE'] ?? '';
  }
}
