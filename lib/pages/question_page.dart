import 'package:flutter/material.dart';

class QuestionPage extends StatefulWidget {
  const QuestionPage({super.key});

  @override
  _QuestionPageState createState() => _QuestionPageState();
}

class _QuestionPageState extends State<QuestionPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _askBody(),
    );
  }

  Widget _askBody() {
    const String checking = '<버튼누름>';
    const String askNotice = '똑똑똑! 오늘의 질문이 도착했어요.';
    const String askGet = '질문 받기';

    List<Widget> _askCard(List myCard) {
      var list = myCard.map<List<Widget>>(
        (data) {
          var widgetList = <Widget>[];
          widgetList.add(const Padding(padding: EdgeInsets.all(8.0)));
          widgetList.add(const SizedBox(
              width: 80.0,
              height: 80.0,
              child: CircleAvatar(
                backgroundImage: AssetImage('images/sohee.jpg'),
              )));
          widgetList.add(const Padding(padding: EdgeInsets.all(10.0)));
          widgetList.add(const Text(
            askNotice,
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white),
          ));
          widgetList.add(const Padding(padding: EdgeInsets.all(20.0)));
          widgetList.add(OutlinedButton(
            onPressed: () => print(checking),
            style: OutlinedButton.styleFrom(
              fixedSize: const Size(154, 50),
              foregroundColor: const Color(0xff9754FB),
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: const Text(
              askGet,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ));
          widgetList.add(const Padding(padding: EdgeInsets.all(10.0)));

          return widgetList;
        },
      ).toList();

      var flat = list.expand((i) => i).toList();
      return flat;
    }

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
                    const Text(
                      askNotice,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.white),
                    ),
                    const Padding(padding: EdgeInsets.all(20.0)),
                    OutlinedButton(
                      onPressed: () => print(checking),
                      style: OutlinedButton.styleFrom(
                        fixedSize: const Size(154, 50),
                        foregroundColor: const Color(0xff9754FB),
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text(
                        askGet,
                        style: TextStyle(
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
