import 'package:flutter/material.dart';
import "dart:math";
import "dart:async";

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

  //time
  Timer? _secTimer;
  Timer? _minTimer;
  Timer? _hourTimer;
  var _secTime = 1;
  var _minTime = 1;
  var _hourTime = 1;
  var _isPlaying = false;
  String timeAttack = '';
  double timeAttackSize = 0.0;
  late Color timetextColor = _colors[0];

  //shareCard
  bool _openshareCard = false;

  @override
  void dispose() {
    _secTimer?.cancel();
    _minTimer?.cancel();
    _hourTimer?.cancel();
    super.dispose();
  }

  void _click() {
    _isPlaying = !_isPlaying;

    if (_isPlaying) {
      _start();
    } else {
      _reset();
    }
  }

  void _start() {
    _secTimer = Timer.periodic(const Duration(seconds: 1), (secTimer) {
      setState(() {
        _secTime++;
        if (_secTime > 60) {
          _secTime %= 60;
        }
      });
    });

    _minTimer = Timer.periodic(const Duration(minutes: 1), (minTimer) {
      setState(() {
        _minTime++;
        if (_minTime > 60) {
          _minTime %= 60;
        }
      });
    });

    _hourTimer = Timer.periodic(const Duration(hours: 1), (hourTimer) {
      setState(() {
        _hourTime++;
      });
    });
  }

  void _reset() {
    setState(() {
      _isPlaying = false;
      _secTimer?.cancel();
      _minTimer?.cancel();
      _hourTimer?.cancel();

      _secTime = 1;
      _minTime = 0;
      _hourTime = 0;
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
          _click();

          break;
        case '답변 받기':
          timetextColor = _colors[2];
          askButtonText = closeAsk;
          buttonColor = _colors[1];
          askClosedMent = '해당 질문은 22일 00시부터 닫을 수 있습니다.';
          askClosedMentSize = 10.0;
          _openshareCard = true;

          break;

        case '질문 닫기':
          var question = questionList[_random.nextInt(questionList.length)];
          askText = question;
          askClosedMent = '새로운 질문이 도착했어요!';
          buttonColor = _colors[0];
          _reset();
          timeAttackSize = 0.0;
          break;
      }
    });
  }

  copyLink(){
    
  }

  shareInsta(){
    
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
          const Padding(padding: EdgeInsets.all(8.0)),
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
              const Column(
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
                  onPressed: null,
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
              const Column(
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

  String timeText() {
    var hour = 24 - (_hourTime);
    var minute = 60 - (_minTime);
    var sec = 60 - (_secTime);

    String time = '남은 시간 $hour : $minute : $sec';

    return time;
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
            const Padding(padding: EdgeInsets.all(5.0)),
            Container(
                padding: const EdgeInsets.only(right: 175.0),
                child: Text(timeText(),
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
