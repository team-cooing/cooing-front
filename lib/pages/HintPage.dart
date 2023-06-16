import 'package:cooing_front/model/response/answer.dart';
import 'package:cooing_front/model/response/user.dart';
import 'package:cooing_front/pages/CandyScreen.dart';
import 'package:cooing_front/providers/UserProvider.dart';
import 'package:flutter/material.dart';
import 'package:cooing_front/model/response/response.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HintScreen extends StatefulWidget {
  final User user;
  final Answer answer;
  final Map<String, dynamic>? hint;
  final String targetKey;
  final dynamic? targetValue;

  const HintScreen(
      {required this.user,
      required this.answer,
      required this.hint,
      required this.targetValue,
      required this.targetKey,
      super.key});

  @override
  State<HintScreen> createState() => _HintScreenState();
}

class _HintScreenState extends State<HintScreen> {
  late List<bool> openHint;
  late bool goldenCandy;
  UserDataProvider userProvider = UserDataProvider();

  @override
  void initState() {
    super.initState();
    print('-----');
    print(widget.hint);
    openHint = [
      widget.targetValue['is_hint_openeds'][0],
      widget.targetValue['is_hint_openeds'][1],
      widget.targetValue['is_hint_openeds'][2],
    ];
    print(openHint);
    widget.answer.isOpenedHint;
    goldenCandy = widget.user.isSubscribe;
  }

