import 'dart:async';
import 'dart:convert';
import 'package:cooing_front/model/data/my_user.dart';
import 'package:cooing_front/pages/login/LoginScreen.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cooing_front/model/response/user.dart';
import 'package:cooing_front/model/util/hint.dart';
import 'package:cooing_front/pages/question_page.dart';
import 'package:cooing_front/pages/tab_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart' as kakao;
import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

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
        final userRef = FirebaseFirestore.instance.collection('users');
        await userRef.doc(uid).set({
          "uid": uid,
          "name": args.name,
          "profileImage": args.profileImage,
          'gender': args.gender,
          'age': args.age,
          'number': args.number,
          'birthday': args.birthday,
          'school': args.school,
          'schoolCode': args.schoolCode,
          'schoolOrg': args.schoolOrg,
          'grade': args.grade,
          'group': args.group,
          'eyes': args.eyes,
          'mbti': args.mbti,
          'hobby': args.hobby,
          "style": args.style,
          'isSubscribe': args.isSubscribe,
          'candyCount': args.candyCount,
          'recentDailyBonusReceiveDate': args.recentDailyBonusReceiveDate,
          'recentQuestionBonusReceiveDate': args.recentQuestionBonusReceiveDate,
          'questionInfos': args.questionInfos,
          'answeredQuestions': args.answeredQuestions,
          'currentQuestionId': args.currentQuestionId,
          'serviceNeedsAgreement': args.serviceNeedsAgreement,
          'privacyNeedsAgreement': args.privacyNeedsAgreement,
        });

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
        final newUser = await _authentication.createUserWithEmailAndPassword(
            email: user.kakaoAccount!.email.toString(),
            password: user.id.toString());

        final uid = newUser.user!.uid.toString();
        print(uid);

        final userRef = FirebaseFirestore.instance.collection('users');

        await userRef.doc(uid).set({
          'uid': uid,
          "name": args.name,
          "profileImage": args.profileImage,
          'gender': args.gender,
          'age': args.age,
          'number': args.number,
          'birthday': args.birthday,
          'school': args.school,
          'schoolCode': args.schoolCode,
          'schoolOrg': args.schoolOrg,
          'grade': args.grade,
          'group': args.group,
          'eyes': args.eyes,
          'mbti': args.mbti,
          'hobby': args.hobby,
          "style": args.style,
          'isSubscribe': args.isSubscribe,
          'candyCount': args.candyCount,
          'recentDailyBonusReceiveDate': args.recentDailyBonusReceiveDate,
          'recentQuestionBonusReceiveDate': args.recentQuestionBonusReceiveDate,
          'questionInfos': args.questionInfos,
          'answeredQuestions': args.answeredQuestions,
          'currentQuestionId': args.currentQuestionId,
          'serviceNeedsAgreement': args.serviceNeedsAgreement,
          'privacyNeedsAgreement': args.privacyNeedsAgreement,
        });

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
                              fontSize: 16,
                              color: Color.fromRGBO(51, 61, 75, 0.6)),
                        ),
                      ),
                      Text(
                        " ${args.name}님,",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                            color: Color.fromARGB(255, 51, 61, 75)),
                      ),
                      Text(
                        "환영합니다!",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                            color: Color.fromARGB(255, 51, 61, 75)),
                      ),
                    ]))))));
  }
}
