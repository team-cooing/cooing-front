import 'dart:convert';
import 'dart:io';
import 'package:cooing_front/model/response/User.dart';
import 'package:cooing_front/model/firebase_auth_remote_data_source.dart';
import 'package:cooing_front/pages/login/FeatureScreen.dart';
import 'package:cooing_front/pages/login/SchoolScreen.dart';
import 'package:cooing_front/pages/WelcomeScreen.dart';
import 'package:cooing_front/providers/UserProvider.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart' as kakao;
import 'package:cloud_firestore/cloud_firestore.dart';

class MultiSelectscreen extends StatefulWidget {
  const MultiSelectscreen({super.key});
  @override
  _MultiSelectscreenState createState() => _MultiSelectscreenState();
}

class _MultiSelectscreenState extends State<MultiSelectscreen> {
  final _authentication = firebase.FirebaseAuth.instance;
  List<String> _styleList = [];
  List<Style> style = new List.empty(growable: true);
  List<Hobby> hobby = new List.empty(growable: true);

  List<Style> femaleStyle = new List.empty(growable: true);
  List<Style> maleStyle = new List.empty(growable: true);

  final List<String> _textList = [
    '좋아하는 취미는?',
    '나는 OOO 스타일?',
  ];

  int title = 0;
  int count = 0;
  bool _style = false;
  bool button = false;
  bool selectAll = false;
  String _hobby = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // _userDataProvider = UserDataProvider();
    // _loadData();

    // if (_gender == 0) {
    maleStyle.add(Style('귀여운', false));
    maleStyle.add(Style('잘생긴', false));
    maleStyle.add(Style('어른스러운', false));
    maleStyle.add(Style('상냥한', false));
    maleStyle.add(Style('훈훈한', false));
    maleStyle.add(Style('댕댕이 같은', false));
    maleStyle.add(Style('애교 많은', false));
    maleStyle.add(Style("배려 있는", false));
    maleStyle.add(Style("듬직한", false));
    maleStyle.add(Style("매너 있는", false));
    maleStyle.add(Style("순진한", false));
    maleStyle.add(Style("호감형인", false));
    // }
    // if (_gender == 1) {
    femaleStyle.add(Style('귀여운', false));
    femaleStyle.add(Style('예쁜', false));
    femaleStyle.add(Style('해맑은', false));
    femaleStyle.add(Style('상큼한', false));
    femaleStyle.add(Style('사랑스러운', false));
    femaleStyle.add(Style('훈훈한', false));
    femaleStyle.add(Style('다정한', false));
    femaleStyle.add(Style("청순한", false));
    femaleStyle.add(Style("애교 많은", false));
    femaleStyle.add(Style("마음 여린", false));
    femaleStyle.add(Style("순진한", false));
    femaleStyle.add(Style("호감형인", false));
    // }

