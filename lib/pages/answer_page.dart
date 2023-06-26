// 2023.06.20 TUE Midas: ✅
// 코드 효율성 점검: ✅
// 예외처리: ✅
// 중복 서버 송수신 방지: ✅

import 'package:cooing_front/model/response/answer.dart';
import 'package:cooing_front/model/response/dynamic_link_status.dart';
import 'package:cooing_front/model/response/question.dart';
import 'package:cooing_front/model/response/response_optimization.dart';
import 'package:cooing_front/model/response/user.dart';
import 'package:cooing_front/model/util/hint.dart';
import 'package:cooing_front/model/config/palette.dart';
import 'package:cooing_front/pages/answer_complete_page.dart';
import 'package:cooing_front/pages/tab_page.dart';
import 'package:cooing_front/model/response/response.dart' as response;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cooing_front/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'dart:math';

class AnswerPage extends StatefulWidget {
  final User? user;
  final String uid;
  final Question question;
  final bool isFromLink;
  final Map<String, dynamic> hints;
  final bool isBonusQuestion;

  const AnswerPage(
      {required this.user,
      required this.uid,
      required this.question,
      required this.isFromLink,
      required this.hints,
      required this.isBonusQuestion,
      super.key});

  @override
  State<AnswerPage> createState() => _AnswerPageState();
}

class _AnswerPageState extends State<AnswerPage> {
  late Question question;
  late String nickname;
  late Question? updateQuestion;
  late String uid;
  bool _checkSecret = true;
  bool canLogin = true;
  late List<String> hintList;
  late DocumentReference userDocRef;
  int maxLength = 100;
  String textValue = "";
  late String timeId;
  late CollectionReference contentCollectionRef;
  late CollectionReference userCollectionRef;
  final TextEditingController _textController = TextEditingController();
  bool isLoading = false;
  bool isDataLoading = true;

