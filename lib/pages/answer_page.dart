import 'package:cooing_front/model/response/question.dart';
import 'package:cooing_front/model/response/user.dart';
import 'package:cooing_front/model/util/hint.dart';
import 'package:cooing_front/model/config/palette.dart';
import 'package:cooing_front/pages/answer_complete_page.dart';
import 'package:cooing_front/pages/tab_page.dart';
import 'package:cooing_front/widgets/firebase_method.dart';
import 'package:cooing_front/model/response/response.dart' as response;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'dart:math';

class AnswerPage extends StatefulWidget {
  final User? user;
  final Question question;
  final bool isFromLink;
  const AnswerPage(
      {required this.user,
      required this.question,
      required this.isFromLink,
      super.key});

  @override
  State<AnswerPage> createState() => _AnswerPageState();
}

class _AnswerPageState extends State<AnswerPage> {
  late Question? question;
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

  @override
  void initState() {
    super.initState();
    // userData = widget.user;
    print("init !!!");
    isFromLink = widget.isFromLink;
    getQuestion(widget.question).then((value) {
      question = value;
      //링크를 통해 들어왔을 때
      //쿠키 data, 쿠키가 없으면 null 리턴
      // getCookie();

      if (isFromLink) {
        //쿠키에서 user 데이터 불러오기
        getUserCookieData().then((value) {
          //쿠키 없으면
          if (value == null) {
            setState(() {
              canLogin = false;
            });
          } else {
            _userData = value;
            hintList = generateHint(_userData!);
            setState(() {
              isLoading = false;
            });
          }
        });
      } else {
        _userData = widget.user;
        hintList = generateHint(_userData!);

        setState(() {
          isLoading = false;
        });
        print("widget.user : ${_userData!.uid}");
      }
    });

    _textController.addListener(() {
      setState(() {
        textValue = _textController.text;
      });
    });
    
  }

  getQuestion(Question? q) async {
    question = await response.Response.readQuestion(
      contentId: q!.contentId,
      questionId: q.id,
    ) as Question;

    return question;
  }

  String getNickname(User user) {
    List styles = user.style;
    int gender = user.gender; // 0: male, 1: female
    String genderString = gender == 0 ? '남학생' : '여학생';
    String randomStyle = styles[Random().nextInt(styles.length)];
    return '$randomStyle $genderString';
  }

  Future<void> _uploadUserToFirebase(String ownerId, String questionId) async {
    String newAnswerId;
    List<String>? answeredQuestions;
    try {
      if (question!.id.isNotEmpty) {
        timeId = DateTime.now().toString();
        print("ownerId: $ownerId");

        final DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(_userData!.uid)
            .get();

        Map<String, dynamic>? data =
            userSnapshot.data() as Map<String, dynamic>?;

        if (data != null) {
          answeredQuestions = List<String>.from(data['answeredQuestions']);
        } else {
          answeredQuestions = [];
        }

        answeredQuestions.add(questionId);

        final userAnswerRef = FirebaseFirestore.instance
            .collection('answers')
            .doc(ownerId) //question 주인 answer collection 가져오기
            .collection('answers');
        final QuerySnapshot snapshot = await userAnswerRef
            .orderBy('time', descending: true)
            .limit(1)
            .get();

        if (snapshot.docs.isNotEmpty) {
          final String lastDocumentId = snapshot.docs.last.id; //가장 최근 answer Id
          // print("last Answer document id : $lastDocumentId");
          // print("Current question Id : $questionId");

          if (lastDocumentId.split('_').last != questionId) {
            print("${lastDocumentId.split('_').last} ???? $questionId");
            //가장 최근 답변이 이전 질문에 대한 답변일 때
            newAnswerId = '#000001_$questionId';
          } else {
            //현재 질문에 대한 답변일 때
            final int lastNumber =
                int.tryParse(lastDocumentId.split('_')[0].substring(1)) ??
                    0; // 가장 최근 document의 번호
            newAnswerId =
                '#${(lastNumber + 1).toString().padLeft(6, '0')}_$questionId';
          }

          // 새 document의 ID 생성
        } else {
          //answer 데이터가 아예 없을 때
          print('No documents found in answer collection');
          newAnswerId = '#000001_$questionId';
        }
        //Answer 데이터 업로드
        await userAnswerRef.doc(newAnswerId).set({
          'id': newAnswerId, // 마이크로세컨드까지 보낸 시간으로 사용
          'time': timeId,
          'owner': _userData!.uid,
          'ownerGender': _userData!.gender,
          'questionId': questionId,
          'content': textValue,
          'contentId': question!.contentId,
          'questionOwner': question!.owner,
          'isAnonymous': _checkSecret,
          'nickname': _checkSecret ? getNickname(_userData!) : _userData!.name,
          'hint': hintList,
          'isOpenedHint': [false, false, false], //bool List
          'isOpened': false,
        });
        //user의 answeredQuestion 업로드
        await FirebaseFirestore.instance
            .collection('users')
            .doc(_userData!.uid)
            .update({
          'answeredQuestions': answeredQuestions,
        });
      } else {
        print("userData is Null");
      }
    } catch (e) {
      print(e);
    }
  }

