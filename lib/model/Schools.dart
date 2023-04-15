class Schools {
  late String name;
  late String location;
  late String code;
  late String org;

  Schools(
      {required this.name,
      required this.location,
      required this.code,
      required this.org});

  Schools.fromMap(Map<String, dynamic>? map) {
    name = map?['SCHUL_NM'] ?? '';
    location = map?['ORG_RDNMA'] ?? '';
    code = map?['SD_SCHUL_CODE'] ?? '';
    org = map?['JU_ORG_NM'] ?? '';
  }
}
