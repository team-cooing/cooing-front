import 'package:cooing_front/model/response/question.dart';
import 'package:cooing_front/model/response/user.dart';
import 'package:cooing_front/model/util/hint.dart';
import 'package:cooing_front/model/config/palette.dart';
import 'package:cooing_front/pages/answer_complete_page.dart';
import 'package:cooing_front/pages/tab_page.dart';
import 'package:cooing_front/model/response/response.dart' as response;
import 'package:cooing_front/providers/UserProvider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'dart:math';
import 'package:cooing_front/model/response/fcmController.dart';
// import 'package:firebase_analytics/firebase_analytics.dart';
// import 'package:cooing_front/widgets/google_analytics_widget.dart';

class AnswerPage extends StatefulWidget {
  final User? user;
  final String uid;
  final Question question;
  final bool isFromLink;


  const AnswerPage(
      {required this.user,
      required this.uid,
      required this.question,
      required this.isFromLink,

      super.key});

  @override
  State<AnswerPage> createState() => _AnswerPageState();
}

class _AnswerPageState extends State<AnswerPage> {
  late Question question;
  late String nickname;
  late Question? updateQuestion;
  late String uid;
  late User? _userData;
  bool _checkSecret = true;
  late bool isFromLink;
  bool isLoading = true;
  bool canLogin = true;
  late List<String> hintList;
  late DocumentReference userDocRef;

  int maxLength = 100;
  String textValue = "";
  late String timeId;
  late CollectionReference contentCollectionRef;
  late CollectionReference userCollectionRef;

  final TextEditingController _textController = TextEditingController();
  final FCMController _fcmController = FCMController();

  @override
  void initState() {
    super.initState();
    // final FirebaseAnalytics analytics = FirebaseAnalytics.instance;
    // setCurrentScreen(analytics, 'answer_page');

    //쿠키에 저장된 user 데이터 사용
    // getCookie();
    question = widget.question;
    uid = widget.uid;
    isFromLink = widget.isFromLink;

    settingData();

    _textController.addListener(() {
      setState(() {
        textValue = _textController.text;
      });
    });
  }

  Future<void> settingData() async {
    // question = await getQuestion(widget.question);
    question = question;

    //링크를 통해 들어왔을 때
    if (isFromLink) {
      //user 데이터 불러오기
      UserDataProvider userProvider = UserDataProvider();
      await userProvider.loadData();
      _userData = userProvider.userData;

      hintList = generateHint(_userData!);
      nickname = getNickname(_userData!);
      print(hintList);
      print(nickname);

      // getUserData(uid).then((value) {
      //   _userData = value;
      //   hintList = generateHint(_userData!);
      //   nickname = getNickname(_userData!);
      // });
    } else {
      _userData = widget.user;
      hintList = generateHint(_userData!);
      nickname = getNickname(_userData!);

      print("widget.user : ${_userData!.uid}");
    }

    await Future.delayed(Duration(seconds: 1));

    if (_userData != null && hintList.isNotEmpty) {
      isLoading = false;
    } else if (_userData == null) {
      Navigator.pushReplacementNamed(context, '/initialRoute');
    }

    setState(() {});
  }

  // getQuestion(Question? q) async {
  //   question = await response.Response.readQuestion(
  //     contentId: q!.contentId,
  //     questionId: q.id,
  //   ) as Question;

  //   return question;
  // }

  String getNickname(User user) {
    List styles = user.style;
    int gender = user.gender; // 0: male, 1: female
    String genderString = gender == 0 ? '남학생' : '여학생';
    String randomStyle = styles[Random().nextInt(styles.length)];
    return '$randomStyle $genderString';
  }

  Future<void> _uploadUserToFirebase(String ownerId, String questionId) async {
    String newAnswerId;
    try {
      if (question.id.isNotEmpty) {
        timeId = DateTime.now().toString();
        print("ownerId: $ownerId");
        _userData!.answeredQuestions.add(questionId);

        final userAnswerRef = FirebaseFirestore.instance
            .collection('openStatus')
            .doc(ownerId); //question 주인 answer collection 가져오기

        //Answer 데이터 업로드
        userAnswerRef.set({
          timeId: {
            'is_hint_openeds': [false, false, false], //bool List
          }
        }).then((value) {
          print('업데이트 성공');
        }).catchError((error) {
          print('업데이트 실패: $error');
        });

        //user 업데이트
        response.Response.createUser(newUser: _userData!);
      } else {
        print("userData is Null");
      }
    } catch (e) {
      print(e);
    }
  }

  Future<bool> _navigateBack() async {
    hideKeyboard();

    return true;
  }

  Widget isNotOpenedView() {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
              width: 120.0.w,
              height: 120.0.h,
              child: Icon(
                Icons.cancel,
                color: Palette.mainPurple,
              )),
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
                        Get.offAll(TabPage(), arguments: _userData!.uid);
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

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? loadingView()
        : question.isOpen
            ? WillPopScope(
                onWillPop: _navigateBack,
                child: GestureDetector(
                  onTap: () => hideKeyboard(),
                  child: Scaffold(
                    resizeToAvoidBottomInset : false,
                    appBar: AppBar(
                      automaticallyImplyLeading: false,
                      backgroundColor: Colors.transparent,
                      elevation: 0.0,
                      leading: IconButton(
                        icon: const Icon(Icons.close_rounded),
                        color: Colors.black54,
                        onPressed: () {
                          isFromLink
                              ? Get.offAll(TabPage(), arguments: _userData!.uid)
                              : Navigator.pop(context, false);
                        },
                      ),
                    ),
                    body:
                       Column(
                        children: [
                          Expanded( child : _answerBody()),
                          Align(alignment: Alignment.bottomCenter,child:sendBtn()),
                   ],

                    ),
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
                      EdgeInsets.only(left: 25, right: 25, top: 20, bottom: 1).r,
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
        padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 15, bottom: 10).r,
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
                  : () {
                      // Only execute the code when textValue is not empty
                      String name = _checkSecret ? nickname : _userData!.name;
                      String content = "$name에게 메시지가 도착했어요!";
                      _fcmController.sendMessage(
                          userToken: question.fcmToken,
                          title: '쿠잉',
                          body: content);
                      _uploadUserToFirebase(question.owner, question.id);

                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (BuildContext context) =>
                              AnswerCompleteScreen(
                            uid: _userData!.uid,
                            owner: question.ownerName,
                            isFromLink: isFromLink,
                          ),
                        ),
                      );
                    },
              style: OutlinedButton.styleFrom(
                fixedSize: Size.fromHeight(50),
                foregroundColor: Colors.white,
                backgroundColor: const Color(0xff9754FB),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14.0),
                ),
              ),
              child: Text(
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
