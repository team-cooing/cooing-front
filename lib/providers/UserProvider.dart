import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:cooing_front/model/User.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class UserDataProvider with ChangeNotifier {
  User? _userData = null;
  bool _isDataLoaded = false;

  UserDataProvider() {
    _loadUserDataFromCookie();
  }

  Future<void> loadData() async {
    if (_isDataLoaded) {
      return;
    }

    final user = firebase.FirebaseAuth.instance.currentUser;
    final uid = user?.uid;

    if (uid != null) {
      final snapshot =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();
      final data = snapshot.data();
      if (data != null) {
        _userData = User(
          uid: uid,
          name: data['name'],
          profileImage: data['profileImage'],
          gender: data['gender'],
          age: data['age'],
          number: data['number'],
          school: data['school'],
          schoolCode: data['schoolCode'],
          grade: data['grade'],
          group: data['group'],
          eyes: data['eyes'],
          mbti: data['mbti'],
          hobby: data['hobby'],
          style: List<String>.from(data['style']),
        );
        _isDataLoaded = true;
        _saveUserDataToCookie(_userData!);
        notifyListeners();
      }
    }
  }

  Future<void> _loadUserDataFromCookie() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final String? userDataJson = prefs.getString('userData');

    if (userDataJson != null) {
      _userData = User.fromJson(json.decode(userDataJson));
      print('쿠키 있음.');
      _isDataLoaded = true;
      notifyListeners();
    } else {
      loadData();
      print('쿠키 없음.');
    }
  }

  void _saveUserDataToCookie(User userData) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String userDataJson = jsonEncode(userData);
    prefs.setString('userData', userDataJson);
    print('쿠키 저장됨.');
  }

  User? get userData => _userData;
}