  @override
  void initState() {
    super.initState();

    question = widget.question;
    if (widget.isFromLink) {
      checkingOpenState(question).then((value) {
        setState(() {
          question.isOpen = value;
          isDataLoading = false;
        });
      }).catchError((error){
        print('dynamicLink - E: $error');
        setState(() {
          question.isOpen = false;
          isDataLoading = false;
        });
      });
    }else{
      setState(() {
        isDataLoading = false;
      });
    }
    uid = widget.uid;
    hintList = generateHint(widget.user!);
    nickname = getNickname(widget.user!);

    _textController.addListener(() {
      setState(() {
        textValue = _textController.text;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return isDataLoading
        ? loadingView()
        : question.isOpen
            ? GestureDetector(
                onTap: () => hideKeyboard(),
                child: Scaffold(
                  resizeToAvoidBottomInset: false,
                  appBar: AppBar(
                    automaticallyImplyLeading: false,
                    backgroundColor: Colors.transparent,
                    elevation: 0.0,
                    leading: IconButton(
                      icon: const Icon(Icons.close_rounded),
                      color: Colors.black54,
                      onPressed: () {
                        Navigator.pop(context, false);
                      },
                    ),
                  ),
                  body: Column(
                    children: [
                      Expanded(child: _answerBody()),
                      Align(
                          alignment: Alignment.bottomCenter, child: sendBtn()),
                    ],
                  ),
                ),
              )
            : Scaffold(
                backgroundColor: Color(0xFFffffff),
                body: SizedBox(
                  width: double.infinity,
                  child: Column(
                    children: [
                      Expanded(child: isNotOpenedView()),
                      okBtn(),
                    ],
                  ),
                ),
              );
  }

  Future<bool> checkingOpenState(Question question) async {
    DateTime now = DateTime.now();
    DateTime receiveTime = DateTime.parse(question.receiveTime);
    Duration difference = now.difference(receiveTime);

    //질문 open한 지 24시간이 지나면
    if (difference.inHours >= 24) {
      bool isOpened = false;
      DynamicLinkStatus? dynamicLinkStatus =
          await response.Response.readDynamicLink(questionId: question.id);
      if (dynamicLinkStatus != null) {
        isOpened = dynamicLinkStatus.isOpened;
      }

      return isOpened;
    }
    //24시간이 지나기 전에는 isOpened가 true
    return true;
  }

  String getNickname(User user) {
    List styles = user.style;
    int gender = user.gender; // 0: male, 1: female
    String genderString = gender == 0 ? '남학생' : '여학생';
    String randomStyle = styles[Random().nextInt(styles.length)];
    return '$randomStyle $genderString';
  }

  Future<void> _uploadUserToFirebase() async {
    try {
      timeId = DateTime.now().toString();

      Answer newAnswer = Answer(
          id: timeId,
          time: timeId,
          owner: widget.user!.uid,
          ownerGender: widget.user!.gender,
          content: textValue,
          contentId: question.contentId,
          questionId: question.id,
          questionOwner: question.owner,
          questionOwnerFcmToken: question.fcmToken,
          isAnonymous: _checkSecret,
          nickname: _checkSecret ? nickname : widget.user!.name,
          hint: hintList,
          isOpenedHint: [false, false, false],
          isOpened: false);

      widget.user!.answeredQuestions.add(question.id);
      if (widget.isBonusQuestion) {
        widget.user!.recentQuestionBonusReceiveDate = DateTime.now().toString();
        widget.user!.candyCount += 3;
      }

      await UserDataProvider().saveCookie();

      await ResponseOptimization.createMessageUploadRequest(
          newAnswer: newAnswer);

      await response.Response.updateUser(newUser: widget.user!);
    } catch (e) {
      print(e);
    }
  }

  Widget isNotOpenedView() {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 100.w,
            height: 100.w,
            child:
                Image(image: AssetImage('assets/images/icon_isNotOpened.png')),
          ),
          Container(
            padding: EdgeInsets.only(top: 50, bottom: 7).r,
            child: Text(
              "이 질문은",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22.sp,
                  color: Color.fromARGB(255, 51, 61, 75)),
            ),
          ),
          Text(
            "답변을 할 수 없습니다.",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 22.sp,
                color: Color.fromARGB(255, 51, 61, 75)),
          ),
        ]);
  }

  Widget okBtn() {
    return SafeArea(
        child: Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).systemGestureInsets.bottom + 25,
              left: 25,
              right: 25,
            ).r,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ElevatedButton(
                      onPressed: () {
                        Get.offAll(
                            TabPage(
                              isLinkEntered: false,
                            ),
                            arguments: widget.user!.uid);
                      },
                      style: OutlinedButton.styleFrom(
                        fixedSize: Size.fromHeight(50),
                        foregroundColor: Colors.white,
                        backgroundColor: const Color(0xff9754FB),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14.0)),
                      ),
                      child: Text(
                        "확인",
                        style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      )),
                ])));
  }

  void hideKeyboard() {
    FocusScope.of(context).unfocus();
  }

  Widget _answerBody() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(
        children: [
          Padding(padding: EdgeInsets.all(15.0).w),
          Text(
            "답변 작성",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 22.0.sp,
            ),
            textAlign: TextAlign.center,
          ),
          const Padding(padding: EdgeInsets.all(7.0)),
        ],
      ),
      const Padding(padding: EdgeInsets.all(7.0)),
      Center(
        child: Text(
          "${question.ownerName}에게",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18.0.sp,
          ),
          textAlign: TextAlign.center,
        ),
      ),
      _answerCard(),
      checking(),
    ]);
  }

  Widget _answerCard() {
    return Center(
        child: Container(
            padding: EdgeInsets.all(15.0).w,
            width: double.infinity,
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30).w),
              color: const Color(0xff9754FB),
              child: Column(children: <Widget>[
                const Padding(padding: EdgeInsets.all(15.0)),
                question.ownerProfileImage.isEmpty
                    ? CircularProgressIndicator(
                        color: Palette.mainPurple,
                      )
                    : SizedBox(
                        width: 80.0.w,
                        height: 80.0.h,
                        child: CircleAvatar(
                          backgroundImage:
                              NetworkImage(question.ownerProfileImage),
                        ),
                      ),
                Padding(
                  padding:
                      EdgeInsets.only(left: 25, right: 25, top: 20, bottom: 1)
                          .r,
                  child: Text(
                    question.content,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.sp,
                        color: Colors.white),
                  ),
                ),
                answerTxtField(),
              ]),
            )));
  }

  Widget answerTxtField() {
    // String textLength = "0 / maxLength";
    return Container(
        width: double.infinity,
        padding:
            EdgeInsets.only(left: 20.0, right: 20.0, top: 15, bottom: 10).r,
        child: Column(children: [
          TextField(
            enableSuggestions: false,
            autocorrect: false,
            style: TextStyle(color: Colors.white70, fontSize: 14.sp),
            controller: _textController,
            maxLines: 5,
            maxLength: 100,
            decoration: InputDecoration(
              counterText: "",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15.0).w,
                borderSide: const BorderSide(width: 0, style: BorderStyle.none),
              ),
              contentPadding: const EdgeInsets.all(10).w,
              filled: true,
              fillColor: Colors.white24,
              hintText: '당신의 진심을 담은 답변을 적어주세요',
              hintStyle: TextStyle(
                fontSize: 12.sp,
                color: Colors.white38,
              ),
            ),
          ),
          const Padding(padding: EdgeInsets.all(4)),
          Container(
              padding: EdgeInsets.only(top: 6, right: 15).r,
              child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                Text(
                  "${textValue.length} / $maxLength",
                  style: TextStyle(color: Colors.white54, fontSize: 13.sp),
                )
              ])),
        ]));
  }

  Widget loadingView() {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Center(
                child: CircularProgressIndicator(
              color: Palette.mainPurple,
            )),
          ),
        ],
      ),
    );
  }

  Widget checking() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Transform.scale(
          scale: 1.4,
          child: Checkbox(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
            activeColor: const Color(0xff9754FB),
            focusColor: const Color(0xff9754FB),
            value: _checkSecret,
            onChanged: (value) {
              setState(() {
                if (value != null) {
                  _checkSecret = value;
                }
              });
            },
          ),
        ),
        Text(
          '익명',
          style: TextStyle(fontSize: 14.sp, color: Color(0xff333D4B)),
        )
      ],
    );
  }

  Widget sendBtn() {
    bool isTextEmpty = textValue.isEmpty;

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).systemGestureInsets.bottom + 25,
        left: 25,
        right: 25,
      ).r,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Opacity(
            opacity: isTextEmpty ? 0.5 : 1.0,
            child: ElevatedButton(
              onPressed: isTextEmpty
                  ? null
                  : () async {
                      if (!isLoading) {
                        setState(() {
                          isLoading = true;
                        });
                        await _uploadUserToFirebase();
                        setState(() {
                          isLoading = false;
                        });

                        if (!mounted) return;
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (context) => AnswerCompleteScreen(
                                  uid: widget.user!.uid,
                                  owner: question.ownerName,
                                )));
                      }
                    },
              style: OutlinedButton.styleFrom(
                fixedSize: Size.fromHeight(60.h),
                foregroundColor: Colors.white,
                backgroundColor: const Color(0xff9754FB),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14.0),
                ),
              ),
              child: isLoading
                  ? SizedBox(
                      width: 20.w,
                      height: 20.h,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 3,
                      ),
                    )
                  : Text(
                      "보내기",
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
