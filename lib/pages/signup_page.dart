import 'package:flutter/material.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final List<String> _textList = [
    '이름을 입력해주세요.',
    '휴대폰 번호를 입력해주세요.',
    '나이를 입력해주세요.'
  ];
  @override
  Widget build(BuildContext context) {
    // final node1 = FocusNode();

    return GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
            ),
            backgroundColor: Color(0xFFffffff),
            body: Container(
              padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
              child: Form(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _textList[0],
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                            color: Color.fromARGB(255, 51, 61, 75)),
                      ),
                      TextField(
                        // focusNode: node1,
                        decoration: InputDecoration(
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color.fromARGB(255, 151, 84, 251))),
                            labelText: "이름",
                            labelStyle: new TextStyle(
                                color: Color.fromARGB(255, 182, 183, 184))),
                      ),
                      Spacer(),
                      SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                primary: Color.fromARGB(255, 151, 84, 251)),
                            child: const Text('확인',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 15)),
                            onPressed: () {},
                          ))
                    ]),
              ),
            )));
  }
}
