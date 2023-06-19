// 2023.06.19 MON Midas: ✅
// 코드 효율성 점검: ✅
// 예외처리: ✅
// 중복 서버 송수신 방지: ✅

import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:cooing_front/model/data/my_user.dart';
import 'package:cooing_front/model/response/response.dart' as r;
import 'package:cooing_front/model/response/user.dart';
import 'package:cooing_front/pages/tab_page.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart' as kakao;
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late BuildContext scaffoldContext;
  String uid = '';
  String email = '';
  String name = '';
  String profileImage = '';
  bool isLoading = false;
  bool isKakaoClicked = false;

  @override
  Widget build(BuildContext context) {
    scaffoldContext = context;

    return WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
            ),
            backgroundColor: Color(0xFFffffff),
            body: Container(
                padding:
                const EdgeInsets.only(left: 20, right: 20, bottom: 20).r,
                child: Form(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "당신을 몰래 좋아하는",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 22.sp,
                              color: Color.fromARGB(255, 51, 61, 75)),
                        ),
                        Text(
                          "사람은 누굴까요?",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 22.sp,
                              color: Color.fromARGB(255, 51, 61, 75)),
                        ),
                        Spacer(),
                        _kakaoLoginButton(),
                        SizedBox(
                          height: 20.h,
                        ),
                        if (!Platform.isAndroid) _appleLoginButton(),
                      ]),
                ))));
  }

  // 카카오톡으로 로그인하기
  void signInWithKakao() async {
    setState(() {
      isLoading = true;
      isKakaoClicked = true;
    });

    try {
      // 카카오톡 로그인

      bool isInstalled = await kakao.isKakaoTalkInstalled(); // 카카오앱 설치 여부 확인
      isInstalled
          ? await kakao.UserApi.instance.loginWithKakaoTalk()
          : await kakao.UserApi.instance.loginWithKakaoAccount();

      kakao.User user = await kakao.UserApi.instance.me();

      uid = user.id.toString();
      email = user.kakaoAccount?.email ?? '';
      name = '${user.kakaoAccount?.profile?.nickname}';
      profileImage = '${user.kakaoAccount?.profile?.profileImageUrl}';

      var bytes = utf8.encode(uid); // 비밀번호를 UTF-8 형식의 바이트 배열로 변환
      var digest = sha256.convert(bytes); // SHA-256 알고리즘을 사용하여 해시화
      String newPassword = digest.toString();

      // 파이어베이스 로그인
      firebase.UserCredential userCredential = await firebase
          .FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: newPassword);

      await FlutterSecureStorage().write(key: 'userPlatform', value: 'kakao');
      print('카카오톡 로그인 성공 👋');
      Get.offAll(TabPage(isLinkEntered: false,), arguments: userCredential.user!.uid);
    } on kakao.KakaoAuthException catch (e) {
      setState(() {
        isLoading = false;
      });
      print('카카오 로그인 에러 - E: ${e.toString()}');
    } on firebase.FirebaseAuthException catch (e) {
      print('파이어베이스 로그인 에러 - E: ${e.toString()}');

      MyUser.userPlatform = 'kakao';
      User newUser = User(
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
          recentDailyBonusReceiveDate: '',
          recentQuestionBonusReceiveDate: '',
          questionInfos: [],
          answeredQuestions: [],
          currentQuestion: {},
          serviceNeedsAgreement: false,
          privacyNeedsAgreement: false);
      if (!mounted) return;
      Navigator.pushNamed(scaffoldContext, 'signUp', arguments: newUser);
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('알 수 없는 에러 - E: ${e.toString()}');
    }
  }

  // 애플로 로그인하기
  void signInWithApple() async {
    setState(() {
      isLoading = true;
      isKakaoClicked = false;
    });

    try {
      final appleCredential = await SignInWithApple.getAppleIDCredential(
          scopes: [
            AppleIDAuthorizationScopes.email,
            AppleIDAuthorizationScopes.fullName
          ]);

      // 로그인 권한 여부 체크
      // 애플 로그인 인증 후, 결과값으로 Firebase Authentication 데이터 넣는 작업
      final oAuthProvider = firebase.OAuthProvider('apple.com');
      final credential = oAuthProvider.credential(
        idToken: appleCredential.identityToken,
      );

      // Firebase Auth 로그인
      firebase.UserCredential authResult = await firebase.FirebaseAuth.instance
          .signInWithCredential(credential);

      // null 예외 처리 ✅
      firebase.User? firebaseUser = authResult.user;

      // 만약, firebaseUser 값이 있다면
      if (firebaseUser != null) {
        var bytes = utf8.encode(
            appleCredential.userIdentifier!); // 비밀번호를 UTF-8 형식의 바이트 배열로 변환
        var digest = sha256.convert(bytes); // SHA-256 알고리즘을 사용하여 해시화
        String newPassword = digest.toString();
        await firebase.FirebaseAuth.instance.currentUser!
            .updatePassword(newPassword);

        // null 예외 처리 ✅
        // 유저 정보 읽기
        User? appleUserInDB =
        await r.Response.readUser(userUid: firebaseUser.uid);

        if (appleUserInDB == null) {
          // 만약, FirebaseDB에 Apple 유저 정보가 없다면

          MyUser.userPlatform = 'apple';
          MyUser.userId = appleCredential.userIdentifier!;
          MyUser.appleUserUid = firebaseUser.uid;
          MyUser.appleUserEmail = firebaseUser.email!;
          User newUser = User(
            uid: firebaseUser.uid,
            name: 'apple',
            profileImage: getRandomProfile(),
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
            recentDailyBonusReceiveDate: '',
            recentQuestionBonusReceiveDate: '',
            questionInfos: [],
            answeredQuestions: [],
            currentQuestion: {},
            serviceNeedsAgreement: false,
            privacyNeedsAgreement: false);

          if (!mounted) return;
          Navigator.pushNamed(
            scaffoldContext,
            'signUp',
            arguments: newUser
          );
        } else {
          // 만약, FirebaseDB에 Apple 유저 정보가 있다면

          // Store user Id (자동로그인을 위한 인증된 user 정보 저장)
          await FlutterSecureStorage()
              .write(key: "userId", value: appleCredential.userIdentifier!);
          await FlutterSecureStorage()
              .write(key: "userPlatform", value: 'apple');
          await FlutterSecureStorage()
              .write(key: "appleUserEmail", value: firebaseUser.email);
          await FlutterSecureStorage()
              .write(key: "appleUserUid", value: firebaseUser.uid);
          print('애플 로그인 성공 👋');
          Get.offAll(TabPage(isLinkEntered: false,), arguments: firebaseUser.uid);
        }
      }else{
        setState(() {
          isLoading = false;
        });
      }
    } on firebase.FirebaseAuthException catch (e) {
      setState(() {
        isLoading = false;
      });

      print('파이어베이스 로그인 에러 - E: $e');
    } catch (e) {
      setState(() {
        isLoading = false;
      });

      print('애플 로그인 에러 - E: $e');
    }
  }

