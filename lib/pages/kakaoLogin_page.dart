import 'package:cooing_front/model/Login_platform.dart';
import 'package:cooing_front/pages/signup_page.dart';
import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';

class KakaoLoginPage extends StatefulWidget {
  const KakaoLoginPage({super.key});

  @override
  _KakaoLoginPageState createState() => _KakaoLoginPageState();
}

class _KakaoLoginPageState extends State<KakaoLoginPage> {
  LoginPlatform _loginPlatform = LoginPlatform.none;

  void signInWithKakao() async {
    try {
      bool isInstalled = await isKakaoTalkInstalled();

      OAuthToken token = isInstalled
          ? await UserApi.instance.loginWithKakaoTalk()
          : await UserApi.instance.loginWithKakaoAccount();

      //   final url = Uri.https('kapi.kakao.com', '/v2/user/me');

      //   final response = await http.get(
      //     url,
      //     headers: {
      //       HttpHeaders.authorizationHeader: 'Bearer ${token.accessToken}'
      //     },
      //   );

      //   final profileInfo = json.decode(response.body);
      //   print(profileInfo.toString());

      //   setState(() {
      //     _loginPlatform = LoginPlatform.kakao;
      //   });
    } catch (error) {
      print('카카오톡으로 로그인 실패 $error');
    }
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
              SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    child: Image.asset('images/kakao_login_medium_wide.png'),
                    onPressed: () {
                      signInWithKakao();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SignUpPage()),
                      );
                    },
                  ))
            ]),
          ),
        ));
  }
}
