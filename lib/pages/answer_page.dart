import 'package:flutter/material.dart';
import 'package:cooing_front/pages/main_page.dart';

class AnswerPage extends StatefulWidget {
  const AnswerPage({super.key});

  @override
  _AnswerPageState createState() => _AnswerPageState();
}

class _AnswerPageState extends State<AnswerPage> {
  var questionList = ['내 첫인상은 어땠어?', '내 mbti는 무엇인 것 같아?', '나랑 닮은 동물은 뭐야?'];
  String askText = '내 첫인상은 어땠어?';
  bool? _checkSecret = false;
  int maxLength = 100;
  String textValue = "";
  final TextEditingController _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          leading: IconButton(
            icon: const Icon(Icons.close_rounded),
            color: Colors.black54,
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: SafeArea(child: _answerBody()),
        bottomSheet: SafeArea(
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Padding(
                padding: EdgeInsets.only(
                  bottom:
                      MediaQuery.of(context).systemGestureInsets.bottom + 15,
                ),
                child: sendBtn())
          ]),
        ));
  }

  Widget _answerBody() {
    return SingleChildScrollView(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SingleChildScrollView(
          child: Row(
            children: [
              Padding(padding: EdgeInsets.all(15.0)),
              Text(
                "답변 작성",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22.0,
                ),
                textAlign: TextAlign.center,
              )
            ],
          ),
        ),
        const Padding(padding: EdgeInsets.all(7.0)),
        _answerCard(),
        checking(),
      ],
    ));
  }

  Widget _answerCard() {
    return Center(
        child: SizedBox(
            width: 346.0,
            height: 355.0,
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
                answerTxtField(),
              ]),
            )));
  }

  Widget answerTxtField() {
    // String textLength = "0 / maxLength";

    return SizedBox(
        width: 300,
        height: 150,
        child: Column(children: [
          TextField(
            enableSuggestions: false,
            autocorrect: false,
            style: const TextStyle(color: Colors.white70),
            controller: _textController,
            maxLines: 5,
            maxLength: 100,
            onChanged: (value) {
              setState(() {
                textValue = value;
              });
            },
            decoration: InputDecoration(
              counterText: "",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: const BorderSide(width: 0, style: BorderStyle.none),
              ),
              contentPadding: const EdgeInsets.all(10),
              filled: true,
              fillColor: Colors.white24,
              hintText: '당신의 진심을 담은 답변을 적어주세요',
              hintStyle: const TextStyle(
                fontSize: 14,
                color: Colors.white38,
              ),
            ),
          ),
          const Padding(padding: EdgeInsets.all(4)),
          SizedBox(
              height: 13,
              child: Row(children: [
                const Padding(padding: EdgeInsets.only(right: 242)),
                Text(
                  "${textValue.length} / $maxLength",
                  style: const TextStyle(color: Colors.white54, fontSize: 13),
                )
              ])),
        ]));
  }

  Widget checking() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Transform.scale(
          scale: 1.4,
          child: Checkbox(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
            activeColor: const Color(0xff9754FB),
            focusColor: const Color(0xff9754FB),
            value: _checkSecret,
            onChanged: (value) {
              setState(() {
                _checkSecret = value;
              });
            },
          ),
        ),
        const Text(
          '익명',
          style: TextStyle(fontSize: 14, color: Color(0xff333D4B)),
        )
      ],
    );
  }

  Widget sendBtn() {
    return Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
      SizedBox(
        width: 350,
        height: 60,
        child: ElevatedButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const MainPage()));
            },
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: const Color(0xff9754FB),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
            ),
            child: const Text(
              "보내기",
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            )),
      )
    ]);
  }
}
