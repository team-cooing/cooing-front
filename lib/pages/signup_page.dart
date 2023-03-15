import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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

  FocusNode node1 = FocusNode();
  FocusNode numberField = FocusNode();
  FocusNode ageField = FocusNode();

  bool number = false;
  bool age = false;
  bool button = true;
  int title = 0;

  // var thirdField = FocusNode();

  @override
  Widget build(BuildContext context) {
    // final node1 = FocusNode();

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        backgroundColor: Color(0xFFffffff),
        body: Container(
          padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
          child: Form(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(
                _textList[title],
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                    color: Color.fromARGB(255, 51, 61, 75)),
              ),
              Visibility(
                visible: age,
                child: TextField(
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  // focusNode: node1,
                  onChanged: (text) {
                    if (text.length == 2) {
                      setState(() {
                        button = true;
                      });
                    }
                    print(text.length);
                    // 현재 텍스트필드의 텍스트를 출력
                  },
                  maxLength: 2,
                  focusNode: ageField,
                  autofocus: true,
                  decoration: InputDecoration(
                      counterText: '',
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: Color.fromARGB(255, 151, 84, 251))),
                      labelText: "나이",
                      labelStyle: new TextStyle(
                          color: Color.fromARGB(255, 182, 183, 184))),
                ),
              ),
              Visibility(
                visible: number,
                child: TextField(
                  autofocus: true,
                  focusNode: numberField,
                  maxLength: 11,
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  onChanged: (text) {
                    if (text.length == 11) {
                      setState(() {
                        age = true;
                        title = 2;
                        ageField.requestFocus();
                        // FocusScope.of(context).requestFocus(ageField);
                      });
                    }
                    print(text.length);
                    // 현재 텍스트필드의 텍스트를 출력
                  },
                  decoration: InputDecoration(
                      counterText: '',
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: Color.fromARGB(255, 151, 84, 251))),
                      labelText: "휴대폰 번호",
                      labelStyle: new TextStyle(
                          color: Color.fromARGB(255, 182, 183, 184))),
                ),
              ),
              TextField(
                focusNode: node1,
                autofocus: true,
                decoration: InputDecoration(
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: Color.fromARGB(255, 151, 84, 251))),
                    labelText: "이름",
                    labelStyle: new TextStyle(
                        color: Color.fromARGB(255, 182, 183, 184))),
              ),
              Spacer(),
              Visibility(
                  visible: button,
                  child: SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: Color.fromARGB(255, 151, 84, 251)),
                        child: const Text('확인',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15)),
                        onPressed: () {
                          if (!number) {
                            numberField.requestFocus();
                            setState(() {
                              button = false;
                              number = true;
                              title = 1;
                            });
                          } else {
                            print('고등학교 넘어가기');
                          }
                        },
                      )))
            ]),
          ),
        ));
  }
}
