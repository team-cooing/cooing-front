import 'dart:async';
import 'package:cooing_front/model/data/my_user.dart';
import 'package:cooing_front/model/response/user.dart';
import 'package:cooing_front/pages/tab_page.dart';
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
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _uploadUserToFirebase());
  }

  final _authentication = firebase.FirebaseAuth.instance;

  Future<void> _uploadUserToFirebase() async {
    try {
      final args = ModalRoute.of(context)!.settings.arguments as User;

      final firebaseUser = _authentication.currentUser;

      print(firebaseUser);

      if (firebaseUser != null) {
        final uid = firebaseUser.uid.toString();
        args.uid = uid;

        await r.Response.createUser(newUser: args);

        if(MyUser.userPlatform=='apple'){
          // Store user Id (자동로그인을 위한 인증된 user 정보 저장)
          await FlutterSecureStorage()
              .write(key: "userId", value: MyUser.userId);
          await FlutterSecureStorage()
              .write(key: "userPlatform", value: MyUser.userPlatform);
          await FlutterSecureStorage()
              .write(key: "appleUserEmail", value: MyUser.appleUserEmail);
          await FlutterSecureStorage().write(key: "appleUserUid", value: MyUser.appleUserUid);
        }

        Get.to(TabPage(), arguments: uid);
      } else {
        final user = await kakao.UserApi.instance.me();
        print('문제 부분 kakao user: ${user.toJson().toString()}');
        final newUser = await _authentication.createUserWithEmailAndPassword(
            email: user.kakaoAccount!.email.toString(),
            password: user.id.toString());

        print('문제 부분 firebase user: ${newUser.toString()}');

        final uid = newUser.user!.uid.toString();
        args.uid = uid;

        await r.Response.createUser(newUser: args);

        if(MyUser.userPlatform=='apple'){
          // Store user Id (자동로그인을 위한 인증된 user 정보 저장)
          await FlutterSecureStorage()
              .write(key: "userId", value: MyUser.userId);
          await FlutterSecureStorage()
              .write(key: "userPlatform", value: MyUser.userPlatform);
          await FlutterSecureStorage()
              .write(key: "appleUserEmail", value: MyUser.appleUserEmail);
          await FlutterSecureStorage().write(key: "appleUserUid", value: MyUser.appleUserUid);
        }

        Get.to(TabPage(), arguments: uid);
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as User;

    return WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: Scaffold(
            backgroundColor: Color(0xFFffffff),
            body: Container(
                padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
                child: Form(
                    child: Center(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                      Container(
                        padding: EdgeInsets.all(10),
                        child: Text(
                          "회원가입 완료!",
                          style: TextStyle(
                              fontSize: 16.sp,
                              color: Color.fromRGBO(51, 61, 75, 0.6)),
                        ),
                      ),
                      Text(
                        " ${args.name}님,",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 22.sp,
                            color: Color.fromARGB(255, 51, 61, 75)),
                      ),
                      Text(
                        "환영합니다!",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 22.sp,
                            color: Color.fromARGB(255, 51, 61, 75)),
                      ),
                    ]))))));
  }
}
