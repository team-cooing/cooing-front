import 'package:cooing_front/providers/UserProvider.dart';
import 'package:flutter/material.dart';
import "dart:math";
import "dart:async";
import 'package:cooing_front/widgets/link.dart';
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
  // final DynamicLink _link = DynamicLink();
  // final String _userId = 'id';
  // final String _userUri = '';

  //타이머 관련
  String timeAttack = '';
  double timeAttackSize = 0.0;
  late Color timetextColor = _colors[0];
  Timer? _timer;
  Duration _countdown = Duration.zero;
  bool _isRunning = false;

  changeAskCard() {
    setState(() {
      switch (askButtonText) {
        case '질문 받기':
          //질문
          var question = questionList[_random.nextInt(questionList.length)];
          cardHeight = 305.0;
          askText = question;
          askButtonText = getAnswer;
          timeAttackSize = 12.0;
          _startTimer();
          break;
        case '답변 받기':
          DateTime nowDate = DateTime.now();
          print('$nowDate');
          DateTime closeDate = nowDate.add(const Duration(hours: 24));
          timetextColor = _colors[2];
          askButtonText = closeAsk;
          buttonColor = _colors[1];
          askClosedMent =
              '해당 질문은 ${closeDate.day}일 ${closeDate.hour}시 ${closeDate.minute}분부터 닫을 수 있습니다.';
          askClosedMentSize = 10.0;
          _openshareCard = true;

          break;

        case '질문 닫기':
          var question = questionList[_random.nextInt(questionList.length)];
          askText = question;
          askClosedMent = '새로운 질문이 도착했어요!';
          buttonColor = _colors[0];

          timeAttackSize = 0.0;
          _resetTimer();
          break;
      }
    });
  }

  void _startTimer() {
    final now = DateTime.now();
    final endOfDay = DateTime(now.year, now.month, now.day + 1);
    final remainingSeconds = endOfDay.difference(now).inSeconds;
    setState(() {
      _countdown = Duration(seconds: remainingSeconds);
      _isRunning = true;
    });
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_countdown.inSeconds == 0) {
          _timer?.cancel();
          _isRunning = false;
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
          shareCard(),
        ]))));
  }

  Widget padding(double num) {
    return Padding(padding: EdgeInsets.all(num));
  }

  Widget pupleBox() {
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
                    fontSize: timeAttackSize,
                  ))
            ]),
            const Padding(padding: EdgeInsets.all(15.0)),
            Consumer<UserDataProvider>(builder: (context, provider, child) {
              final userData = provider.userData;
              if (userData == null) {
                return const CircularProgressIndicator();
              } else {
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
              askText,
              textAlign: TextAlign.left,
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.white),
            ),
            Container(
              padding: EdgeInsets.all(25.0),
              child: OutlinedButton(
                onPressed: () => changeAskCard(),
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                  foregroundColor: const Color(0xff9754FB),
                  backgroundColor: buttonColor,
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
              askClosedMent,
              style:
                  TextStyle(color: Colors.white, fontSize: askClosedMentSize),
            ),
            const Padding(padding: EdgeInsets.all(9.0)),
          ],
        ),
      ),
    );
  }

  Widget shareCard() {
    if (_openshareCard == true) {
      return (Column(children: <Widget>[
        Container(
          padding: const EdgeInsets.only(top: 20),
          child: SizedBox(
            width: double.infinity,
            height: 90.0,
            child: Container(
              padding: EdgeInsets.all(25.0),
              decoration: BoxDecoration(
                  color: Color(0xffF2F3F3),
                  borderRadius: BorderRadius.circular(20)),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            SizedBox(
                                width: 25.0,
                                height: 25.0,
                                child: Image(
                                    image: AssetImage(
                                        'images/icon_copyLink.png'))),
                            Padding(padding: EdgeInsets.only(right: 10.0)),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "1단계",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Color(0xff333D4B),
                                  ),
                                ),
                                Text(
                                  "링크 복사하기",
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: Color(0xff333D4B),
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            )
                          ],
                        )
                      ],
                    ),
                    ElevatedButton(
                        onPressed: () {},
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white,
                          shadowColor: Colors.transparent,
                          backgroundColor: Color.fromRGBO(151, 84, 251, 1),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0)),
                        ),
                        child: const Text(
                          "복사",
                          style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ))
                  ]),
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.only(top: 20),
          child: SizedBox(
            width: double.infinity,
            height: 90.0,
            child: Container(
              padding: EdgeInsets.all(25.0),
              decoration: BoxDecoration(
                  color: Color(0xffF2F3F3),
                  borderRadius: BorderRadius.circular(20)),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            SizedBox(
                                width: 25.0,
                                height: 25.0,
                                child: Image(
                                    image: AssetImage(
                                        'images/icon_instagram.png'))),
                            Padding(padding: EdgeInsets.only(right: 10.0)),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "2단계",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Color(0xff333D4B),
                                  ),
                                ),
                                Text(
                                  "친구들에게 공유",
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: Color(0xff333D4B),
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            )
                          ],
                        )
                      ],
                    ),
                    ElevatedButton(
                        onPressed: () {},
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white,
                          shadowColor: Colors.transparent,
                          backgroundColor: Color.fromRGBO(151, 84, 251, 1),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0)),
                        ),
                        child: const Text(
                          "복사",
                          style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ))
                  ]),
            ),
          ),
        ),
      ]));
    } else {
      return const Padding(padding: EdgeInsets.all(3.0));
    }
  }
}
