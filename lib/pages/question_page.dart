import 'package:cooing_front/providers/UserProvider.dart';
import 'package:cooing_front/model/Question.dart';
import 'package:cooing_front/model/question_list.dart';
import 'package:cooing_front/widgets/share_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import "dart:math";
import "dart:async";
import 'package:provider/provider.dart';

class QuestionPage extends StatefulWidget {
  const QuestionPage({super.key});

  @override
  _QuestionPageState createState() => _QuestionPageState();
}

class _QuestionPageState extends State<QuestionPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  Object? questionId;
  Map<String, Object> randomQ = {"id": -1, "question": ""};

  //버튼 text
  String getAsk = '질문 받기';
  bool isButtonEnabled = true;

  String btnBottomMent = '';
  final List<Color> _colors = <Color>[
    Colors.white,
    const Color(0xffe0cbfe),
    const Color(0xff9754FB)
  ];

  late String askButtonText = getAsk;

  //shareCard
  bool _openshareCard = false;

  //타이머 관련
  Timer? _timer;
  Duration _countdown = Duration.zero;
  bool _isRunning = false; //타이머 isRunning
  DateTime closeDate = DateTime.now();
// 새 Question 객체 생성
  Question newQuestion = Question(
    id: '',
    ownerProfileImage: '',
    ownerName: '',
    owner: '',
    content: '',
    contentId: 0,
    receiveTime: '',
    openTime: '',
    url: '',
    isValidity: false,
  );

  //임시 questioned List
  List<Map<String, Object>> questionedList = [
    {"id": 0, "question": "나를 장난감에 비유한다면?"},
    {"id": 1, "question": "나를 아이스크림에 비유한다면?"},
    {"id": 2, "question": "나를 영화 장르에 비유한다면?"},
    {"id": 3, "question": "나를 과자에 비유한다면?"},
  ];
// Firebase Firestore 컬렉션 참조
  CollectionReference questionCollectionRef =
      FirebaseFirestore.instance.collection('questions');

  DocumentReference? questionDocRef;
// Question 객체를 Firestore 문서로 변환하는 함수
  Map<String, dynamic> _questionToFirestoreDocument(Question question) {
    return question.toJson();
  }

