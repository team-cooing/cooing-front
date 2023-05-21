import 'package:cooing_front/model/response/user.dart';
import 'package:cooing_front/pages/CandyScreen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:cooing_front/model/response/user.dart';
import 'package:cooing_front/model/response/response.dart';

class HintScreen extends StatefulWidget {
  final User user;

  const HintScreen({required this.user, super.key});

  @override
  State<HintScreen> createState() => _HintScreenState();
}

class _HintScreenState extends State<HintScreen> {
  @override
  void initState() {
    super.initState();
  }

  int candy = 10;

  bool hint1 = true;
  bool hint2 = false;
  bool hint3 = false;

  bool goldenCandy = true;
  // List<String> getHint(User user);

  List<String> getHint = ['1~6반 사이', '초성에 받침이 2개', '강아지 상'];
  List<bool> openHint = [false, false, false];

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: BackButton(color: Color.fromRGBO(51, 61, 75, 1)),
        elevation: 0,
      ),
      backgroundColor: Color(0xFFffffff),
      body: Container(
        padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
        child: Form(
          child: Center(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Container(
                    child: Text(
                  "힌트보기",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                      color: Color.fromARGB(255, 51, 61, 75)),
                )),
                Padding(padding: EdgeInsets.all(15.0)),
                Text(
                  "내가 가진 캔디",
                  style: TextStyle(
                      fontSize: 12, color: Color.fromRGBO(51, 61, 75, 1)),
                ),
                Container(
                  padding: EdgeInsets.only(bottom: 15.0),
                  decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(
                              width: 1.0,
                              color: Color.fromRGBO(217, 217, 217, 1)))),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "${candy}개",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 22,
                              color: Color.fromARGB(255, 51, 61, 75)),
                        ),
                        ElevatedButton(
                            onPressed: () {
                              Get.to(CandyScreen(user: widget.user));
                            },
                            style: OutlinedButton.styleFrom(
                              shadowColor: Colors.transparent,
                              foregroundColor: Colors.white,
                              backgroundColor: Color.fromRGBO(242, 243, 243, 1),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0)),
                            ),
                            child: const Text(
                              "채우기",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Color.fromRGBO(151, 84, 251, 1),
                              ),
                            ))
                      ]),
                ),
                Padding(padding: EdgeInsets.all(15.0)),
                AnimatedOpacity(
                  opacity: hint1 ? 1 : 0.6,
                  duration: Duration(milliseconds: 1),
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
                                Text(
                                  openHint[0] ? getHint[0] : "첫번째 힌트",
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: Color(0xff333D4B),
                                      fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                            ElevatedButton(
                                onPressed: () {
                                  if (goldenCandy) {
                                    if (hint1) {
                                      setState(() {
                                        hint1 = false;
                                        hint2 = true;
                                        openHint[0] = true;
                                      });
                                    }
                                  } else {
                                    setState(() {
                                      if (hint1) {
                                        if (candy >= 3) {
                                          candy -= 3;
                                          hint1 = false;
                                          hint2 = true;
                                          openHint[0] = true;
                                        } else {
                                          Get.to(
                                              CandyScreen(user: widget.user));
                                        }
                                      }
                                    });
                                  }
                                },
                                style: OutlinedButton.styleFrom(
                                  shadowColor: Colors.transparent,
                                  foregroundColor: Colors.white,
                                  backgroundColor:
                                      Color.fromRGBO(151, 84, 251, 1),
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(10.0)),
                                ),
                                child: Text(
                                  goldenCandy ? '황금 캔디' : "캔디 3개",
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ))
                          ]),
                    ),
                  ),
                ),
                Padding(padding: EdgeInsets.all(10.0)),
                AnimatedOpacity(
                    opacity: hint2 ? 1 : 0.6,
                    duration: Duration(milliseconds: 1),
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
                                  Text(
                                    openHint[1] ? getHint[1] : "두번째 힌트",
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: Color(0xff333D4B),
                                        fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),
                              ElevatedButton(
                                  onPressed: () {
                                    if (goldenCandy) {
                                      if (hint2) {
                                        setState(() {
                                          hint2 = false;
                                          hint3 = true;
                                          openHint[1] = true;
                                        });
                                      }
                                    } else {
                                      setState(() {
                                        if (hint2) {
                                          if (candy >= 3) {
                                            candy -= 3;
                                            hint2 = false;
                                            hint3 = true;
                                            openHint[1] = true;
                                          } else {
                                            Get.to(
                                                CandyScreen(user: widget.user));
                                          }
                                        }
                                      });
                                    }
                                  },
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: Colors.white,
                                    shadowColor: Colors.transparent,
                                    backgroundColor:
                                        Color.fromRGBO(151, 84, 251, 1),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0)),
                                  ),
                                  child: Text(
                                    goldenCandy ? '황금 캔디' : "캔디 3개",
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ))
                            ]),
                      ),
                    )),
                Padding(padding: EdgeInsets.all(10.0)),
                AnimatedOpacity(
                    opacity: hint3 ? 1 : 0.6,
                    duration: Duration(milliseconds: 1),
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
                                  Text(
                                    openHint[2] ? getHint[2] : "세번째 힌트",
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: Color(0xff333D4B),
                                        fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),
                              ElevatedButton(
                                  onPressed: () {
                                    if (goldenCandy) {
                                      if (hint3) {
                                        setState(() {
                                          hint3 = false;
                                          openHint[2] = true;
                                        });
                                      }
                                    } else {
                                      setState(() {
                                        if (hint3) {
                                          if (candy >= 3) {
                                            candy -= 3;
                                            hint3 = false;
                                            openHint[2] = true;
                                          } else {
                                            Get.to(
                                                CandyScreen(user: widget.user));
                                          }
                                        }
                                      });
                                    }
                                  },
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: Colors.white,
                                    shadowColor: Colors.transparent,
                                    backgroundColor:
                                        Color.fromRGBO(151, 84, 251, 1),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0)),
                                  ),
                                  child: Text(
                                    goldenCandy ? '황금 캔디' : "캔디 3개",
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ))
                            ]),
                      ),
                    ))
              ])),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(20),
        child: SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  primary: Color.fromARGB(255, 151, 84, 251)),
              child: const Text('확인',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
              onPressed: () {}),
        ),
      ),
    );
  }
}
