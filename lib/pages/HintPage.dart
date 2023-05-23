import 'package:cooing_front/model/response/answer.dart';
import 'package:cooing_front/model/response/user.dart';
import 'package:cooing_front/pages/CandyScreen.dart';
import 'package:cooing_front/pages/answer_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:cooing_front/model/response/response.dart';
import 'package:get/get_navigation/get_navigation.dart';

class HintScreen extends StatefulWidget {
  final User user;
  final Answer answer;

  const HintScreen({required this.user, required this.answer, super.key});

  @override
  State<HintScreen> createState() => _HintScreenState();
}

class _HintScreenState extends State<HintScreen> {
  late List<dynamic> openHint;
  late bool goldenCandy;

  @override
  void initState() {
    super.initState();
    print(widget.answer.hint);
    openHint = widget.answer.isOpenedHint;
    goldenCandy = widget.user.isSubscribe;
  }

  // List<String> getHint(User user);

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: BackButton(
          color: Color.fromRGBO(51, 61, 75, 1),
          onPressed: () async {
            widget.answer.isOpenedHint = openHint;
            await Response.updateAnswer(newAnswer: widget.answer);
            await Response.updateUser(newUser: widget.user);
            Navigator.of(context).pop();
            // setState(() {});
          },
        ),
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
                          "${widget.user.candyCount}개",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 22,
                              color: Color.fromARGB(255, 51, 61, 75)),
                        ),
                        ElevatedButton(
                            onPressed: () async {
                              await Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          CandyScreen(
                                            user: widget.user,
                                          )));
                              setState(() {});
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
                  opacity: !openHint[0] ? 1 : 0.6,
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
                                  openHint[0]
                                      ? widget.answer.hint[0]
                                      : "첫번째 힌트",
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
                                    if (openHint[0] == false) {
                                      setState(() {
                                        openHint[0] = true;
                                      });
                                    }
                                  } else {
                                    setState(() {
                                      if (openHint[0] == false) {
                                        if (widget.user.candyCount >= 3) {
                                          widget.user.candyCount -= 3;
                                          print('여기');

                                          openHint[0] = true;
                                          print(openHint[0]);
                                          // await Response.updateAnswer(
                                          //     newAnswer: widget.answer);
                                        } else {
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder:
                                                      (BuildContext context) =>
                                                          CandyScreen(
                                                            user: widget.user,
                                                          )));
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
                    opacity:
                        (openHint[0] == true && openHint[1] == false) ? 1 : 0.6,
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
                                    openHint[1]
                                        ? widget.answer.hint[1]
                                        : "두번째 힌트",
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
                                      if (openHint[0] == true &&
                                          openHint[1] == false) {
                                        setState(() {
                                          openHint[1] = true;
                                        });
                                      }
                                    } else {
                                      setState(() {
                                        if (openHint[0] == true &&
                                            openHint[1] == false) {
                                          if (widget.user.candyCount >= 3) {
                                            widget.user.candyCount -= 3;
                                            openHint[1] = true;
                                          } else {
                                            Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (BuildContext
                                                            context) =>
                                                        CandyScreen(
                                                          user: widget.user,
                                                        )));
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
                    opacity: (openHint[0] == true &&
                            openHint[1] == true &&
                            openHint[2] == false)
                        ? 1
                        : 0.6,
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
                                    openHint[2]
                                        ? widget.answer.hint[2]
                                        : "세번째 힌트",
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
                                          if (widget.user.candyCount >= 3) {
                                            widget.user.candyCount -= 3;
                                            openHint[2] = true;
                                          } else {
                                            Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (BuildContext
                                                            context) =>
                                                        CandyScreen(
                                                          user: widget.user,
                                                        )));
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
              onPressed: () async {
                widget.answer.isOpenedHint = openHint;
                await Response.updateAnswer(newAnswer: widget.answer);
                await Response.updateUser(newUser: widget.user);
                Navigator.of(context).pop();
                setState(() {});
              }),
        ),
      ),
    );
  }
}
