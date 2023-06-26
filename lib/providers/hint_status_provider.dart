import 'package:cooing_front/model/response/hint_status.dart';
import 'package:cooing_front/model/response/response.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class HintStatusProvider with ChangeNotifier {
  static HintStatus? _hintStatusData;
  bool _isDataLoaded = false;

  static void initializeStaticVariables(){
    _hintStatusData = null;
  }

  Future saveCookie() async{
    if (_hintStatusData != null) {
      await _saveHintStatusDataToCookie(_hintStatusData!);
      notifyListeners();
    }
  }

  Future<void> loadHintStatusDataFromCookie() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final String? hintStatusDataJson = prefs.getString('hintStatusData');

    if (hintStatusDataJson != null) {
      _hintStatusData = HintStatus.fromJson(json.decode(hintStatusDataJson));
      _isDataLoaded = true;
      notifyListeners();
    } else {
      await loadData();
    }
  }

  Future<void> loadData() async {
    if (_isDataLoaded) {
      return;
    }

    final user = firebase.FirebaseAuth.instance.currentUser;
    final uid = user?.uid;

    if (uid != null) {
      _hintStatusData = await Response.readHintStatus(ownerId: uid);
      _isDataLoaded = true;
      await _saveHintStatusDataToCookie(_hintStatusData!);
      notifyListeners();
    }
  }

  Future _saveHintStatusDataToCookie(HintStatus hintStatusData) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String hintStatusDataJson = jsonEncode(hintStatusData);
    prefs.setString('hintStatusData', hintStatusDataJson);
  }

  HintStatus? get hintStatusData => _hintStatusData;
}
