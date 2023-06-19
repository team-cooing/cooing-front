// 2023.06.18 SUN Midas: ✅
// 코드 효율성 점검: ✅
// 예외처리: ✅
// 중복 서버 송수신 방지: ✅

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

    // null 예외 처리 ✅
    final userPlatform = await FlutterSecureStorage().read(key: 'userPlatform');
    if (userPlatform != null) {
      // 만약, 로그인 정보가 있다면
      if (userPlatform == 'apple') {
        // 만약, 애플 로그인이라면
        // null 예외 처리 ✅
        final userId = await FlutterSecureStorage().read(key: "userId");
        // null 예외 처리 ✅
        final appleUserUid =
            await FlutterSecureStorage().read(key: "appleUserUid");
        // null 예외 처리 ✅
        final appleUserEmail =
            await FlutterSecureStorage().read(key: "appleUserEmail");
        if (userId == null) {
          // home 으로 이동
          print("No Stored user ID");
        } else if (appleUserUid == null) {
          // home 으로 이동
          print("No Stored apple user UID");
        } else if (appleUserEmail == null) {
          // home 으로 이동
          print("No Stored apple user Email");
        } else {
          // 만약, userId, appleUserUid, appleUserEmail 모두 있다면

          newUserUid = appleUserUid.toString();
          var bytes = utf8.encode(userId); // 비밀번호를 UTF-8 형식의 바이트 배열로 변환
          var digest = sha256.convert(bytes); // SHA-256 알고리즘을 사용하여 해시화
          String newPassword = digest.toString();

          try{
            await firebase.FirebaseAuth.instance.signInWithEmailAndPassword(
                email: appleUserEmail.toString(), password: newPassword);

            await DynamicLink().setup(newUserUid);

            // tab 으로 이동
            initialRoute = 'tab';
          }catch(e){
            print('파이어베이스 로그인 에러 - E: $e');
            // home 으로 이동
          }
        }
      } else {
        // 만약, 카카오 로그인이라면

        try {
          final hasToken = await kakao.AuthApi.instance.hasToken();
          if (hasToken) {
            // 만약, 카카오 로그인 토큰이 있다면

            kakao.User user = await kakao.UserApi.instance.me();

            // null 예외 처리 ✅
            String email = user.kakaoAccount?.email ?? '';
            uid = user.id.toString();

            var bytes = utf8.encode(uid); // 비밀번호를 UTF-8 형식의 바이트 배열로 변환
            var digest = sha256.convert(bytes); // SHA-256 알고리즘을 사용하여 해시화
            String newPassword = digest.toString();

            firebase.UserCredential userCredential =
                await firebase.FirebaseAuth.instance.signInWithEmailAndPassword(
              email: email,
              password: newPassword,
            );

            // null 예외 처리 ✅
            firebase.User? newUser = userCredential.user;
            if (newUser != null) {
              // 만약, 유저 정보가 있다면
              newUserUid = userCredential.user!.uid;

              await DynamicLink().setup(newUserUid);

              // tab 으로 이동
              initialRoute = 'tab';
            } else {
              // 만약, 유저 정보가 없다면
              // home 으로 이동
            }
          }else{
            // 만약, 카카오 로그인 토큰이 없다면
            // home 으로 이동
          }
        } on kakao.KakaoAuthException catch (e) {
          // home 으로 이동
          print('카카오 로그인 에러 - E: ${e.toString()}');
        } on firebase.FirebaseAuthException catch (e) {
          // home 으로 이동
          print('파이어베이스 로그인 에러 - E: ${e.toString()}');
        } catch (e) {
          // home 으로 이동
          print('알 수 없는 에러 - E: ${e.toString()}');
        }
      }
    } else {
      // 만약, 로그인 정보가 없다면
      // home 으로 이동
    }

    // 로그인 정보 파악 후, 페이지 이동
    await Future.delayed(Duration(seconds: 3));
    if (initialRoute == 'tab') {
      print('$userPlatform 토큰 자동 로그인 성공 👋');

      Get.offAll(TabPage(), arguments: newUserUid);
    } else {
      if(!mounted) return;
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
                        image: AssetImage('assets/images/splash.png'))))));
  }
}
