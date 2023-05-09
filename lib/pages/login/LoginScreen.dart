import 'dart:convert';
import 'dart:io';
import 'package:cooing_front/model/response/User.dart';
import 'package:cooing_front/pages/tab_page.dart';
import 'package:get/get.dart';

import 'package:cooing_front/pages/login/SignUpScreen.dart';
import 'package:cooing_front/model/util/Login_platform.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart' as kakao;
// import 'package:parameters/';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  LoginPlatform _loginPlatform = LoginPlatform.none;
  String nickname = '';
  String profileImage = '';

  void signInWithKakao() async {
    try {
      bool isInstalled = await kakao.isKakaoTalkInstalled();
      kakao.OAuthToken token = isInstalled
          ? await kakao.UserApi.instance.loginWithKakaoTalk()
          : await kakao.UserApi.instance.loginWithKakaoAccount();

      final url = Uri.https('kapi.kakao.com', '/v2/user/me');

      final response = await http.get(
        url,
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer ${token.accessToken}'
        },
      );

      kakao.User user = await kakao.UserApi.instance.me();

      String email = user.kakaoAccount?.email ?? '';
      String uid = user.id.toString();

      String nickname = '${user.kakaoAccount?.profile?.nickname}';
      String profileImage = '${user.kakaoAccount?.profile?.profileImageUrl}';

      print('사용자 정보 요청 성공'
          '\n닉네임: ${user.kakaoAccount?.profile?.nickname}');

      setState(() {
        _loginPlatform = LoginPlatform.kakao;
      });

      await firebaseLogin(email, uid, nickname, profileImage);
    } catch (error) {
      print('카카오톡으로 로그인 실패 $error');
      print(await kakao.KakaoSdk.origin);
    }
  }

  Future<void> firebaseLogin(
      String email, String uid, String name, String profileImage) async {
    try {
      firebase.UserCredential userCredential = await firebase
          .FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: uid);
      Get.offAll(TabPage(), arguments: userCredential.user!.uid);
      print('파이어베이스 로그인 성공');
    } on firebase.FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        Navigator.pushNamed(
          context,
          'signUp',
          arguments: User(
            uid: uid,
            name: name,
            profileImage: profileImage,
            gender: 0,
            number: '',
            age: '',
            birthday: '0000-00-00',
            school: '',
            schoolCode: '',
            schoolOrg: '',
            grade: 0,
            group: 0,
            eyes: 0,
            mbti: '',
            hobby: '',
            style: [],
            isSubscribe: false,
            candyCount: 0,
            questionInfos: [],
            answeredQuestions: [],
            currentQuestionId: '',
            serviceNeedsAgreement: false,
            privacyNeedsAgreement: false,
          ),
        );
        print('파이어베이스 로그인 실패 회원가입으로 이동');
      }
    }
  }

  void signOut() async {
    switch (_loginPlatform) {
      case LoginPlatform.kakao:
        await kakao.UserApi.instance.logout();
        break;
      case LoginPlatform.none:
        break;
    }

    setState(() {
      _loginPlatform = LoginPlatform.none;
    });
  }

  @override
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
                      "당신을 몰래 좋아하는",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                          color: Color.fromARGB(255, 51, 61, 75)),
                    ),
                    Text(
                      "사람은 누굴까요?",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                          color: Color.fromARGB(255, 51, 61, 75)),
                    ),
                    Spacer(),
                    _loginButton()
                  ]),
            )));
  }

  Widget _loginButton() {
    return SizedBox(
      width: double.infinity,
      child: TextButton(
        child: Image.asset('images/kakao_login_medium_wide.png'),
        onPressed: () {
          signInWithKakao();
        },
      ),
    );
  }

  // Widget _logoutButton() {
  //   return ElevatedButton(
  //     onPressed: signOut,
  //     style: ButtonStyle(
  //       backgroundColor: MaterialStateProperty.all(
  //         const Color(0xff0165E1),
  //       ),
  //     ),
  //     child: const Text('로그아웃'),
  //   );
  // }
}