  void showDialogMsg(String type) {
    late String title;
    late String content;

    if (type == "textEmpty") {
      title = "입력된 답변이 없습니다.";
      content = "답변을 입력하세요.";
    }
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.white,
            title: Text(title,
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                )),
            content: Text(content,
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 14.0,
                )),
            actions: <Widget>[
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  fixedSize: Size.fromHeight(10),
                  foregroundColor: Colors.white,
                  backgroundColor: const Color(0xff9754FB),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14.0)),
                ),
                child: Text('확인'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  Future<bool> _navigateBack() async {
    return true;
  }

  Widget isNotOpenedView() {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
              width: 120.0,
              height: 120.0,
              child: Icon(
                Icons.cancel,
                size: 120,
                color: Palette.mainPurple,
              )),
          Container(
            padding: EdgeInsets.only(top: 50, bottom: 7),
            child: Text(
              "이 질문은",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                  color: Color.fromARGB(255, 51, 61, 75)),
            ),
          ),
          Text(
            "답변을 할 수 없습니다.",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 22,
                color: Color.fromARGB(255, 51, 61, 75)),
          ),
        ]);
  }

  Widget okBtn() {
    return SafeArea(
        child: Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).systemGestureInsets.bottom + 20,
              left: 20,
              right: 20,
            ),
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
                      child: const Text(
                        "확인",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      )),
                ])));
  }

  @override
  Widget build(BuildContext context) {
    return canLogin
        ? isLoading
            ? loadingView()
            : question!.isOpen
                ? WillPopScope(
                    onWillPop: _navigateBack,
                    child: Scaffold(
                      appBar: AppBar(
                        automaticallyImplyLeading: false,
                        backgroundColor: Colors.transparent,
                        elevation: 0.0,
                        leading: IconButton(
                          icon: const Icon(Icons.close_rounded),
                          color: Colors.black54,
                          onPressed: () {
                            isFromLink
                                ? Get.offAll(TabPage(),
                                    arguments: _userData!.uid)
                                : Navigator.pop(context, false);
                          },
                        ),
                      ),
                      body: SingleChildScrollView(
                        child: Column(
                          children: [
                            _answerBody(),
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: sendBtn(),
                            ),
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
                  )
        : Scaffold();
  }

  Widget _answerBody() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(
        children: [
          Padding(padding: EdgeInsets.all(15.0)),
          Text(
            "답변 작성",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 22.0,
            ),
            textAlign: TextAlign.center,
          ),
          const Padding(padding: EdgeInsets.all(7.0)),
        ],
      ),
      const Padding(padding: EdgeInsets.all(7.0)),
      Center(
        child: Text(
          "${question!.ownerName}에게",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18.0,
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
            padding: EdgeInsets.all(15.0),
            width: double.infinity,
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)),
              color: const Color(0xff9754FB),
              child: Column(children: <Widget>[
                const Padding(padding: EdgeInsets.all(15.0)),
                question!.ownerProfileImage.isEmpty
                    ? CircularProgressIndicator(
                        color: Palette.mainPurple,
                      )
                    : SizedBox(
                        width: 80.0,
                        height: 80.0,
                        child: CircleAvatar(
                          backgroundImage:
                              NetworkImage(question!.ownerProfileImage),
                        ),
                      ),
                Padding(
                  padding:
                      EdgeInsets.only(left: 25, right: 25, top: 20, bottom: 1),
                  child: Text(
                    question!.content,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
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
        padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 15, bottom: 10),
        child: Column(children: [
          TextField(
            enableSuggestions: false,
            autocorrect: false,
            style: const TextStyle(color: Colors.white70),
            controller: _textController,
            maxLines: 5,
            maxLength: 100,
            decoration: InputDecoration(
              counterText: "",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: const BorderSide(width: 0, style: BorderStyle.none),
              ),
              contentPadding: const EdgeInsets.all(10),
              filled: true,
              fillColor: Colors.white24,
              hintText: '당신의 진심을 담은 답변을 적어주세요',
              hintStyle: const TextStyle(
                fontSize: 14,
                color: Colors.white38,
              ),
            ),
          ),
          const Padding(padding: EdgeInsets.all(4)),
          Container(
              padding: EdgeInsets.only(top: 6, right: 15),
              child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                Text(
                  "${textValue.length} / $maxLength",
                  style: const TextStyle(color: Colors.white54, fontSize: 13),
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
        const Text(
          '익명',
          style: TextStyle(fontSize: 14, color: Color(0xff333D4B)),
        )
      ],
    );
  }

  Widget sendBtn() {
    return Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).systemGestureInsets.bottom + 10,
          top: 15,
          left: 20,
          right: 20,
        ),
        child:
            Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          ElevatedButton(
              onPressed: () {
                if (textValue.isEmpty) {
                  showDialogMsg("textEmpty");
                } else {
                  //firebase 에 업로드
                  _uploadUserToFirebase(question!.owner, question!.id);

                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (BuildContext context) => AnswerCompleteScreen(
                        uid: _userData!.uid,
                        owner: question!.ownerName,
                        isFromLink: isFromLink,
                      ),
                    ),
                  );
                }
              },
              style: OutlinedButton.styleFrom(
                fixedSize: Size.fromHeight(50),
                foregroundColor: Colors.white,
                backgroundColor: const Color(0xff9754FB),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14.0)),
              ),
              child: const Text(
                "보내기",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ))
        ]));
  }
}
