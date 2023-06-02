// Question 객체를 Firestore 문서로 변환하는 함수

import 'package:cooing_front/model/response/user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:cooing_front/model/response/response.dart' as response;

// Future<User?> getUserData(String uid) async {
//   final prefs = await asyncPrefsOperation();
//   final userDataJson = prefs.getString('userData');
//   if (userDataJson != null) {
//     print("<getUserData> cookie에서 UserData 로드");
//     Map<String, dynamic> userDataMap = json.decode(userDataJson);
//     return User.fromJson(userDataMap);

//   } else {
//     //쿠키없으면 서버에서 읽기
//     User? user = await response.Response.readUser(userUid: uid);
//     print("<getUserData> firebase에서 UserData 로드");
//     return user;
//   }
// }

// Future<SharedPreferences> asyncPrefsOperation() async {
//   SharedPreferences prefs = await SharedPreferences.getInstance();
//   print(prefs);
//   return prefs;
// }
