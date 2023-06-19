import 'package:cooing_front/model/response/school.dart';
import 'package:csv/csv.dart';
import 'package:flutter/services.dart';

class SchoolsProviders {
  List<School> schoolData = [];

  Future<void> initSchoolProvider() async {
    String csvData = await rootBundle.loadString('assets/data/school_data.csv');
    List<List<dynamic>> csvTable = CsvToListConverter().convert(csvData, eol: '\n');
    for (var csvRow in csvTable) {
      if(csvRow == csvTable[0]){
        continue;
      }
      School school = School(
          id: csvRow[0].toString(),
          name: csvRow[1].toString(),
          level: csvRow[2].toString(),
          establishmentDate: csvRow[3].toString(),
          establishmentType: csvRow[4].toString(),
          schoolType: csvRow[5].toString(),
          operationalStatus: csvRow[6].toString(),
          address: csvRow[7].toString(),
          schoolOrg: csvRow[10].toString());
      schoolData.add(school);
    }
  }

  List<School> searchSchools(String query) {
    return schoolData
        .where((school) {
          return school.name.contains(query);
        })
        .take(50)
        .toList();
  }
}
