import 'package:flutter/material.dart';

class AnswerPage extends StatefulWidget {
  const AnswerPage({super.key});

  @override
  _AnswerPageState createState() => _AnswerPageState();
}

class _AnswerPageState extends State<AnswerPage> {
  var questionList = ['내 첫인상은 어땠어?', '내 mbti는 무엇인 것 같아?', '나랑 닮은 동물은 뭐야?'];
  String askText = '내 첫인상은 어땠어?';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _answerBody(),
    );
  }

  Widget _answerBody() {
    return Column(
      children: [
        closeBtn(),
        const Text(
          "답변 작성",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 27.0),
        ),
        _answerCard(),
      ],
    );
  }

  Widget closeBtn() {
    return const IconButton(
      onPressed: null,
      icon: Icon(Icons.one_x_mobiledata_rounded),
      color: Colors.black,
      iconSize: 40.0,
    );
  }

  Widget _answerCard() {
    return SizedBox(
      width: 346.0,
      height: 346.0,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        color: const Color(0xff9754FB),
        child: Column(
          children: <Widget>[
            const Padding(padding: EdgeInsets.all(5.0)),
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
          ],
        ),
      ),
    );
  }
}
