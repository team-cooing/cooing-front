import 'package:flutter/material.dart';
import "dart:math";

class QuestionPage extends StatefulWidget {
  const QuestionPage({super.key});

  @override
  _QuestionPageState createState() => _QuestionPageState();
}

class _QuestionPageState extends State<QuestionPage> {
  double cardHeight = 273.0;
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

  changeAskCard() {
    setState(() {
      switch (askButtonText) {
        case '질문 받기':
          var question = questionList[_random.nextInt(questionList.length)];
          cardHeight = 305.0;
          askText = question;
          askButtonText = getAnswer;
          timeAttack = '남은 시간 13:04:03';
          timeAttackSize = 12.0;

          break;
        case '답변 받기':
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
    return Scaffold(
      body: _askBody(),
    );
  }

  Widget _askBody() {
    // List<Widget> _askCard(List myCard) {
    //   var list = myCard.map<List<Widget>>(
    //     (data) {
    //       var widgetList = <Widget>[];
    //       widgetList.add(const Padding(padding: EdgeInsets.all(8.0)));
    //       widgetList.add(const SizedBox(
    //           width: 80.0,
    //           height: 80.0,
    //           child: CircleAvatar(
    //             backgroundImage: AssetImage('images/sohee.jpg'),
    //           )));
    //       widgetList.add(const Padding(padding: EdgeInsets.all(10.0)));
    //       widgetList.add(Text(
    //         askDefault,
    //         style: const TextStyle(
    //             fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white),
    //       ));
    //       widgetList.add(const Padding(padding: EdgeInsets.all(20.0)));
    //       widgetList.add(OutlinedButton(
    //         onPressed: () => print(checking),
    //         style: OutlinedButton.styleFrom(
    //           fixedSize: const Size(154, 50),
    //           foregroundColor: const Color(0xff9754FB),
    //           backgroundColor: Colors.white,
    //           shape: RoundedRectangleBorder(
    //             borderRadius: BorderRadius.circular(30),
    //           ),
    //         ),
    //         child: Text(
    //           getAsk,
    //           style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
    //         ),
    //       ));
    //       widgetList.add(const Padding(padding: EdgeInsets.all(10.0)));

    //       return widgetList;
    //     },
    //   ).toList();

    //   var flat = list.expand((i) => i).toList();
    //   return flat;
    // }

    return Padding(
        padding: const EdgeInsets.all(15.0),
        child: SafeArea(
            child: SingleChildScrollView(
                child: Center(
                    child: Column(children: <Widget>[
          const Padding(padding: EdgeInsets.all(8.0)),
          SizedBox(
            width: 347.0,
            height: cardHeight,
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)),
              color: const Color(0xff9754FB),
              child: Column(
                children: <Widget>[
                  const Padding(padding: EdgeInsets.all(9.0)),
                  Container(
                      padding: const EdgeInsets.only(right: 190.0),
                      child: Text(
                        timeAttack,
                        style: TextStyle(
                            color: timetextColor, fontSize: timeAttackSize),
                      )),
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
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ),
                  const Padding(padding: EdgeInsets.all(8.0)),
                  Text(
                    askClosedMent,
                    style: TextStyle(
                        color: Colors.white, fontSize: askClosedMentSize),
                  ),
                  const Padding(padding: EdgeInsets.all(0.0)),
                ],
              ),
            ),
          )
        ])))));
  }
}
