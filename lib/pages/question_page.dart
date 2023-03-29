import 'package:flutter/material.dart';
import "dart:math";
import "dart:async";
import 'package:cooing_front/widgets/link.dart';
import 'package:flutter/services.dart';

class QuestionPage extends StatefulWidget {
  const QuestionPage({super.key});

  @override
  _QuestionPageState createState() => _QuestionPageState();
}

class _QuestionPageState extends State<QuestionPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  double cardHeight = 273.0;
  double askClosedMentSize = 0.0;

  late String askText = '똑똑똑! 오늘의 질문이 도착했어요.';
  String getAsk = '질문 받기';
  String getAnswer = '답변 받기';
  String closeAsk = '질문 닫기';
  var questionList = ['내 첫인상은 어땠어?', '내 mbti는 무엇인 것 같아?', '나랑 닮은 동물은 뭐야?'];
  final _random = Random();

  String askClosedMent = '';
  final List<Color> _colors = <Color>[
    Colors.white,
    const Color(0xffe0cbfe),
    const Color(0xff9754FB)
  ];

  late String askButtonText = getAsk;
  late Color buttonColor = _colors[0];

  //shareCard
  bool _openshareCard = false;

  //link
  final DynamicLink _link = DynamicLink();
  final String _userId = 'id';
  String _userUri = '';

  Timer? countdownTimer;
  Duration myDuration = Duration(days: 5);

  String timeAttack = '';
  double timeAttackSize = 0.0;
  late Color timetextColor = _colors[0];

  var nowHour = 0;
  var nowMinute = 0;
  var nowSecond = 0;

  void startTimer() {
    countdownTimer =
        Timer.periodic(Duration(seconds: 1), (_) => setCountDown());
  }

  // Step 4
  void stopTimer() {
    setState(() => countdownTimer!.cancel());
  }

  // Step 5
  void resetTimer() {
    stopTimer();
    setState(() => myDuration = Duration(days: 5));
  }

  // Step 6
  void setCountDown() {
    const reduceSecondsBy = 1;
    setState(() {
      final seconds = myDuration.inSeconds - reduceSecondsBy;
      if (seconds < 0) {
        countdownTimer!.cancel();
      } else {
        myDuration = Duration(seconds: seconds);
      }
    });
  }

  changeAskCard() {
    setState(() {
      switch (askButtonText) {
        case '질문 받기':
          var question = questionList[_random.nextInt(questionList.length)];
          cardHeight = 305.0;
          askText = question;
          askButtonText = getAnswer;

          timeAttackSize = 12.0;
          DateTime now = DateTime.now();
          nowHour = now.hour;
          nowMinute = now.minute;
          nowSecond = now.second;
          print('$nowHour : $nowMinute : $nowSecond');
          startTimer();

          break;
        case '답변 받기':
          DateTime nowDate = DateTime.now();
          print('$nowDate');
          DateTime newDate = nowDate.add(const Duration(hours: 24));
          timetextColor = _colors[2];
          askButtonText = closeAsk;
          buttonColor = _colors[1];
          askClosedMent =
              '해당 질문은 ${newDate.day}일 ${newDate.hour}시 ${newDate.minute}부터 닫을 수 있습니다.';
          askClosedMentSize = 10.0;
          _openshareCard = true;

          break;

        case '질문 닫기':
          var question = questionList[_random.nextInt(questionList.length)];
          askText = question;
          askClosedMent = '새로운 질문이 도착했어요!';
          buttonColor = _colors[0];
          if (countdownTimer == null || countdownTimer!.isActive) {
            stopTimer();
          }
          timeAttackSize = 0.0;
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      body: _askBody(),
    );
  }

  Widget _askBody() {
    return Padding(
        padding: const EdgeInsets.all(15.0),
        child: SafeArea(
            child: SingleChildScrollView(
                child: Center(
                    child: Column(children: <Widget>[
          const Padding(padding: EdgeInsets.all(8.0)),
          pupleBox(),
          const Padding(padding: EdgeInsets.all(5.0)),
          shareCard(),
        ])))));
  }

  Widget padding(double num) {
    return Padding(padding: EdgeInsets.all(num));
  }

  Widget shareCard() {
    if (_openshareCard == true) {
      return (Column(children: <Widget>[
        SizedBox(
          width: 347.0,
          height: 98.0,
          child: Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            color: const Color(0xffF2F3F3),
            child: Row(children: [
              const Padding(padding: EdgeInsets.all(10.0)),
              const SizedBox(
                  width: 30.0,
                  height: 30.0,
                  child: Image(image: AssetImage('images/icon_copyLink.png'))),
              const Padding(padding: EdgeInsets.all(7.0)),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "1단계",
                    style: TextStyle(fontSize: 12, color: Color(0xff333D4B)),
                  ),
                  Text(
                    "링크 복사하기",
                    style: TextStyle(
                        fontSize: 16,
                        color: Color(0xff333D4B),
                        fontWeight: FontWeight.bold),
                  )
                ],
              ),
              const Padding(padding: EdgeInsets.all(45.0)),
              ElevatedButton(
                  onPressed: () async {
                    _userUri = await _link.getShortLink('AnswerPage', 'id');
                    Clipboard.setData(ClipboardData(text: _userUri))
                        .then((value) {
                      return ScaffoldMessenger.of(context)
                          .showSnackBar(const SnackBar(
                        content: Text("링크가 복사되었습니다."),
                      ));
                    });
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: _colors[2],
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                  ),
                  child: const Text(
                    "복사",
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ))
            ]),
          ),
        ),
        const Padding(padding: EdgeInsets.all(2.5)),
        SizedBox(
          width: 347.0,
          height: 98.0,
          child: Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            color: const Color(0xffF2F3F3),
            child: Row(children: [
              const Padding(padding: EdgeInsets.all(10.0)),
              const SizedBox(
                  width: 30.0,
                  height: 30.0,
                  child: Image(image: AssetImage('images/icon_instagram.png'))),
              const Padding(padding: EdgeInsets.all(7.0)),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "2단계",
                    style: TextStyle(fontSize: 12, color: Color(0xff333D4B)),
                  ),
                  Text(
                    "친구들에게 공유",
                    style: TextStyle(
                        fontSize: 16,
                        color: Color(0xff333D4B),
                        fontWeight: FontWeight.bold),
                  )
                ],
              ),
              const Padding(padding: EdgeInsets.all(39.0)),
              ElevatedButton(
                  onPressed: null,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: _colors[2],
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                  ),
                  child: const Text(
                    "공유",
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ))
            ]),
          ),
        )
      ]));
    } else {
      return const Padding(padding: EdgeInsets.all(3.0));
    }
  }

  Widget pupleBox() {
    String strDigits(int n) => n.toString().padLeft(2, '0');
    // Step 7
    // print()
    int hours = myDuration.inHours.remainder(24 - nowHour);
    int minutes = myDuration.inMinutes.remainder(60 - nowMinute);
    int seconds = myDuration.inSeconds.remainder(60 - nowSecond);

    if (minutes < 0) {
      minutes += 60;
    }

    if (seconds < 0) {
      seconds += 60;
    }

    if (hours < 0) {
      hours += 24;
    }

    final strHours = strDigits(hours);
    final strMinutes = strDigits(minutes);
    final strSeconds = strDigits(seconds);

    return SizedBox(
      width: 347.0,
      height: cardHeight,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        color: const Color(0xff9754FB),
        child: Column(
          children: <Widget>[
            const Padding(padding: EdgeInsets.all(5.0)),
            Container(
                padding: const EdgeInsets.only(right: 175.0),
                child: Text('남은 시간 $strHours : $strMinutes : $strSeconds',
                    style: TextStyle(
                      color: Colors.white,
                      backgroundColor: _colors[2],
                      fontSize: timeAttackSize,
                    ))),
            const Padding(padding: EdgeInsets.all(9.0)),
            const SizedBox(
              width: 80.0,
              height: 80.0,
              child: CircleAvatar(
                backgroundImage: AssetImage('images/sohee.jpg'),
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
            const Padding(padding: EdgeInsets.all(15.0)),
            OutlinedButton(
              onPressed: () => changeAskCard(),
              style: OutlinedButton.styleFrom(
                fixedSize: const Size(154, 50),
                foregroundColor: const Color(0xff9754FB),
                backgroundColor: buttonColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: Text(
                askButtonText,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
            const Padding(padding: EdgeInsets.all(8.0)),
            Text(
              askClosedMent,
              style:
                  TextStyle(color: Colors.white, fontSize: askClosedMentSize),
            ),
            const Padding(padding: EdgeInsets.all(0.0)),
          ],
        ),
      ),
    );
  }
}
