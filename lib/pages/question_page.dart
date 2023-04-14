import 'package:cooing_front/widgets/firebase_method.dart';
import 'package:cooing_front/widgets/share_card.dart';
import 'package:cooing_front/model/Question.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import "dart:async";
import 'package:cooing_front/providers/UserProvider.dart';
import 'package:provider/provider.dart';

class QuestionPage extends StatefulWidget {
  const QuestionPage({super.key});

  @override
  _QuestionPageState createState() => _QuestionPageState();
}

class _QuestionPageState extends State<QuestionPage>
    with AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  bool get wantKeepAlive => true;

  Object? questionId;
  Map<String, dynamic> randomQ = {"id": -1, "question": ""};

  //버튼 text
  String getAsk = '질문 받기';
  bool isButtonEnabled = true;
  bool isViewContent = false;
  String btnBottomMent = '';
  String viewContentText = '';
  final List<Color> _colors = <Color>[
    Colors.white,
    const Color(0xffe0cbfe),
    const Color(0xff9754FB)
  ];

  late String askButtonText = getAsk;

  //shareCard
  bool openShareCard = false;

  //타이머 관련
  Timer? _timer;
  Duration _countdown = Duration.zero;
  bool _isRunning = false; //타이머 isRunning
  DateTime receiveTime = DateTime.now(); //초기화
  DateTime closeDate = DateTime.now(); //초기화
  //임시 questionInfos
  List<List<dynamic>> questionInfos = [
    [44, '2023-04-14 11:33:36.920692']
  ];
  late List<dynamic> currentQuestion;
  late String currentQuestionId;

// Firebase Firestore 컬렉션 참조
  CollectionReference questionCollectionRef =
      FirebaseFirestore.instance.collection('questions');
// 'questions'  의 document reference 초기화
  late DocumentReference questionDocRef;
  late Question newQuestion = Question(
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

  //open 하기 전인 상태에서 버튼 눌렀을 때(질문 받기 누른 후), 변화

//질문 받, 답장x 인 상태에서 버튼 눌렀을 때(답장받기 누른 후), 변화
  openButNotReceive() {
    askButtonText = '질문 닫기'; //버튼 text는 질문닫기로 변경
    openShareCard = true; //아래에 share card 생성
    isButtonEnabled = false;
  }

//답장o 닫는시간x (closeTime 지나기 전)
  receiveButNotClose() {
    askButtonText = '질문 닫기';
    isButtonEnabled = false;
    openShareCard = true; //아래에 share card 생성
  }

//답장o 닫는시간지남(closeTime 지난 후)
  receiveAndClose() {
    isButtonEnabled = true;
    askButtonText = '질문 닫기';
    openShareCard = true; //아래에 share card 생성
  }

  changeAskCard() {
    setState(() {
      switch (askButtonText) {
        case '질문 받기':
          openShareCard = false;
          //질문
          isViewContent = true;
          randomQ = filterQuestion(questionInfos);
          newQuestion.content = randomQ['question'].toString();
          newQuestion.contentId = randomQ['id'] as int;
          print(newQuestion.content);
          viewContentText = newQuestion.content;
          _startTimer(); //openTime
          questionDocRef = questionCollectionRef
              .doc(newQuestion.id); //title이 id인 firebase document reference 생성
          addNewQuestion(questionDocRef, newQuestion);
          askButtonText = '답변 받기'; //버튼 text는 답변받기로 변경

          break;

        case '답변 받기':
          openButNotReceive();
          _resetTimer();
          newQuestion.isValidity = true;

          String url = 'www.kookmin.ac.kr/12345'; //임시 url
          receiveTime = DateTime.now();
          closeDate = receiveTime.add(const Duration(hours: 24));
          newQuestion.receiveTime = receiveTime.toString();
          updateQuestion(
              'receiveTime', newQuestion.receiveTime, questionDocRef);
          updateQuestion('url', url, questionDocRef);
          updateQuestion('isValidity', true, questionDocRef);

          btnBottomMent =
              '해당 질문은 ${closeDate.day}일 ${closeDate.hour}시 ${closeDate.minute}분부터 닫을 수 있습니다.';
          askButtonText = '질문 닫기'; //버튼 text는 답변받기로 변경

          break;

        case '질문 닫기':
          if (DateTime.now().isAfter(closeDate)) {
            receiveAndClose();

            updateQuestion('isValidity', false, questionDocRef);
            askButtonText = '질문 받기'; //버튼 text는 답변받기로 변경
          }
          break;
      }
    });
  }

  void _startTimer() {
    if (newQuestion.openTime == "") {
      final openTime = DateTime.now();
      newQuestion.openTime = openTime.toString();
      newQuestion.id = openTime.toString();
    }
    print(newQuestion.openTime);
    DateTime openTime = DateTime.parse(newQuestion.openTime);
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
          if (openShareCard == false) {
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
    try {
      if (questionInfos.isNotEmpty) {
        currentQuestion = questionInfos.last;
        currentQuestionId = currentQuestion[1];
        questionDocRef = FirebaseFirestore.instance
            .collection('questions')
            .doc(currentQuestionId);

        getDocument(questionDocRef, currentQuestionId).then((value) {
          setState(() {
            newQuestion = value;
          });
        });
      }
    } catch (e) {
      print('에러');
    }
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
          shareCard(openShareCard),
        ]))));
  }

  Widget padding(double num) {
    return Padding(padding: EdgeInsets.all(num));
  }

  Widget pupleBox() {
    print(newQuestion);
    if (newQuestion.isValidity == false) {
      if (newQuestion.openTime == "") {
        //질문 open 안한 상태
      } else if (newQuestion.receiveTime == "") {
        //질문 받았으나 답변받기 안누른 상태
        _isRunning = true; //timer
        isViewContent = true;
        viewContentText = newQuestion.content;
        askButtonText = '답변 받기';
      }
    } else {
      //답변받기 누른 상태
      //closeTime 전이면
      isViewContent = true;
      viewContentText = newQuestion.content;
      askButtonText = '질문 닫기';
      isButtonEnabled = false;
      openShareCard = true;
      DateTime rcvTime = DateTime.parse(newQuestion.receiveTime);
      closeDate = rcvTime.add(const Duration(hours: 24));
      btnBottomMent =
          '해당 질문은 ${closeDate.day}일 ${closeDate.hour}시 ${closeDate.minute}분부터 닫을 수 있습니다.';

      if (DateTime.now().isAfter(closeDate)) {
        setState(() {
          print(DateTime.now());
          receiveAndClose();
          isButtonEnabled = true;

          updateQuestion('isValidity', false, questionDocRef);
        });
      }
    }

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
                questionInfos = [];
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
              isViewContent ? viewContentText : '똑똑똑! 오늘의 질문이 도착했어요.',
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
                  color: Colors.white, fontSize: openShareCard ? 10 : 0),
            ),
            const Padding(padding: EdgeInsets.all(9.0)),
          ],
        ),
      ),
    );
  }
}
