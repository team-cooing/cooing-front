import 'package:cooing_front/model/response/question.dart';
import 'package:cooing_front/model/response/user.dart';
import 'package:flutter/material.dart';
import 'package:cooing_front/pages/answer_complete_page.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/util/hint.dart';
import 'package:cooing_front/widgets/firebase_method.dart';
import 'package:cooing_front/model/config/palette.dart';

class AnswerPage extends StatefulWidget {
  final User user;
  final Question question;

  const AnswerPage({required this.user, required this.question, super.key});

  @override
  State<AnswerPage> createState() => _AnswerPageState();
}

class _AnswerPageState extends State<AnswerPage> {
  bool isLoading = true;
  late Question question;

  late String uid;
  late User _userData;
  late bool _checkSecret = false;
  late DocumentReference userDocRef;

  int maxLength = 100;
  String textValue = "";
  late String timeId;
  late CollectionReference contentCollectionRef;
  late CollectionReference userCollectionRef;
  late List<String> hintList;

  final TextEditingController _textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    uid = widget.user.uid;
    question = widget.question;

    getUserData(uid).then((data) {
      _userData = data;
      hintList = generateHint(_userData);
      print(_userData);
      setState(() {
        isLoading = false;
      });
    });

    _textController.addListener(() {
      setState(() {
        textValue = _textController.text;
      });
    });
  }

  Future<void> _uploadUserToFirebase(String ownerId) async {
    String newAnswerId;

    try {
      if (question.id.isNotEmpty) {
        timeId = DateTime.now().toString();
        print("ownerId: $ownerId");

        final userAnswerRef = FirebaseFirestore.instance
            .collection('answers')
            .doc(ownerId) //question 주인 answer collection 가져오기
            .collection('answers');

        final QuerySnapshot snapshot = await userAnswerRef
            .orderBy('createdAt',
                descending: true) // createdAt 필드를 기준으로 내림차순 정렬
            .limit(1) // 가장 마지막 document 하나만 가져오기
            .get();

        if (snapshot.docs.isNotEmpty) {
          final String lastDocumentId = snapshot.docs.last.id; //가장 최근 answer Id

          if (lastDocumentId.split('-').last != question.id) {
            //가장 최근 답변이 이전 질문에 대한 답변일 때
            newAnswerId = '#000001_${question.id}';
          } else {
            //현재 질문에 대한 답변일 때
            final int lastNumber =
                int.tryParse(lastDocumentId.split('_')[0].substring(1)) ??
                    0; // 가장 최근 document의 번호
            newAnswerId =
                '#${(lastNumber + 1).toString().padLeft(6, '0')}_${question.id}';
          }

          // 새 document의 ID 생성
        } else {
          //answer 데이터가 아예 없을 때
          print('No documents found in answer collection');
          newAnswerId = '#000001_${question.id}';
        }

        await userAnswerRef.doc(newAnswerId).set({
          'id': newAnswerId, // 마이크로세컨드까지 보낸 시간으로 사용
          'time': timeId,
          'owner': _userData.uid,
          'ownerGender': _userData.gender,
          'questionId': question.id,
          'content': textValue,
          'isAnonymous': _checkSecret,
          'nickname': _checkSecret ? '닉네임' : _userData.name,
          'hint': hintList,
          'isOpenedHint': [false, false, false], //bool List
          'isOpened': false,
        });
      } else {
        print("userData is Null");
      }
    } catch (e) {
      print(e);
    }
  }

  void emptyTextDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('입력된 답변이 없습니다.'),
            content: Text('답변을 입력하세요.'),
            actions: <Widget>[
              OutlinedButton(
                child: Text('확인'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? loadingView()
        : Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: Colors.transparent,
              elevation: 0.0,
              leading: IconButton(
                icon: const Icon(Icons.close_rounded),
                color: Colors.black54,
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
            body: SafeArea(
                child: Column(children: [
              Expanded(
                child: _answerBody(),
              ),
              Align(alignment: Alignment.bottomCenter, child: sendBtn())
            ])),
          );
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

  Widget _answerBody() {
    return SingleChildScrollView(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
      _answerCard(),
      checking(),
    ]));
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
                question.ownerProfileImage.isEmpty
                    ? const CircularProgressIndicator()
                    : SizedBox(
                        width: 80.0,
                        height: 80.0,
                        child: CircleAvatar(
                          backgroundImage:
                              NetworkImage(question.ownerProfileImage),
                        ),
                      ),
                const Padding(padding: EdgeInsets.all(10.0)),
                Text(
                  question.content,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.white),
                ),
                const Padding(padding: EdgeInsets.all(7.0)),
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
          bottom: MediaQuery.of(context).systemGestureInsets.bottom + 20,
          left: 20,
          right: 20,
        ),
        child:
            Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          ElevatedButton(
              onPressed: () async {
                if (textValue.isNotEmpty) {
                  await _uploadUserToFirebase(question.id);
                  Get.to(() => AnswerCompleteScreen(),
                      arguments: {"ownerName": question.ownerName, "uid": uid});
                } else {
                  emptyTextDialog();
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
