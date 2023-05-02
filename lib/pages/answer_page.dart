import 'package:cooing_front/providers/UserProvider.dart';
import 'package:flutter/material.dart';
import 'package:cooing_front/pages/answer_complete_page.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import '../model/util/hint.dart';
import '../model/response/User.dart';

class AnswerPage extends StatefulWidget {
  final User user;
  const AnswerPage({required this.user, super.key});
  // final String uid;

  // const AnswerPage({required this.uid, super.key});

  @override
  State<AnswerPage> createState() => _AnswerPageState();
}

class _AnswerPageState extends State<AnswerPage> {
  var questionList = ['내 첫인상은 어땠어?', '내 mbti는 무엇인 것 같아?', '나랑 닮은 동물은 뭐야?'];
  String askText = Get.arguments[0];
  String questionId = Get.arguments[1];
  String profileImage = Get.arguments[2];
  String name = Get.arguments[3];

  bool? _checkSecret = false;
  late DocumentReference userDocRef;

  int maxLength = 100;
  String textValue = "";
  late DateTime id;
  UserDataProvider? _userDataProvider;
  User? _userData;
  late CollectionReference contentCollectionRef;
  late CollectionReference userCollectionRef;
  late List<String> hintList;
  @override
  void initState() {
    super.initState();
    _userData = Provider.of<UserDataProvider>(context, listen: false).userData;
    hintList = generateHint(_userData!);
  }

  final TextEditingController _textController = TextEditingController();

  final _authentication = firebase.FirebaseAuth.instance;

  Future<void> _uploadUserToFirebase() async {
    try {
      String uid = widget.user.uid;
      String newId;
      final userAnswerRef = FirebaseFirestore.instance
          .collection('answers')
          .doc(uid)
          .collection('answers');

      final QuerySnapshot snapshot = await userAnswerRef
          .orderBy('createdAt', descending: true) // createdAt 필드를 기준으로 내림차순 정렬
          .limit(1) // 가장 마지막 document 하나만 가져오기
          .get();

      if (snapshot.docs.isNotEmpty) {
        final lastDocument = snapshot.docs.last;
        final String lastId = lastDocument.id; // 가장 최근 document의 ID
        final int lastNumber =
            int.tryParse(lastId.split('_')[0].substring(1)) ??
                0; // 가장 최근 document의 번호

        // 새 document의 ID 생성
        newId =
            '#${(lastNumber + 1).toString().padLeft(6, '0')}_${DateTime.now().toString()}';
      } else {
        print('No documents found in collection');
        newId = '#000001_${DateTime.now().toString()}';
      }

      await userAnswerRef.doc(newId).set({
        'id': id, // 마이크로세컨드까지 보낸 시간으로 사용
        'time': id,
        'owner': _userData!.uid,
        'ownerGender': _userData!.gender,
        'questionId': questionId,
        'content': textValue,
        'isAnonymous': _checkSecret,
        'nickname': _checkSecret! ? '닉네임' : _userData!.name,
        'hint': hintList,
        'isOpenedHint': [false, false, false], //bool List
        'isOpened': false,
      });

      Get.to(() => AnswerCompleteScreen(), arguments: name);
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                SizedBox(
                  width: 80.0,
                  height: 80.0,
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(profileImage),
                  ),
                ),
                const Padding(padding: EdgeInsets.all(10.0)),
                Text(
                  askText,
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
            onChanged: (value) {
              setState(() {
                textValue = value;
              });
            },
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
                _checkSecret = value;
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
                await _uploadUserToFirebase();
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
