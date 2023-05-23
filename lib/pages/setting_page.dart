import 'package:cooing_front/model/response/user.dart';
import 'package:cooing_front/providers/UserProvider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'CandyScreen.dart';

class SettingScreen extends StatefulWidget {
  User user;

  SettingScreen({required this.user, super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
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
                          onPressed: () async {
                            await Navigator.of(context).push(MaterialPageRoute(
                              builder: (BuildContext context) => CandyScreen(
                                user: widget.user,
                              ),
                            ));

                            setState(() {});
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
                              final reportUrl = Uri.parse(
                                  "${settingElements[index]['link']}");
                              print("${settingElements[index]['title']}");

                              if (await canLaunchUrl(reportUrl)) {
                                launchUrl(reportUrl);
                              } else {
                                // ignore: avoid_print
                                print("Can't launch $reportUrl");
                              }
                            },
                          ));
                    })),
              ],
            ),
          ),
          Padding(
              padding: EdgeInsets.only(left: 25.0),
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
              ))
        ],
      ),
    );
  }
}