// Func: 랜덤 프로필 이미지 가져오는 함수
  String getRandomProfile() {
    String result = '';

    List<String> profileURLs = [
      'https://firebasestorage.googleapis.com/v0/b/team-cooing.appspot.com/o/user.png?alt=media&token=4e727797-8f8d-421d-a64c-9d5f8963598d',
      'https://firebasestorage.googleapis.com/v0/b/team-cooing.appspot.com/o/user%20(1).png?alt=media&token=34fc54dd-5ecd-4d45-a379-9480b1d3a54c',
      'https://firebasestorage.googleapis.com/v0/b/team-cooing.appspot.com/o/user%20(2).png?alt=media&token=44a4be66-ab68-4abd-9e46-e94a1d1a8134',
      'https://firebasestorage.googleapis.com/v0/b/team-cooing.appspot.com/o/user%20(3).png?alt=media&token=b68aaaca-27b9-4a48-839d-56958038d5e9',
      'https://firebasestorage.googleapis.com/v0/b/team-cooing.appspot.com/o/user%20(4).png?alt=media&token=a5ff7899-1e7c-4643-84bf-a71441db4046',
      'https://firebasestorage.googleapis.com/v0/b/team-cooing.appspot.com/o/user%20(5).png?alt=media&token=a0d83156-2866-4eaf-bf33-7a6cf52585ec',
    ];

    result = profileURLs[Random().nextInt(profileURLs.length)];

    return result;
  }

// UI: 애플 로그인 버튼
  Widget _appleLoginButton() {
    return GestureDetector(
      onTap: () {
        if(!isLoading){
          signInWithApple();
        }
      },
      child: Container(
        alignment: Alignment.center,
        width: double.infinity,
        height: 60.h,
        decoration: BoxDecoration(
            color: Color(0XFF000000), borderRadius: BorderRadius.circular(12)),
        child: isLoading == true && isKakaoClicked == false
            ? SizedBox(
          height: 20.h,
          width: 20.w,
          child: CircularProgressIndicator(
            color: Colors.white,
            strokeWidth: 3,
          ),
        )
            :GestureDetector(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/apple_symbol.png',
                height: 20.h,
              ),
              SizedBox(
                width: 10.w,
              ),
              Text(
                'Apple로 로그인 ',
                style: TextStyle(fontSize: 15.sp, color: Colors.white),
              )
            ],
          ),
        ),
      ),
    );
  }

// UI: 카카오 로그인 버튼
  Widget _kakaoLoginButton() {
    return GestureDetector(
      onTap: () {
        if(!isLoading){
          signInWithKakao();
        }
      },
      child: Container(
        alignment: Alignment.center,
        width: double.infinity,
        height: 60.h,
        decoration: BoxDecoration(
            color: Color(0XFFFEE500), borderRadius: BorderRadius.circular(12)),
        child: isLoading == true && isKakaoClicked == true
            ? SizedBox(
          height: 20.h,
          width: 20.w,
          child: CircularProgressIndicator(
            color: Colors.black.withOpacity(0.85),
            strokeWidth: 3,
          ),
        )
            : GestureDetector(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/kakao_symbol.png',
                height: 20.h,
              ),
              SizedBox(
                width: 10.w,
              ),
              Text(
                '카카오 로그인 ',
                style: TextStyle(
                    fontSize: 15.sp,
                    color: Colors.black.withOpacity(0.85)),
              )
            ],
          ),
        ),
      ),
    );
  }
}
