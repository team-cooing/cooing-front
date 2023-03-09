import 'package:flutter/material.dart';
import "dart:math";

class QuestionPage extends StatefulWidget {
  const QuestionPage({super.key});

  @override
  _QuestionPageState createState() => _QuestionPageState();
}

class _QuestionPageState extends State<QuestionPage> {
  String checking = '<버튼누름>';
  String askDefault = '똑똑똑! 오늘의 질문이 도착했어요.';
  String getAsk = '질문 받기';
  String getAnswer = '답변 받기';
  String closeAsk = '질문 닫기';

  late String askText = askDefault;
  late String askButtonText = getAsk;

  var questionList = ['내 첫인상은 어땠어?', '내 mbti는 무엇인 것 같아?', '나랑 닮은 동물은 뭐야?'];

  final _random = Random();

  changeAskCard() {
    var question = questionList[_random.nextInt(questionList.length)];

    setState(() {
      askText = question;
      askButtonText = getAnswer;
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
              height: 273.0,
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
                color: const Color(0xff9754FB),
                child: Column(
                  children: <Widget>[
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
                    const Padding(padding: EdgeInsets.all(20.0)),
                    OutlinedButton(
                      onPressed: () => changeAskCard(),
                      style: OutlinedButton.styleFrom(
                        fixedSize: const Size(154, 50),
                        foregroundColor: const Color(0xff9754FB),
                        backgroundColor: Colors.white,
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
                    const Padding(padding: EdgeInsets.all(10.0)),
                  ],
                ),
              ))
        ])))));
  }
}
