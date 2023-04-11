import 'package:cooing_front/model/User.dart';
import 'package:cooing_front/pages/FeatureScreen.dart';
import 'package:cooing_front/pages/SchoolScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'CandyScreen.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  final List settingElements = [
    {
      'title': '인스타 팔로우',
      'link': '',
    },
    {
      'title': '질문을 공유하는 방법',
      'link': '',
    },
    {
      'title': '문의 및 피드백',
      'link': '',
    },
    {
      'title': '이용약관',
      'link': '',
    },
    {
      'title': '개인정보처리방침',
      'link': '',
    },
    {
      'title': '로그아웃',
      'link': '',
    },
  ];

  @override
  Widget build(BuildContext context) {
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
                                    "5개",
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: Color(0xff333D4B),
                                        fontWeight: FontWeight.bold),
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
                        child: Text(
                          "${settingElements[index]['title']}",
                          style: TextStyle(
                              fontSize: 16,
                              color: Color(0xff333D4B),
                              fontWeight: FontWeight.bold),
                        ),
                      );
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