import 'package:cooing_front/pages/SchoolScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ClassScreen extends StatefulWidget {
  const ClassScreen({super.key});

  @override
  _ClassScreenState createState() => _ClassScreenState();
}

class _ClassScreenState extends State<ClassScreen> {
  final List<String> _textList = ['몇 학년인가요?', '몇 반인가요?'];

  FocusNode _grade = FocusNode();
  FocusNode _group = FocusNode();

  bool grade = false;
  bool group = false;
  bool button = false;
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
                visible: group,
                child: TextField(
                  autofocus: true,
                  focusNode: _group,
                  maxLength: 3,
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  onChanged: (text) {
                    if (text.length >= 1) {
                      setState(() {
                        button = true;
                        // FocusScope.of(context).requestFocus(ageField);
                      });
                    }
                    // 현재 텍스트필드의 텍스트를 출력
                  },
                  decoration: InputDecoration(
                      counterText: '',
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: Color.fromARGB(255, 151, 84, 251))),
                      labelText: "반",
                      labelStyle: new TextStyle(
                          color: Color.fromARGB(255, 182, 183, 184))),
                ),
              ),
              TextField(
                focusNode: _grade,
                autofocus: true,
                maxLength: 1,
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ],
                decoration: InputDecoration(
                    counterText: '',
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: Color.fromARGB(255, 151, 84, 251))),
                    labelText: "학년",
                    labelStyle: new TextStyle(
                        color: Color.fromARGB(255, 182, 183, 184))),
                onChanged: (text) {
                  if (text.length == 1) {
                    setState(() {
                      _group.requestFocus();
                      group = true;
                      title = 1;
                    });
                  }
                  // 현재 텍스트필드의 텍스트를 출력
                },
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
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //       builder: (context) => const SchoolScreen()),
                          // );
                        },
                      )))
            ]),
          ),
        ));
  }
}