// Firestore에 새로운 Question 객체를 추가하는 함수
  Future<void> addNewQuestion(
      DocumentReference? documentRef, Question question) async {
    final document = _questionToFirestoreDocument(question);
    await documentRef?.set(document);
  }

  Future<void> updateQuestion(
      String section, var updateStr, DocumentReference? docReference) async {
    Map<String, dynamic> data = {section: updateStr};
    await docReference?.update(data);
  }

  Map<String, Object> filterQuestion(questioned) {
    List<Map<String, Object>> filteredQuestions =
        questionList.where((q) => !questionedList.contains(q)).toList();
    Map<String, Object> randomQuestion =
        filteredQuestions[Random().nextInt(filteredQuestions.length)];

    questioned.add(randomQuestion);
    return randomQuestion;
  }

  changeAskCard() {
    setState(() {
      switch (askButtonText) {
        case '질문 받기':
          _openshareCard = false;
          //질문
          randomQ = filterQuestion(questionedList);
          newQuestion.content = randomQ['question'].toString();
          newQuestion.contentId = randomQ['id'] as int;
          newQuestion.isValidity = true;

          _startTimer(); //openTime
          questionDocRef = questionCollectionRef
              .doc(newQuestion.id); //title이 id인 firebase document reference 생성
          addNewQuestion(questionDocRef, newQuestion);

          askButtonText = '답변 받기';
          break;

        case '답변 받기':
          _openshareCard = true; //아래에 share card 생성
          _resetTimer();

          String url = 'www.kookmin.ac.kr/12345'; //임시 url
          DateTime receiveTime = DateTime.now();
          newQuestion.receiveTime = receiveTime.toString();
          updateQuestion(
              'receiveTime', newQuestion.receiveTime, questionDocRef);
          updateQuestion('url', url, questionDocRef);

          closeDate = receiveTime.add(const Duration(hours: 24));
          btnBottomMent =
              '해당 질문은 ${closeDate.day}일 ${closeDate.hour}시 ${closeDate.minute}분부터 닫을 수 있습니다.';
          isButtonEnabled = false;
          askButtonText = '질문 닫기';

          break;

        case '질문 닫기':
          if (DateTime.now().isAfter(closeDate)) {
            isButtonEnabled = true;
            askButtonText = '질문 받기';
          }

          break;
      }
    });
  }

  void _startTimer() {
    final openTime = DateTime.now();
    newQuestion.openTime = openTime.toString();
    newQuestion.id = openTime.toString();

    final endOfDay = DateTime(openTime.year, openTime.month, openTime.day + 1);
    final remainingSeconds = endOfDay.difference(openTime).inSeconds;
    setState(() {
      _countdown = Duration(seconds: remainingSeconds);
      _isRunning = true;
    });
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_countdown.inSeconds == 0) {
          _timer?.cancel();
          _isRunning = false;
          if (_openshareCard == false) {
            askButtonText = '질문 받기';
            questionCollectionRef.doc(newQuestion.id).delete();
          }
        } else {
          _countdown = Duration(seconds: _countdown.inSeconds - 1);
        }
      });
    });
  }

  void _resetTimer() {
    setState(() {
      _countdown = Duration.zero;
      _isRunning = false;
    });
    _timer?.cancel();
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) {
      if (n >= 10) return "$n";
      return "0$n";
    }

    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    String twoDigitHours = twoDigits(duration.inHours);

    return "남은 시간 $twoDigitHours : $twoDigitMinutes : $twoDigitSeconds";
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      body: SingleChildScrollView(child: _askBody()),
    );
  }

  Widget _askBody() {
    return Padding(
        padding: const EdgeInsets.all(25.0),
        child: SafeArea(
            child: Center(
                child: Column(children: <Widget>[
          pupleBox(),
          shareCard(_openshareCard),
        ]))));
  }

  Widget padding(double num) {
    return Padding(padding: EdgeInsets.all(num));
  }

  Widget pupleBox() {
    // Update button state
    setState(() {
      isButtonEnabled = isButtonEnabled;
    });
    String remainTimer = _formatDuration(_countdown);
    return SizedBox(
      width: double.infinity,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        color: const Color(0xff9754FB),
        child: Column(
          children: <Widget>[
            padding(5),
            Row(mainAxisAlignment: MainAxisAlignment.start, children: [
              const Padding(padding: EdgeInsets.only(left: 25.0)),
              Text(remainTimer,
                  style: TextStyle(
                      color: Colors.white,
                      backgroundColor: _colors[2],
                      fontSize: _isRunning ? 12 : 0))
            ]),
            const Padding(padding: EdgeInsets.all(15.0)),
            Consumer<UserDataProvider>(builder: (context, provider, child) {
              final userData = provider.userData;
              if (userData == null) {
                return const CircularProgressIndicator();
              } else {
                newQuestion.owner = userData.uid;
                newQuestion.ownerName = userData.name;
                newQuestion.ownerProfileImage = userData.profileImage;

                return SizedBox(
                  width: 80.0,
                  height: 80.0,
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(userData.profileImage),
                  ),
                );
              }
            }),
            const Padding(padding: EdgeInsets.all(20.0)),
            Text(
              newQuestion.isValidity
                  ? newQuestion.content
                  : '똑똑똑! 오늘의 질문이 도착했어요.',
              textAlign: TextAlign.left,
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.white),
            ),
            Container(
              padding: EdgeInsets.all(25.0),
              child: OutlinedButton(
                onPressed: isButtonEnabled ? () => changeAskCard() : null,
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                  foregroundColor: const Color(0xff9754FB),
                  backgroundColor: isButtonEnabled ? _colors[0] : _colors[1],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Text(
                  askButtonText,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
            ),
            Text(
              btnBottomMent,
              style: TextStyle(
                  color: Colors.white, fontSize: _openshareCard ? 10 : 0),
            ),
            const Padding(padding: EdgeInsets.all(9.0)),
          ],
        ),
      ),
    );
  }
}
