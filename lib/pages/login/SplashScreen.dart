import 'package:cooing_front/pages/tab_page.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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

  Future<void> _routePage() async {
    String initialRoute = 'home';
    String error = '';
    String newUserUid = '';
    String uid = '';

    try {
      final hasToken = await kakao.AuthApi.instance.hasToken();
      if (hasToken) {
        final tokenInfo = await kakao.UserApi.instance.accessTokenInfo();
        final user = await kakao.UserApi.instance.me();

        final email = user.kakaoAccount?.email ?? '';
        uid = user.id.toString();

        final newUser =
            await firebase.FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: uid,
        );

        newUserUid = newUser.user!.uid;

        initialRoute = 'tab';
        print('기기내 카카오 토큰으로 로그인 성공');
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
      error = 'network error';
    }

    await Future.delayed(Duration(seconds: 4));

    if (initialRoute == 'tab') {
      Get.offAll(TabPage(), arguments: newUserUid);
    } else {
      Navigator.pushReplacementNamed(context, initialRoute);
      if (error == 'network error') {
        print("네트워크 에러");
        networkDialog();
      }
    }
  }

  void networkDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              '네트워크 오류',
              style: TextStyle(
                fontSize: 14,
                color: Color(0xff333D4B),
                fontWeight: FontWeight.bold,
              ),
            ),
            content: Text(
              '네트워크를 확인하세요.',
              style: TextStyle(
                fontSize: 12,
                color: Color(0xff333D4B),
              ),
            ),
            actions: <Widget>[
              OutlinedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  shadowColor: Colors.transparent,
                  backgroundColor: Color.fromRGBO(151, 84, 251, 1),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                ),
                child: Text('확인'),
              ),
            ],
          );
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