    hobby.add(Hobby('영화', '\u{1F37F}', false));
    hobby.add(Hobby('운동', '\u{26BD}', false));
    hobby.add(Hobby('카페', '\u{2615}', false));
    hobby.add(Hobby('공부', '\u{270D}', false));
    hobby.add(Hobby('음악감상', '\u{1F3B6}', false));
    hobby.add(Hobby('여행', '\u{1F6E9}', false));
    hobby.add(Hobby('웹툰', '\u{1F5EF}', false));
    hobby.add(Hobby("춤", '\u{1F483}', false));
    hobby.add(Hobby("노래", '\u{1F3A4}', false));
    hobby.add(Hobby("토크", '\u{1F5E3}', false));
    hobby.add(Hobby("책", '\u{1F4DA}', false));
    hobby.add(Hobby("게임", '\u{1F3AE}', false));
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as User;
    if (args.gender == 0) {
      style = maleStyle;
    }
    if (args.gender == 1) {
      style = femaleStyle;
    }
    // if (args.gender == 0) {
    //   style.add(Style('귀여운', false));
    //   style.add(Style('잘생긴', false));
    //   style.add(Style('어른스러운', false));
    //   style.add(Style('상냥한', false));
    //   style.add(Style('훈훈한', false));
    //   style.add(Style('댕댕이 같은', false));
    //   style.add(Style('애교 많은', false));
    //   style.add(Style("배려 있는", false));
    //   style.add(Style("듬직한", false));
    //   style.add(Style("매너 있는", false));
    //   style.add(Style("순진한", false));
    //   style.add(Style("호감형인", false));
    // }
    // if (args.gender == 1) {
    //   style.add(Style('귀여운', false));
    //   style.add(Style('예쁜', false));
    //   style.add(Style('해맑은', false));
    //   style.add(Style('상큼한', false));
    //   style.add(Style('사랑스러운', false));
    //   style.add(Style('훈훈한', false));
    //   style.add(Style('다정한', false));
    //   style.add(Style("청순한", false));
    //   style.add(Style("애교 많은", false));
    //   style.add(Style("마음 여린", false));
    //   style.add(Style("순진한", false));
    //   style.add(Style("호감형인", false));
    // }

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        backgroundColor: Color(0xFFffffff),
        body: SingleChildScrollView(
            child: Column(children: [
          Container(
              padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _textList[title],
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                          color: Color.fromARGB(255, 51, 61, 75)),
                    ),
                    AnimatedOpacity(
                        opacity: _style ? 1.0 : 0.0,
                        duration: const Duration(milliseconds: 500),
                        child: Visibility(
                          visible: _style,
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.only(
                                      top: 40, bottom: 10),
                                  child: Text(
                                    '스타일',
                                    style: TextStyle(
                                        fontSize: 20,
                                        color: Color.fromARGB(255, 51, 61, 75)),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.only(bottom: 10),
                                  child: Text(
                                    '3개를 선택해주세요.',
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: Color.fromRGBO(51, 61, 75, 0.4)),
                                  ),
                                ),
                                SafeArea(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      GridView.builder(
                                        shrinkWrap: true,
                                        physics: NeverScrollableScrollPhysics(),
                                        itemBuilder: (ctx, index) {
                                          return prepareStyle(index);
                                        },
                                        gridDelegate:
                                            SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 3,
                                          crossAxisSpacing: 10,
                                          mainAxisSpacing: 10,
                                        ),
                                        itemCount: style.length,
                                      ),
                                    ],
                                  ),
                                ),
                              ]),
                        )),
                    Container(
                      padding: const EdgeInsets.only(top: 40, bottom: 20),
                      child: Text(
                        '취미',
                        style: TextStyle(
                            fontSize: 20,
                            color: Color.fromARGB(255, 51, 61, 75)),
                      ),
                    ),
                    SafeArea(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          GridView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemBuilder: (ctx, index) {
                              return prepareHobby(index);
                            },
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                            ),
                            itemCount: style.length,
                          ),
                        ],
                      ),
                    ),
                  ]))
        ])),
        bottomNavigationBar: AnimatedOpacity(
            opacity: button ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 1000),
            child: Visibility(
              visible: button,
              child: Padding(
                padding: EdgeInsets.all(20),
                child: SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: Color.fromARGB(255, 151, 84, 251)),
                      child: const Text('확인',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15)),
                      onPressed: () async {
                        for (int i = 0; i < style.length; i++) {
                          if (style[i].selected) {
                            _styleList.add(style[i].name);
                          }

                          for (int i = 0; i < hobby.length; i++) {
                            if (hobby[i].selected) {
                              _hobby = hobby[i].title;
                            }
                          }
                          print(_styleList);

                          Navigator.pushNamed(
                            context,
                            'agree',
                            arguments: User(
                              uid: args.uid,
                              name: args.name,
                              profileImage: args.profileImage,
                              gender: args.gender,
                              number: args.number,
                              age: args.age,
                              birthday: args.birthday,
                              school: args.school,
                              schoolCode: args.schoolCode,
                              schoolOrg: args.schoolOrg,
                              grade: args.grade,
                              group: args.group,
                              eyes: args.eyes,
                              mbti: args.mbti,
                              hobby: _hobby,
                              style: _styleList,
                              isSubscribe: args.isSubscribe,
                              candyCount: args.candyCount,
                              questionInfos: args.questionInfos,
                              answeredQuestions: args.answeredQuestions,
                              serviceNeedsAgreement: args.serviceNeedsAgreement,
                              privacyNeedsAgreement: args.privacyNeedsAgreement,
                            ),
                          );
                        }
                      }),
                ),
              ),
            )));
  }

  Widget prepareHobby(int k) {
    return Card(
      child: Hero(
        tag: "hobby$k",
        child: Material(
          child: InkWell(
              borderRadius: BorderRadius.all(Radius.circular(5.0)),
              onTap: () {},
              child: hobby[k].selected
                  ? GestureDetector(
                      onTap: () {
                        setState(() {
                          // hobby[k].selected = !hobby[k].selected;

                          // The button that is tapped is set to true, and the others to false.
                          for (int i = 0; i < hobby.length; i++) {
                            hobby[i].selected = i == k;
                          }
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 1.5,
                            color: Color.fromRGBO(151, 84, 251, 1),
                          ),
                          color: Color.fromRGBO(151, 84, 251, 0.2),
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        ),
                        child: Stack(
                          children: [
                            Center(
                                child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  hobby[k].icon,
                                  style: TextStyle(
                                      color: Color.fromRGBO(51, 61, 75, 1),
                                      fontSize: 28),
                                ),
                                Text(
                                  hobby[k].title,
                                  style: TextStyle(
                                      color: Color.fromRGBO(151, 84, 251, 1),
                                      fontSize: 17),
                                ),
                              ],
                            ))
                          ],
                        ),
                      ),
                    )
                  : GestureDetector(
                      onTap: () {
                        setState(() {
                          for (int i = 0; i < hobby.length; i++) {
                            hobby[i].selected = i == k;
                          }
                          title = 1;
                          _style = true;
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 1.5,
                            color: Color.fromRGBO(51, 61, 71, 0.2),
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        ),
                        child: Stack(
                          children: [
                            Center(
                                child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  hobby[k].icon,
                                  style: TextStyle(
                                      color: Color.fromRGBO(51, 61, 75, 1),
                                      fontSize: 28),
                                ),
                                Text(
                                  hobby[k].title,
                                  style: TextStyle(
                                      color: Color.fromRGBO(51, 61, 75, 1),
                                      fontSize: 17),
                                ),
                              ],
                            ))
                          ],
                        ),
                      ))),
        ),
      ),
    );
  }

  Widget prepareStyle(int k) {
    return Card(
      child: Hero(
        tag: "style$k",
        child: Material(
          child: InkWell(
              borderRadius: BorderRadius.all(Radius.circular(5.0)),
              onTap: () {},
              child: style[k].selected
                  ? GestureDetector(
                      onTap: () {
                        setState(() {
                          if (style[k].selected) {
                            if (count != 0) {
                              count -= 1;
                              style[k].selected = !style[k].selected;
                            }
                          }
                          if (count != 3) {
                            button = false;
                          }

                          // The button that is tapped is set to true, and the others to false.
                          // for (int i = 0; i < hobby.length; i++) {
                          //   hobby[i].selected = i == k;
                          // }
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 1.5,
                            color: Color.fromRGBO(151, 84, 251, 1),
                          ),
                          color: Color.fromRGBO(151, 84, 251, 0.2),
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        ),
                        child: Stack(
                          children: [
                            Center(
                                child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  style[k].name,
                                  style: TextStyle(
                                      color: Color.fromRGBO(151, 84, 251, 1),
                                      fontSize: 17),
                                ),
                              ],
                            ))
                          ],
                        ),
                      ),
                    )
                  : GestureDetector(
                      onTap: () {
                        setState(() {
                          if (!style[k].selected) {
                            if (count < 3) {
                              count += 1;
                              style[k].selected = !style[k].selected;
                            }
                          }
                          if (count == 3) {
                            button = true;
                          }
                          // for (int i = 0; i < hobby.length; i++) {
                          //   hobby[i].selected = i == k;
                          // }
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 1.5,
                            color: Color.fromRGBO(51, 61, 71, 0.2),
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        ),
                        child: Stack(
                          children: [
                            Center(
                                child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  style[k].name,
                                  style: TextStyle(
                                      color: Color.fromRGBO(51, 61, 75, 1),
                                      fontSize: 17),
                                ),
                              ],
                            ))
                          ],
                        ),
                      ))),
        ),
      ),
    );
  }
}

class Style {
  String name;
  bool selected;
  Style(this.name, this.selected);
}

class Hobby {
  String title;
  String icon;
  bool selected;
  Hobby(
    this.title,
    this.icon,
    this.selected,
  );
}