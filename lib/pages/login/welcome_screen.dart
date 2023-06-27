// 2023.06.19 MON Midas: ✅
// 코드 효율성 점검: ✅
// 예외처리: ✅
// 중복 서버 송수신 방지: ✅

import 'dart:async';
import 'dart:convert';
import 'package:cooing_front/model/data/my_user.dart';
import 'package:cooing_front/model/response/user.dart';
import 'package:cooing_front/pages/login/login_screen.dart';
import 'package:cooing_front/pages/tab_page.dart';
import 'package:cooing_front/widgets/loading_view.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart' as kakao;
import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:cooing_front/model/response/response.dart' as r;

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final _authentication = firebase.FirebaseAuth.instance;
  String newUserUid = '';
  bool isLoading = true;
  bool isSuccess = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _uploadUserToFirebase().then((value) {
        setState(() {
          isLoading = false;
        });
        Future.delayed(Duration(seconds: 2)).then((value) {
          if (isSuccess) {
            Get.offAll(TabPage(), arguments: newUserUid);
          } else {
            Get.offAll(LoginScreen(), arguments: newUserUid);
          }
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as User;

    return isLoading
        ? loadingView()
        : WillPopScope(
            onWillPop: () async {
              return false;
            },
            child: Scaffold(
                backgroundColor: Color(0xFFffffff),
                body: Container(
                    padding:
                        const EdgeInsets.only(left: 20, right: 20, bottom: 20),
                    child: Form(
                        child: Center(
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                          Container(
                            padding: EdgeInsets.all(10),
                            child: Text(
                              isSuccess ? "회원가입 완료!" : "회원가입 실패...",
                              style: TextStyle(
                                  fontSize: 16.sp,
                                  color: Color.fromRGBO(51, 61, 75, 0.6)),
                            ),
                          ),
                          Text(
                            isSuccess ? " ${args.name}님," : "다시 한번",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 22.sp,
                                color: Color.fromARGB(255, 51, 61, 75)),
                          ),
                          Text(
                            isSuccess ? "환영합니다!" : "시도해주세요",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 22.sp,
                                color: Color.fromARGB(255, 51, 61, 75)),
                          ),
                        ]))))));
  }

  Future<void> _uploadUserToFirebase() async {
    try {
      final args = ModalRoute.of(context)!.settings.arguments as User;

      if (MyUser.userPlatform == 'apple') {
        // 만약, 애플 로그인이라면

        final firebaseUser = _authentication.currentUser;
        if (firebaseUser != null) {
          final uid = firebaseUser.uid.toString();
          args.uid = uid;
          newUserUid = uid;

          await r.Response.createUser(newUser: args);

          // Store user Id (자동로그인을 위한 인증된 user 정보 저장)
          await FlutterSecureStorage()
              .write(key: "userId", value: MyUser.userId);
          await FlutterSecureStorage()
              .write(key: "userPlatform", value: MyUser.userPlatform);
          await FlutterSecureStorage()
              .write(key: "appleUserEmail", value: MyUser.appleUserEmail);
          await FlutterSecureStorage()
              .write(key: "appleUserUid", value: MyUser.appleUserUid);

          print('애플 회원가입 성공 👋');
          isSuccess = true;
        }
      } else {
        // 만약, 카카오 로그인이라면

        final user = await kakao.UserApi.instance.me();
        var bytes =
            utf8.encode(user.id.toString()); // 비밀번호를 UTF-8 형식의 바이트 배열로 변환
        var digest = sha256.convert(bytes); // SHA-256 알고리즘을 사용하여 해시화
        String newPassword = digest.toString();
        final newUser = await _authentication.createUserWithEmailAndPassword(
            email: user.kakaoAccount!.email.toString(), password: newPassword);

        await FlutterSecureStorage().write(key: "userPlatform", value: 'kakao');

        final uid = newUser.user!.uid.toString();
        args.uid = uid;
        newUserUid = uid;

        await r.Response.createUser(newUser: args);

        print('카카오 회원가입 성공 👋');
        isSuccess = true;
      }
    } on kakao.KakaoAuthException catch (e) {
      print('카카오 로그인 에러 - E: ${e.toString()}');
    } on firebase.FirebaseAuthException catch (e) {
      print('파이어베이스 로그인 에러 - E: ${e.toString()}');
    } catch (e) {
      print('알 수 없는 에러 - E: ${e.toString()}');
    }
  }
}
