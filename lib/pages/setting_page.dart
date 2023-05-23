import 'package:cooing_front/model/response/user.dart' as ru;
import 'package:cooing_front/model/response/response.dart' as r;
import 'package:cooing_front/pages/login/LoginScreen.dart';
import 'package:cooing_front/providers/UserProvider.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'CandyScreen.dart';

class SettingScreen extends StatefulWidget {
  final ru.User user;

  const SettingScreen({required this.user, super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  late BuildContext scaffoldContext;
  final List settingElements = [
    {
      'title': '인스타 팔로우',
      'link': '',
    },
    {
      'title': '질문을 공유하는 방법',
      'link': 'https://we-cooing.notion.site/e802f6eaf1594ff6bd01dbd5ddcc3396',
    },
    {
      'title': '문의 및 피드백',
      'link': 'https://pf.kakao.com/_kexoDxj',
    },
    {
      'title': '이용약관',
      'link': 'https://we-cooing.notion.site/9a8b8ef68b964b5881c57ce50657854d',
    },
    {
      'title': '개인정보처리방침',
      'link': 'https://we-cooing.notion.site/909def3b7b194ac48fabe0f142f60176',
    },
    {
      'title': '로그아웃',
      'link': '',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserDataProvider>(context, listen: true);
    scaffoldContext = context;

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            child: SizedBox(
              width: double.infinity,
              height: 90.0,
              child: Container(
                padding: EdgeInsets.all(25.0),
                decoration: BoxDecoration(
                    color: Color(0xffF2F3F3),
                    borderRadius: BorderRadius.circular(20)),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              SizedBox(
                                  width: 25.0,
                                  height: 25.0,
                                  child: Image(
                                      image: AssetImage('images/candy1.png'))),
                              Padding(padding: EdgeInsets.only(right: 10.0)),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "내가 가진 캔디",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Color(0xff333D4B),
                                    ),
                                  ),
                                  Text(
                                    '${widget.user.candyCount}개',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Color(0xff333D4B),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              )
                            ],
                          )
                        ],
                      ),
                      ElevatedButton(
                          onPressed: () {
                            Get.to(CandyScreen());
                          },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.white,
                            shadowColor: Colors.transparent,
                            backgroundColor: Color.fromRGBO(151, 84, 251, 1),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0)),
                          ),
                          child: const Text(
                            "채우기",
                            style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ))
                    ]),
              ),
            ),
          ),
          SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: Column(
              children: [
                ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: settingElements.length,
                    shrinkWrap: true,
                    itemBuilder: ((context, index) {
                      return Padding(
                          padding: EdgeInsets.only(
                              left: 25.0, bottom: 20.0, top: 20.0),
                          child: GestureDetector(
                            child: Text(
                              "${settingElements[index]['title']}",
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Color(0xff333D4B),
                                  fontWeight: FontWeight.bold),
                            ),
                            onTap: () async {
                              // 만약, 로그아웃이 아니라면
                              if (index != settingElements.length - 1) {
                                final reportUrl = Uri.parse(
                                    "${settingElements[index]['link']}");
                                print("${settingElements[index]['title']}");

                                if (await canLaunchUrl(reportUrl)) {
                                  launchUrl(reportUrl);
                                } else {
                                  // ignore: avoid_print
                                  print("Can't launch $reportUrl");
                                }
                              } else {
                                await logout();
                                // 로그인 페이지로 이동
                                if (!mounted) return;
                                Navigator.of(scaffoldContext)
                                    .pushAndRemoveUntil(
                                        MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                LoginScreen()),
                                        (route) => false);
                              }
                            },
                          ));
                    })),
              ],
            ),
          ),
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () async {
              await deleteUser();
              // 로그인 페이지로 이동
              if (!mounted) return;
              Navigator.of(scaffoldContext).pushAndRemoveUntil(
                  MaterialPageRoute(
                      builder: (BuildContext context) => LoginScreen()),
                  (route) => false);
            },
            child: Padding(
                padding: EdgeInsets.only(left: 25.0, top: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '회원 탈퇴',
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xffB6B7B8),
                      ),
                    ),
                    Padding(padding: EdgeInsets.all(5.0)),
                    Text(
                      '탈퇴한 뒤에는 데이터를 복구할 수 없으니 신중히 진행해 주세요.',
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xffB6B7B8),
                      ),
                    ),
                  ],
                )),
          )
        ],
      ),
    );
  }

  Future logout() async {
    // 카카오, 파베 로그아웃
    try {
      await UserApi.instance.logout();
      await fb.FirebaseAuth.instance.signOut();
    } catch (e) {
      print(e.toString());
    }
    // 토큰 정보 제거
    try {
      await TokenManagerProvider.instance.manager.clear();
    } catch (e) {
      print(e.toString());
    }
  }

  Future deleteUser() async {
    // 파베 유저 데이터 관련 정보 삭제 - 유저 데이터, 피드 데이터 삭제
    await r.Response.deleteUser(userUid: widget.user.uid);
    await r.Response.deleteQuestionInFeed(
        schoolCode: widget.user.schoolCode,
        questionId: widget.user.questionInfos[widget.user.questionInfos.length-1]['questionId']);
    // 카카오 회원 정보 삭제
    try {
      await UserApi.instance.unlink();
    } catch (e) {
      print(e.toString());
    }
    // 토큰 정보 제거
    try {
      await TokenManagerProvider.instance.manager.clear();
    } catch (e) {
      print(e.toString());
    }
    // 파베 Auth 회원 정보 삭제
    try{
      fb.User? firebaseUser = fb.FirebaseAuth.instance.currentUser;
      if(firebaseUser!=null){
        await firebaseUser.delete();
      }
    }catch(e){
      print(e.toString());
    }
  }
}
