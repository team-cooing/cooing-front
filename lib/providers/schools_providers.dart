import 'dart:convert';

import 'package:cooing_front/model/response/Schools.dart';
import 'package:http/http.dart' as http;

class SchoolsProviders {
  Future<List<Schools>> getSchools(args) async {
    List<Schools> schools = [];

    Uri uri = Uri.parse(
        "https://open.neis.go.kr/hub/schoolInfo?Type=json&SCHUL_NM=${args}&apiKey=5ba72443538b44759c48f5ed4289cb21");

    final response = await http.get(uri);
    if (response.statusCode == 200) {
      // schools = jsonDecode(response.body)['articles'].map<Schools>((article) {
      print(jsonDecode(response.body).keys.toString());
      if (jsonDecode(response.body).keys.toString() == '(schoolInfo)') {
        schools = jsonDecode(response.body)['schoolInfo'][1]['row']
            .map<Schools>((school) {
          return Schools.fromMap(school);
        }).toList();
      }
      // if (jsonDecode(response.body).k)
    } else {
      print('error');
    }

    return schools;
  }
}