  // List<String> getHint(User user);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            leading: BackButton(
              color: Color.fromRGBO(51, 61, 75, 1),
              onPressed: () async {
                widget.hint![widget.targetKey] = {"is_hint_openeds": openHint};
                widget.targetValue['is_hint_openeds'][0] = openHint[0];
                widget.targetValue['is_hint_openeds'][1] = openHint[1];
                widget.targetValue['is_hint_openeds'][2] = openHint[2];

                print(widget.hint);
                await Response.updateHint(
                    newHint: widget.hint!, ownerId: widget.user.uid);
                // widget.answer.isOpenedHint = openHint;
                // await Response.updateAnswer(newAnswer: widget.answer);
                await Response.updateUser(newUser: widget.user);
                userProvider.updateCandyCount(widget.user.candyCount);

                Navigator.of(context).pop();
                // setState(() {});
              },
            ),
            elevation: 0,
          ),
          backgroundColor: Color(0xFFffffff),
          body: Container(
            padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20).r,
            child: Form(
              child: Center(
                  child: SingleChildScrollView(
                      physics:
                          BouncingScrollPhysics(), // Disable overscroll glow
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                                child: Text(
                              "힌트보기",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 22.sp,
                                  color: Color.fromARGB(255, 51, 61, 75)),
                            )),
                            Padding(padding: EdgeInsets.all(15.0).w),
                            Text(
                              "내가 가진 캔디",
                              style: TextStyle(
                                  fontSize: 12.sp,
                                  color: Color.fromRGBO(51, 61, 75, 1)),
                            ),
                            Container(
                              padding: EdgeInsets.only(bottom: 15.0).r,
                              decoration: BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(
                                          width: 1.w,
                                          color: Color.fromRGBO(
                                              217, 217, 217, 1)))),
                              child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "${widget.user.candyCount}개",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 22.sp,
                                          color:
                                              Color.fromARGB(255, 51, 61, 75)),
                                    ),
                                    ElevatedButton(
                                        onPressed: () async {
                                          await Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder:
                                                      (BuildContext context) =>
                                                          CandyScreen(
                                                            user: widget.user,
                                                            number: 0,
                                                          )));
                                          setState(() {});
                                        },
                                        style: OutlinedButton.styleFrom(
                                          shadowColor: Colors.transparent,
                                          foregroundColor: Colors.white,
                                          backgroundColor:
                                              Color.fromRGBO(242, 243, 243, 1),
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10.0)),
                                        ),
                                        child: Text(
                                          "채우기",
                                          style: TextStyle(
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.bold,
                                            color:
                                                Color.fromRGBO(151, 84, 251, 1),
                                          ),
                                        ))
                                  ]),
                            ),
                            Padding(padding: EdgeInsets.all(15.0).w),
                            AnimatedOpacity(
                              opacity: !openHint[0] ? 1 : 0.6,
                              duration: Duration(milliseconds: 1),
                              child: SizedBox(
                                width: double.infinity,
                                height: 90.h,
                                child: Container(
                                  padding: EdgeInsets.all(25.0).w,
                                  decoration: BoxDecoration(
                                      color: Color(0xffF2F3F3),
                                      borderRadius: BorderRadius.circular(20)),
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          openHint[0]
                                              ? widget.answer.hint[0]
                                              : "첫번째 힌트",
                                          style: TextStyle(
                                              fontSize: 16.sp,
                                              color: Color(0xff333D4B),
                                              fontWeight: FontWeight.bold),
                                        ),
                                        ElevatedButton(
                                            onPressed: () {
                                              if (goldenCandy) {
                                                if (openHint[0] == false) {
                                                  setState(() {
                                                    openHint[0] = true;
                                                  });
                                                }
                                              } else {
                                                setState(() {
                                                  if (openHint[0] == false) {
                                                    if (widget
                                                            .user.candyCount >=
                                                        3) {
                                                      widget.user.candyCount -=
                                                          3;
                                                      print('여기');

                                                      openHint[0] = true;
                                                      print(openHint[0]);
                                                      // await Response.updateAnswer(
                                                      //     newAnswer: widget.answer);
                                                    } else {
                                                      Navigator.of(context).push(
                                                          MaterialPageRoute(
                                                              builder: (BuildContext
                                                                      context) =>
                                                                  CandyScreen(
                                                                      user: widget
                                                                          .user,
                                                                      number:
                                                                          1)));
                                                    }
                                                  }
                                                });
                                              }
                                            },
                                            style: OutlinedButton.styleFrom(
                                              shadowColor: Colors.transparent,
                                              foregroundColor: Colors.white,
                                              backgroundColor: Color.fromRGBO(
                                                  151, 84, 251, 1),
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0)),
                                            ),
                                            child: Text(
                                              goldenCandy ? '황금 캔디' : "캔디 3개",
                                              style: TextStyle(
                                                  fontSize: 14.sp,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white),
                                            ))
                                      ]),
                                ),
                              ),
                            ),
                            Padding(padding: EdgeInsets.all(10.0).w),
                            AnimatedOpacity(
                                opacity: (openHint[0] == true &&
                                        openHint[1] == false)
                                    ? 1
                                    : 0.6,
                                duration: Duration(milliseconds: 1),
                                child: SizedBox(
                                  width: double.infinity,
                                  height: 90.h,
                                  child: Container(
                                      padding: EdgeInsets.all(25.0).w,
                                      decoration: BoxDecoration(
                                          color: Color(0xffF2F3F3),
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                      child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Flexible(
                                                child: Text(
                                              openHint[1]
                                                  ? widget.answer.hint[1]
                                                  : "두번째 힌트",
                                              softWrap: true,
                                              style: TextStyle(
                                                  fontSize: 16.sp,
                                                  color: Color(0xff333D4B),
                                                  fontWeight: FontWeight.bold),
                                            )),
                                            ElevatedButton(
                                                onPressed: () {
                                                  if (goldenCandy) {
                                                    if (openHint[0] == true &&
                                                        openHint[1] == false) {
                                                      setState(() {
                                                        openHint[1] = true;
                                                      });
                                                    }
                                                  } else {
                                                    setState(() {
                                                      if (openHint[0] == true &&
                                                          openHint[1] ==
                                                              false) {
                                                        if (widget.user
                                                                .candyCount >=
                                                            3) {
                                                          widget.user
                                                              .candyCount -= 3;
                                                          openHint[1] = true;
                                                        } else {
                                                          Navigator.of(context).push(MaterialPageRoute(
                                                              builder: (BuildContext
                                                                      context) =>
                                                                  CandyScreen(
                                                                      user: widget
                                                                          .user,
                                                                      number:
                                                                          1)));
                                                        }
                                                      }
                                                    });
                                                  }
                                                },
                                                style: OutlinedButton.styleFrom(
                                                  foregroundColor: Colors.white,
                                                  shadowColor:
                                                      Colors.transparent,
                                                  backgroundColor:
                                                      Color.fromRGBO(
                                                          151, 84, 251, 1),
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10.0)),
                                                ),
                                                child: Text(
                                                  goldenCandy
                                                      ? '황금 캔디'
                                                      : "캔디 3개",
                                                  style: TextStyle(
                                                      fontSize: 14.sp,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.white),
                                                ))
                                          ])),
                                )),
                            Padding(padding: EdgeInsets.all(10.0).w),
                            AnimatedOpacity(
                                opacity: (openHint[0] == true &&
                                        openHint[1] == true &&
                                        openHint[2] == false)
                                    ? 1
                                    : 0.6,
                                duration: Duration(milliseconds: 1),
                                child: SizedBox(
                                  width: double.infinity,
                                  height: 90.h,
                                  child: Container(
                                    padding: EdgeInsets.all(25.0).w,
                                    decoration: BoxDecoration(
                                        color: Color(0xffF2F3F3),
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            openHint[2]
                                                ? widget.answer.hint[2]
                                                : "세번째 힌트",
                                            style: TextStyle(
                                                fontSize: 16.sp,
                                                color: Color(0xff333D4B),
                                                fontWeight: FontWeight.bold),
                                          ),
                                          ElevatedButton(
                                              onPressed: () {
                                                if (goldenCandy) {
                                                  if (openHint[0] == true &&
                                                      openHint[1] == true &&
                                                      openHint[2] == false) {
                                                    setState(() {
                                                      openHint[2] = true;
                                                    });
                                                  }
                                                } else {
                                                  setState(() {
                                                    if (openHint[0] == true &&
                                                        openHint[1] == true &&
                                                        openHint[2] == false) {
                                                      if (widget.user
                                                              .candyCount >=
                                                          3) {
                                                        widget.user
                                                            .candyCount -= 3;
                                                        openHint[2] = true;
                                                      } else {
                                                        Navigator.of(context).push(
                                                            MaterialPageRoute(
                                                                builder: (BuildContext
                                                                        context) =>
                                                                    CandyScreen(
                                                                      user: widget
                                                                          .user,
                                                                      number: 1,
                                                                    )));
                                                      }
                                                    }
                                                  });
                                                }
                                              },
                                              style: OutlinedButton.styleFrom(
                                                foregroundColor: Colors.white,
                                                shadowColor: Colors.transparent,
                                                backgroundColor: Color.fromRGBO(
                                                    151, 84, 251, 1),
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.0)),
                                              ),
                                              child: Text(
                                                goldenCandy ? '황금 캔디' : "캔디 3개",
                                                style: TextStyle(
                                                    fontSize: 14.sp,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white),
                                              ))
                                        ]),
                                  ),
                                ))
                          ]))),
            ),
          ),
          bottomNavigationBar: Padding(
            padding: EdgeInsets.all(20).w,
            child: SizedBox(
              width: double.infinity,
              height: 50.h,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 151, 84, 251)),
                  child: Text('확인',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 15.sp)),
                  onPressed: () async {
                    widget.hint![widget.targetKey] = {
                      "is_hint_openeds": openHint
                    };
                    print(widget.hint);
                    widget.targetValue['is_hint_openeds'][0] = openHint[0];
                    widget.targetValue['is_hint_openeds'][1] = openHint[1];
                    widget.targetValue['is_hint_openeds'][2] = openHint[2];
                    // widget.answer.isOpenedHint = openHint;
                    await Response.updateHint(
                        newHint: widget.hint!, ownerId: widget.user.uid);
                    // await Response.updateAnswer(newAnswer: widget.answer);
                    await Response.updateUser(newUser: widget.user);
                    userProvider.updateCandyCount(widget.user.candyCount);
                    Navigator.of(context).pop();
                    setState(() {});
                  }),
            ),
          ),
        ));
  }
}
