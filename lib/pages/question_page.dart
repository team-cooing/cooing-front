import 'package:flutter/material.dart';
import "dart:math";
import "package:cooing_front/widgets/timer_widget.dart";

class QuestionPage extends StatefulWidget {
  const QuestionPage({super.key});

  @override
  _QuestionPageState createState() => _QuestionPageState();
}

class _QuestionPageState extends State<QuestionPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  double cardHeight = 400.0;
  double timeAttackSize = 0.0;
  double askClosedMentSize = 0.0;
  String checking = '<버튼누름>';
  String askDefault = '똑똑똑! 오늘의 질문이 도착했어요.';
  String getAsk = '질문 받기';
  String getAnswer = '답변 받기';
  String closeAsk = '질문 닫기';
  var questionList = ['내 첫인상은 어땠어?', '내 mbti는 무엇인 것 같아?', '나랑 닮은 동물은 뭐야?'];
  final _random = Random();

  String timeAttack = '';
  String askClosedMent = '';
  final List<Color> _colors = <Color>[
    Colors.white,
    const Color(0xffe0cbfe),
    const Color(0xff9754FB)
  ];

  late Color timetextColor = _colors[0];
  late String askText = askDefault;
  late String askButtonText = getAsk;
  late Color buttonColor = _colors[0];

  TimerWidget? Timer;

  changeAskCard() {
    setState(() {
      switch (askButtonText) {
        case '질문 받기':
          var question = questionList[_random.nextInt(questionList.length)];
          cardHeight = 305.0;
          askText = question;
          askButtonText = getAnswer;
          timeAttack = '남은 시간 13:04:03';

          break;
        case '답변 받기':
          padding(8.0);
          copyLink();
          padding(8.0);
          shareInsta();

          timetextColor = _colors[2];
          timeAttackSize = 0.0;
          askButtonText = closeAsk;
          buttonColor = _colors[1];
          askClosedMent = '해당 질문은 22일 00시부터 닫을 수 있습니다.';
          askClosedMentSize = 10.0;

          break;

        case '질문 닫기':
          var question = questionList[_random.nextInt(questionList.length)];
          askText = question;
          askClosedMent = '새로운 질문이 도착했어요!';
          buttonColor = _colors[0];
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
        ])))));
  }

  Widget padding(double num) {
    return Padding(padding: EdgeInsets.all(num));
  }

  Widget copyLink() {
    return SizedBox(
      width: 347.0,
      height: 98.0,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        color: const Color(0xffF2F3F3),
      ),
    );
  }

  Widget shareInsta() {
    return SizedBox(
      width: 347.0,
      height: 98.0,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        color: const Color(0xffF2F3F3),
      ),
    );
  }

  Widget pupleBox() {
    return SizedBox(
      width: 347.0,
      height: cardHeight,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        color: const Color(0xff9754FB),
        child: Column(
          children: <Widget>[
            const Padding(padding: EdgeInsets.all(9.0)),
            const SizedBox(height: 12, width: 80, child: TimerWidget()),
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
