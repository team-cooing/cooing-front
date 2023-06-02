import 'dart:convert';

import 'package:cooing_front/model/config/palette.dart';
import 'package:cooing_front/widgets/dynamic_link.dart';

import 'package:cooing_front/pages/tab_page.dart';
import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart' as kakao;
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

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
      final userPlatform = await FlutterSecureStorage().read(key: 'userPlatform');
      if(userPlatform!=null&&userPlatform=='apple'){
        final userId = await FlutterSecureStorage().read(key: "userId");
        final appleUserUid = await FlutterSecureStorage().read(key: "appleUserUid");
        final appleUserEmail = await FlutterSecureStorage().read(key: "appleUserEmail");
        if(userId == null){
          print("No Stored user ID");
        }else{
          newUserUid = appleUserUid.toString();
          var bytes = utf8.encode(userId); // 비밀번호를 UTF-8 형식의 바이트 배열로 변환
          var digest = sha256.convert(bytes); // SHA-256 알고리즘을 사용하여 해시화
          String newPassword = digest.toString();
          await firebase.FirebaseAuth.instance.signInWithEmailAndPassword(email: appleUserEmail.toString(), password: newPassword);
          DynamicLink().setup(newUserUid).then((value) {
            print("SplashScreen ::::::::::: DynamicLink()$value $newUserUid");

            if (value) {
              print("value ?????? $value");
              print("dynamic link 로 접속");
            } else {
              initialRoute = 'tab';
              print("dynamic link 로 접속하지 않음 ");
            }
          });
          }
      }else{
        final hasToken = await kakao.AuthApi.instance.hasToken();
        if (hasToken) {
          final user = await kakao.UserApi.instance.me();

          final email = user.kakaoAccount?.email ?? '';
          uid = user.id.toString();

          final newUser =
          await firebase.FirebaseAuth.instance.signInWithEmailAndPassword(
            email: email,
            password: uid,
          );

          newUserUid = newUser.user!.uid;

          DynamicLink().setup(newUserUid).then((value) {
            print("SplashScreen ::::::::::: DynamicLink()$value $newUserUid");

            if (value) {
              print("value ?????? $value");
              print("dynamic link 로 접속");
            } else {
              initialRoute = 'tab';
              print("dynamic link 로 접속하지 않음 ");
            }
          });

          print('기기내 카카오 토큰으로 로그인 성공');
        }
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
    if (initialRoute == 'tab') {
      Get.offAll(TabPage(), arguments: newUserUid);
    } else {
      Navigator.pushReplacementNamed(context, initialRoute);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
            ),
            backgroundColor: Palette.mainPurple,
            body: Container(
                width: double.infinity,
                height: double.infinity,
                alignment: Alignment.topCenter,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        alignment: Alignment.topCenter,
                        fit: BoxFit.cover,
                        image: AssetImage('images/splash.png'))))));
  }
}
