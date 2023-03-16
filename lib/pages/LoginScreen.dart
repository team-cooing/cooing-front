import 'dart:convert';
import 'dart:io';

import 'package:cooing_front/pages/SignUpScreen.dart';
import 'package:cooing_front/model/Login_platform.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  LoginPlatform _loginPlatform = LoginPlatform.none;

  void signInWithKakao() async {
    User user;
    try {
      bool isInstalled = await isKakaoTalkInstalled();
      OAuthToken token = isInstalled
          ? await UserApi.instance.loginWithKakaoTalk()
          : await UserApi.instance.loginWithKakaoAccount();

      final url = Uri.https('kapi.kakao.com', '/v2/user/me');

      final response = await http.get(
        url,
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer ${token.accessToken}'
        },
      );

      User user = await UserApi.instance.me();

      print('사용자 정보 요청 성공'
          '\n닉네임: ${user.kakaoAccount?.profile?.nickname}');

      setState(() {
        _loginPlatform = LoginPlatform.kakao;
      });

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const SignUpScreen()),
      );
    } catch (error) {
      print('카카오톡으로 로그인 실패 $error');
      print(await KakaoSdk.origin);
    }
  }

  void signOut() async {
    switch (_loginPlatform) {
      case LoginPlatform.kakao:
        await UserApi.instance.logout();
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
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
          ),
        ));
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

class UserInfo {
  String name;
  String profile_image;
  String gender;
  int age;
  String birthday;
  UserInfo(this.name, this.profile_image, this.gender, this.age, this.birthday);
}
