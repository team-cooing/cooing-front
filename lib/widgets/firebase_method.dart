// Question 객체를 Firestore 문서로 변환하는 함수

import 'package:cooing_front/model/response/user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:cooing_front/model/response/response.dart' as response;

Future<User?> getUserCookieData(String uid) async {
  final prefs = await asyncPrefsOperation();
  final userDataJson = prefs.getString('userData');
  if (userDataJson != null) {
    print("answer page : 쿠키 에서 UserData 로드");
    Map<String, dynamic> userDataMap =
        json.decode(userDataJson); //z쿠키가 있ㅇㅡ면 쿠키 리턴
    return User.fromJson(userDataMap);
  } else {
    User? user = await response.Response.readUser(userUid: uid);
    print("서버에서 user 읽음");
    return user;
  }
}

Future<SharedPreferences> asyncPrefsOperation() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  print(prefs);
  return prefs;
}
