import 'dart:convert';
import 'dart:io';
import 'package:cooing_front/model/response/user.dart';

import 'package:cooing_front/pages/login/SignUpScreen.dart';
import 'package:cooing_front/model/util/Login_platform.dart';
import 'package:cooing_front/pages/tab_page.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:http/http.dart' as http;
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart' as kakao;
// import 'package:parameters/';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);
  static const routeName = 'splash';

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _routePage();
  }

  Future<void> _routePage() async {
    String initialRoute = 'home';
    String newUserUid = '';
    String uid = '';

    try {
      final hasToken = await kakao.AuthApi.instance.hasToken();
      if (hasToken) {
        final tokenInfo = await kakao.UserApi.instance.accessTokenInfo();
        final user = await kakao.UserApi.instance.me();

        final email = user.kakaoAccount?.email ?? '';
        uid = user.id.toString();

        final newUser = await firebase.FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: uid,
        );

        newUserUid = newUser.user!.uid;

        initialRoute = 'tab';
        print('기기내 카카오 토큰으로 로그인 성공');
      }
    } on kakao.KakaoAuthException catch (e) {
      initialRoute = 'home';
      print('카카오 로그인 실패: ${e.toString()}');
    } on firebase.FirebaseAuthException catch (e) {
      initialRoute = 'home';
      print('파이어베이스 로그인 실패: ${e.toString()}');
    } catch (e) {
      initialRoute = 'home';
      print('알 수 없는 에러: ${e.toString()}');
    }

    await Future.delayed(Duration(seconds: 4));
    if(initialRoute=='tab'){
      Get.offAll(TabPage(), arguments: newUserUid);
    }else{
      Navigator.pushReplacementNamed(context, initialRoute);
    }

  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        backgroundColor: Color(0xFFffffff),
        body: Container(
            padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
            child: Form(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "쿠잉",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                          color: Color.fromARGB(255, 51, 61, 75)),
                    ),
                    Spacer(),
                  ]),
            )));
  }
}
