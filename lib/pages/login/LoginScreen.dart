import 'dart:io';
import 'dart:math';
import 'package:cooing_front/model/response/response.dart' as r;
import 'package:cooing_front/model/response/user.dart';
import 'package:cooing_front/pages/tab_page.dart';
import 'package:get/get.dart';
import 'package:cooing_front/model/util/Login_platform.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart' as kakao;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late BuildContext scaffoldContext;
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

  // TODO: Apple Login
  void signInWithApple() async {
    try {
      // Apple Credential 받기
      final appleCredential = await SignInWithApple.getAppleIDCredential(
          scopes: [
            AppleIDAuthorizationScopes.email,
            AppleIDAuthorizationScopes.fullName
          ]);

      // OAuth Credential 생성
      final oauthCredential = firebase.OAuthProvider("apple.com").credential(
        idToken: appleCredential.identityToken,
      );

      // Firebase Credential 받기
      final userCredential = await firebase.FirebaseAuth.instance
          .signInWithCredential(oauthCredential);

      // 만약, appleSignInUser가 있다면
      final appleSignInUser = userCredential.user;
      if (appleSignInUser != null) {
        final appleSignInUserInDB =
            await r.Response.readUser(userUid: appleSignInUser.uid);
        print(appleSignInUserInDB);
        // 만약, DB에 User가 없다면
        if (appleSignInUserInDB == null) {
          print('Apple Login - Not User in DB');
          if (!mounted) return;
          Navigator.pushNamed(
            scaffoldContext,
            'signUp',
            arguments: User(
              uid: appleSignInUser.uid,
              name: 'apple_{appleCredential.identityToken}',
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
              currentQuestionId: '',
              serviceNeedsAgreement: false,
              privacyNeedsAgreement: false,
            ),
          );
        } else {
          // 애플 로그인 토큰 저장
          SharedPreferences prefs = await SharedPreferences.getInstance();
          String token = appleCredential.identityToken.toString();
          await prefs.setString('apple_login_token', token);
          print('Apple Login token saved: $token');
          Get.offAll(TabPage(), arguments: appleSignInUser.uid);
        }
      }
    } catch (e) {
      // 로그인 실패 시 예외 처리를 수행합니다.
      print('Apple 로그인 실패: $e');
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
            recentDailyBonusReceiveDate: '',
            recentQuestionBonusReceiveDate: '',
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
    scaffoldContext = context;

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
                    _kakaoLoginButton(),
                    SizedBox(
                      height: 20,
                    ),
                    _appleLoginButton(),
                  ]),
            )));
  }

  Widget _appleLoginButton() {
    return GestureDetector(
      onTap: () {
        signInWithApple();
      },
      child: Container(
        alignment: Alignment.center,
        width: double.infinity,
        height: 60,
        decoration: BoxDecoration(
            color: Color(0XFF000000), borderRadius: BorderRadius.circular(12)),
        child: GestureDetector(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'images/apple_symbol.png',
                height: 20,
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                'Apple로 로그인 ',
                style: TextStyle(fontSize: 15, color: Colors.white),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _kakaoLoginButton() {
    return GestureDetector(
      onTap: () {
        signInWithKakao();
      },
      child: Container(
        alignment: Alignment.center,
        width: double.infinity,
        height: 60,
        decoration: BoxDecoration(
            color: Color(0XFFFEE500), borderRadius: BorderRadius.circular(12)),
        child: GestureDetector(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'images/kakao_symbol.png',
                height: 20,
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                '카카오 로그인 ',
                style: TextStyle(
                    fontSize: 15, color: Colors.black.withOpacity(0.85)),
              )
            ],
          ),
        ),
      ),
    );
  }

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
}
