import 'package:flutter/material.dart';

class AnswerPage extends StatefulWidget {
  const AnswerPage({super.key});

  @override
  _AnswerPageState createState() => _AnswerPageState();
}

class _AnswerPageState extends State<AnswerPage> {
  var questionList = ['내 첫인상은 어땠어?', '내 mbti는 무엇인 것 같아?', '나랑 닮은 동물은 뭐야?'];
  String askText = '내 첫인상은 어땠어?';
  final bool _checkSecret = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        leading: const IconButton(
          icon: Icon(Icons.close),
          onPressed: null,
        ),
      ),
      body: _answerBody(),
    );
  }

  Widget _answerBody() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
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
        const Padding(padding: EdgeInsets.all(7.0)),
        _answerCard(),
        checking(),
        const Padding(padding: EdgeInsets.all(85.0)),
        sendBtn()
      ],
    );
  }

  Widget _answerCard() {
    const int maxLength = 100;
    String textValue = "";

    return Center(
        child: SizedBox(
            width: 346.0,
            height: 346.0,
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)),
              color: const Color(0xff9754FB),
              child: Column(children: <Widget>[
                const Padding(padding: EdgeInsets.all(8.0)),
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
                SizedBox(
                    width: 300,
                    height: 125,
                    child: TextField(
                      textAlign: TextAlign.left,
                      expands: true,
                      maxLines: null,
                      maxLength: maxLength,
                      onChanged: (value) {
                        setState(() {
                          textValue = value;
                        });
                      },
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: const BorderSide(
                                  width: 0, style: BorderStyle.none)),
                          contentPadding: const EdgeInsets.all(20),
                          filled: true,
                          fillColor: Colors.white24,
                          hintText: '당신의 진심을 담은 답변을 적어주세요',
                          hintStyle: const TextStyle(
                              fontSize: 14, color: Colors.white38),
                          counterText: "",
                          suffix: Text("${textValue.length} / $maxLength")),
                    )),
              ]),
            )));
  }

  Widget checking() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Transform.scale(
          scale: 1.5,
          child: Checkbox(
            activeColor: Colors.amberAccent,
            value: _checkSecret,
            onChanged: (value) {
              setState(() {});
            },
          ),
        ),
        const Text(
          '악명',
          style: TextStyle(fontSize: 14, color: Color(0xff333D4B)),
        )
      ],
    );
  }

  Widget sendBtn() {
    return Center(
        child: SizedBox(
            width: 350,
            height: 60,
            child: ElevatedButton(
                onPressed: null,
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
                ))));
  }
}
