// 2023.06.20 TUE Midas: ✅
// 코드 효율성 점검: ✅
// 예외처리: ✅
// 중복 서버 송수신 방지: ✅

import 'package:cooing_front/model/response/answer.dart';
import 'package:cooing_front/model/response/user.dart';
import 'package:cooing_front/pages/candy_screen.dart';
import 'package:cooing_front/providers/hint_status_provider.dart';
import 'package:cooing_front/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:cooing_front/model/response/response.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HintPage extends StatefulWidget {
  final User user;
  final Answer answer;
  final Map<String, dynamic>? hint;

  const HintPage(
      {required this.user,
      required this.answer,
      required this.hint,
      super.key});

  @override
  State<HintPage> createState() => _HintPageState();
}

class _HintPageState extends State<HintPage> {
  bool isLoading = false;
  UserDataProvider userProvider = UserDataProvider();
  HintStatusProvider hintStatusProvider = HintStatusProvider();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          color: Colors.black54,
          onPressed: () {
            Navigator.pop(context);
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
                  physics: BouncingScrollPhysics(), // Disable overscroll glow
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "힌트보기",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 22.sp,
                              color: Color.fromARGB(255, 51, 61, 75)),
                        ),
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
                                      color:
                                          Color.fromRGBO(217, 217, 217, 1)))),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "${widget.user.candyCount}개",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 22.sp,
                                      color: Color.fromARGB(255, 51, 61, 75)),
                                ),
                                SizedBox(
                                  width: 80.w,
                                  height: 50.h,
                                  child: ElevatedButton(
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
                                      )),
                                )
                              ]),
                        ),
                        Padding(padding: EdgeInsets.all(15.0).w),
                        AnimatedOpacity(
                          opacity: !widget.hint![widget.answer.id][0] ? 1 : 0.6,
                          duration: Duration(milliseconds: 1),
                          child: SizedBox(
                            width: double.infinity,
                            height: 90.h,
                            child: Container(
                              padding: EdgeInsets.all(20.0).w,
                              decoration: BoxDecoration(
                                  color: Color(0xffF2F3F3),
                                  borderRadius: BorderRadius.circular(20)),
                              child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      widget.hint![widget.answer.id][0]
                                          ? widget.answer.hint[0]
                                          : "첫번째 힌트",
                                      style: TextStyle(
                                          fontSize: 16.sp,
                                          color: Color(0xff333D4B),
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(
                                      width: 10.w,
                                    ),
                                    Visibility(
                                      visible: !widget.hint![widget.answer.id]
                                          [0],
                                      child: SizedBox(
                                        width: 80.w,
                                        child: ElevatedButton(
                                            onPressed: () async {
                                              if (!isLoading) {
                                                setState(() {
                                                  isLoading = true;
                                                });
                                                try {
                                                  if (widget.hint![
                                                          widget.answer.id][0] ==
                                                      false) {
                                                    if (widget.user.candyCount >=
                                                        3) {
                                                      widget.user.candyCount -= 3;

                                                      await UserDataProvider()
                                                          .saveCookie();
                                                      await Response.updateUser(
                                                          newUser: widget.user);

                                                      widget.hint![widget
                                                          .answer.id][0] = true;

                                                      await HintStatusProvider().saveCookie();

                                                      await Response.updateHintStatus(
                                                          isHintOpends: widget.hint!,
                                                          ownerId:
                                                          widget.user.uid);
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
                                                } catch (e) {
                                                  print('알 수 없는 에러 - E: $e');
                                                }
                                                setState(() {
                                                  isLoading = false;
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
                                                      BorderRadius.circular(
                                                          10.0)),
                                            ),
                                            child: isLoading
                                                ? SizedBox(
                                                    width: 15,
                                                    height: 15,
                                                    child:
                                                        CircularProgressIndicator(
                                                      color: Colors.white,
                                                      strokeWidth: 2,
                                                    ),
                                                  )
                                                : Text(
                                                    "캔디 3개",
                                                    style: TextStyle(
                                                        fontSize: 14.sp,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.white),
                                                  )),
                                      ),
                                    )
                                  ]),
                            ),
                          ),
                        ),
                        Padding(padding: EdgeInsets.all(10.0).w),
                        AnimatedOpacity(
                            opacity: (widget.hint![widget.answer.id][0] ==
                                        true &&
                                    widget.hint![widget.answer.id][1] == false)
                                ? 1
                                : 0.6,
                            duration: Duration(milliseconds: 1),
                            child: SizedBox(
                              width: double.infinity,
                              height: 90.h,
                              child: Container(
                                  padding: EdgeInsets.all(20.0).w,
                                  decoration: BoxDecoration(
                                      color: Color(0xffF2F3F3),
                                      borderRadius: BorderRadius.circular(20)),
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Flexible(
                                            child: Text(
                                          widget.hint![widget.answer.id][1]
                                              ? widget.answer.hint[1]
                                              : "두번째 힌트",
                                          softWrap: true,
                                          style: TextStyle(
                                              fontSize: 16.sp,
                                              color: Color(0xff333D4B),
                                              fontWeight: FontWeight.bold),
                                        )),
                                        SizedBox(
                                          width: 10.w,
                                        ),
                                        Visibility(
                                          visible: !widget
                                              .hint![widget.answer.id][1],
                                          child: SizedBox(
                                            width: 80.w,
                                            child: ElevatedButton(
                                                onPressed: () async {
                                                  if (!isLoading) {
                                                    setState(() {
                                                      isLoading = true;
                                                    });
                                                    try {
                                                      if (widget.hint![widget
                                                                  .answer
                                                                  .id][0] ==
                                                              true &&
                                                          widget.hint![widget
                                                                  .answer
                                                                  .id][1] ==
                                                              false) {
                                                        if (widget.user
                                                                .candyCount >=
                                                            3) {
                                                          widget.user
                                                              .candyCount -= 3;

                                                          await UserDataProvider()
                                                              .saveCookie();
                                                          await Response
                                                              .updateUser(
                                                                  newUser: widget
                                                                      .user);

                                                          widget.hint![widget
                                                              .answer
                                                              .id][1] = true;

                                                          await HintStatusProvider().saveCookie();

                                                          await Response.updateHintStatus(
                                                              isHintOpends: widget.hint!,
                                                              ownerId:
                                                              widget.user.uid);
                                                        } else {
                                                          await Navigator.of(context).push(
                                                              MaterialPageRoute(
                                                                  builder: (BuildContext
                                                                          context) =>
                                                                      CandyScreen(
                                                                          user: widget
                                                                              .user,
                                                                          number:
                                                                              1)));

                                                          setState(() {

                                                          });
                                                        }
                                                      }
                                                    } catch (e) {
                                                      print('알 수 없는 에러 - E: $e');
                                                    }
                                                    setState(() {
                                                      isLoading = false;
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
                                                child: isLoading && widget.hint![widget.answer.id][0]
                                                    ? SizedBox(
                                                        width: 15,
                                                        height: 15,
                                                        child:
                                                            CircularProgressIndicator(
                                                          color: Colors.white,
                                                          strokeWidth: 2,
                                                        ),
                                                      )
                                                    : Text(
                                                        "캔디 3개",
                                                        style: TextStyle(
                                                            fontSize: 14.sp,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Colors.white),
                                                      )),
                                          ),
                                        )
                                      ])),
                            )),
                        Padding(padding: EdgeInsets.all(10.0).w),
                        AnimatedOpacity(
                            opacity: (widget.hint![widget.answer.id][0] ==
                                        true &&
                                    widget.hint![widget.answer.id][1] == true &&
                                    widget.hint![widget.answer.id][2] == false)
                                ? 1
                                : 0.6,
                            duration: Duration(milliseconds: 1),
                            child: SizedBox(
                              width: double.infinity,
                              height: 90.h,
                              child: Container(
                                padding: EdgeInsets.all(20.0).w,
                                decoration: BoxDecoration(
                                    color: Color(0xffF2F3F3),
                                    borderRadius: BorderRadius.circular(20)),
                                child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        widget.hint![widget.answer.id][2]
                                            ? widget.answer.hint[2]
                                            : "세번째 힌트",
                                        style: TextStyle(
                                            fontSize: 16.sp,
                                            color: Color(0xff333D4B),
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(
                                        width: 10.w,
                                      ),
                                      Visibility(
                                        visible: !widget.hint![widget.answer.id]
                                            [2],
                                        child: SizedBox(
                                          width: 80.w,
                                          child: ElevatedButton(
                                              onPressed: () async {
                                                if (!isLoading) {
                                                  setState(() {
                                                    isLoading = true;
                                                  });
                                                  try {
                                                    if (widget.hint![widget
                                                                .answer.id][0] ==
                                                            true &&
                                                        widget.hint![widget
                                                                .answer.id][1] ==
                                                            true &&
                                                        widget.hint![widget
                                                                .answer.id][2] ==
                                                            false) {
                                                      if (widget
                                                              .user.candyCount >=
                                                          3) {
                                                        widget.user.candyCount -=
                                                            3;

                                                        await UserDataProvider()
                                                            .saveCookie();
                                                        await Response.updateUser(
                                                            newUser: widget.user);

                                                        widget.hint![widget
                                                            .answer.id][2] = true;

                                                        await HintStatusProvider().saveCookie();

                                                        await Response.updateHintStatus(
                                                            isHintOpends: widget.hint!,
                                                            ownerId:
                                                                widget.user.uid);
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
                                                  } catch (e) {
                                                    print('알 수 없는 에러 - E: $e');
                                                  }
                                                  setState(() {
                                                    isLoading = false;
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
                                              child: isLoading && widget.hint![widget.answer.id][1]
                                                  ? SizedBox(
                                                      width: 15,
                                                      height: 15,
                                                      child:
                                                          CircularProgressIndicator(
                                                        color: Colors.white,
                                                        strokeWidth: 2,
                                                      ),
                                                    )
                                                  : Text(
                                                      "캔디 3개",
                                                      style: TextStyle(
                                                          fontSize: 14.sp,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.white),
                                                    )),
                                        ),
                                      )
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
          height: 60.h,
          child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 151, 84, 251), shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14.0))),
              child: Text('확인',
                  style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 15.sp)),
              onPressed: () {
                if (!mounted) return;
                Navigator.of(context).pop();
              }),
        ),
      ),
    );
  }
}
