import 'dart:convert';
import 'dart:io';
import 'package:cooing_front/model/User.dart';

import 'package:cooing_front/pages/SignUpScreen.dart';
import 'package:cooing_front/model/Login_platform.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:flutter/material.dart';
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

  _routePage() async {
    String initialRoute = 'home';

    // 발급된 토큰 존재.
    if (await kakao.AuthApi.instance.hasToken()) {
      // 존재하는 토큰이 유효한 것인가?
      try {
        kakao.AccessTokenInfo tokenInfo =
            await kakao.UserApi.instance.accessTokenInfo();
        print(
            '토큰 유효성 체크 성공 회원정보 : ${tokenInfo.id} / 만료시간 : ${tokenInfo.expiresIn}');
        initialRoute = 'tab';
      }
      // 발급받은 적은 있는데 현재 토큰이 유효하지 않다면 이유 확인
      // 과거에 회원가입은 했었다는 것임.
      catch (error) {
        // 만료된 토큰인지
        if (error is kakao.KakaoException && error.isInvalidTokenError()) {
          print('토큰 만료 $error');
          initialRoute = 'token';
        }
        // 조회가 실패된 토큰인지 : 계정 삭제 등? 회원가입 필요?
        else {
          print('토큰 정보 조회 실패 $error');
          initialRoute = 'home';
        }
      }
    }
    // 발급된 토큰 없음.
    else {
      print('발급된 토큰 없음');
      initialRoute = 'home';
    }
    await Future.delayed(Duration(seconds: 4));
    return Navigator.pushReplacementNamed(context, initialRoute);
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
