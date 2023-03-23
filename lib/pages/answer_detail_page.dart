import 'package:flutter/material.dart';

class AnswerDetailPage extends StatefulWidget {
  const AnswerDetailPage({super.key});

  @override
  _AnswerDetailPageState createState() => _AnswerDetailPageState();
}

class _AnswerDetailPageState extends State<AnswerDetailPage> {
  String askText = '내 첫인상은 어땠어?';
  bool? isAnonymous = false;
  int maxLength = 100;
  String textValue =
      "너는 \n처음 봤을 때 왠\n지 다가가기 어려웠는데\n막상 이ㅎㅎ야기하고 나니까 \n좋았던 것 같아.\n생각보다 착해!ㅋzzzzzzzzzzzz\nㅋ\nㅋ\nㅋ\nㅋ\nㅋ";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        leading: IconButton(
          icon: const Icon(Icons.navigate_before_rounded),
          iconSize: 30,
          color: Colors.black54,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
              onPressed: () {
                print("Clicked the Warning");
              },
              icon: Icon(Icons.warning_rounded),
              iconSize: 30,
              color: Colors.black45),
          Padding(
            padding: EdgeInsets.all(5),
          )
        ],
      ),
      body: SafeArea(child: _answerBody()),
    );
  }

  Widget _answerBody() {
    return SizedBox(
      child: Column(children: [
        SingleChildScrollView(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(
            children: [
              Padding(padding: EdgeInsets.only(left: 20, top: 20.0)),
              Text(
                "답변 확인",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22.0,
                ),
                textAlign: TextAlign.center,
              )
            ],
          ),
          const Padding(padding: EdgeInsets.all(10.0)),
          fromMsgTxt(isAnonymous),
          const Padding(padding: EdgeInsets.all(7.0)),
          _answerDetailCard(),
          bottomBtns(isAnonymous)
        ])),
      ]),
    );
  }

  Widget fromMsgTxt(bool? isAnony) {
    var name = '';

    if (isAnony == true) {
      name = '훌륭한 남학생';
    } else {
      name = '박길현';
    }

    return Center(
      child: Text(
        "$name이 보낸 메시지",
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _answerDetailCard() {
    return Center(
        child: SizedBox(
            width: 350.0,
            height: 370.0,
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)),
              color: const Color(0xff9754FB),
              child: Column(children: <Widget>[
                const Padding(padding: EdgeInsets.all(15.0)),
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
                answerTxtView(),
              ]),
            )));
  }

  Widget answerTxtView() {
    return Container(
        width: 300,
        height: 150,
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white, width: 0)),
        child: SingleChildScrollView(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Padding(
            padding: EdgeInsets.only(left: 10),
            child: Container(
                child: Text(
              textValue,
              style: TextStyle(
                color: Colors.black,
              ),
            )),
          ),
        ])));
  }

  Widget bottomBtns(bool? isAnony) {
    var checkFromBtn = SizedBox(
      width: 350,
      height: 60,
      child: ElevatedButton(
          onPressed: () {
            print('Clicked : <누가보냈는지확인하기>');
          },
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: const Color(0xff9754FB),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
          ),
          child: const Text(
            "누가 보냈는지 확인하기",
            style: TextStyle(
                fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
          )),
    );

    var replyBtn = SizedBox(
      width: 350,
      height: 60,
      child: ElevatedButton(
          onPressed: () {
            print("Clicked : <답장하기>");
          },
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: const Color(0xff333D4B),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
          ),
          child: const Text(
            "답장하기",
            style: TextStyle(
                fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
          )),
    );

    if (isAnony == true) {
      return Padding(
          padding: EdgeInsets.only(top: 90),
          child: Center(
              child: Column(children: [
            checkFromBtn,
            Padding(padding: EdgeInsets.all(5)),
            replyBtn
          ])));
    }

    return Padding(
        padding: EdgeInsets.only(top: 160), child: Center(child: replyBtn));
  }
}
