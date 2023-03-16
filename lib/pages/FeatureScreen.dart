import 'package:flutter/material.dart';
import 'package:customtogglebuttons/customtogglebuttons.dart';

class FeatureScreen extends StatefulWidget {
  const FeatureScreen({super.key});

  @override
  _FeatureScreenState createState() => _FeatureScreenState();
}

class _FeatureScreenState extends State<FeatureScreen> {
  final List<bool> _eyes = <bool>[false, false];
  final List<bool> _mbti1 = <bool>[false, false];
  final List<bool> _mbti2 = <bool>[false, false];
  final List<bool> _mbti3 = <bool>[false, false];
  final List<bool> _mbti4 = <bool>[false, false];

  final List<String> _textList = [
    '어떤 눈을 가졌나요?',
    'MBTI는?',
    '좋아하는 취미는?',
    '나는 OOO 스타일?',
  ];

  int title = 0;
  bool mbti = false;

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
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _textList[title],
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                          color: Color.fromARGB(255, 51, 61, 75)),
                    ),
                    AnimatedOpacity(
                        opacity: mbti ? 1.0 : 0.0,
                        duration: const Duration(milliseconds: 500),
                        child: Visibility(
                            visible: mbti,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.only(
                                      top: 40, bottom: 20),
                                  child: Text(
                                    'MBTI',
                                    style: TextStyle(
                                        fontSize: 20,
                                        color: Color.fromARGB(255, 51, 61, 75)),
                                  ),
                                ),
                                Column(children: [
                                  Container(
                                    padding: const EdgeInsets.only(bottom: 20),
                                    child: SizedBox(
                                      height: 60,
                                      child: Container(
                                          padding: EdgeInsets.zero,
                                          decoration: BoxDecoration(
                                            color: Color.fromRGBO(
                                                243, 243, 243, 1),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10)),
                                          ),
                                          child: ToggleButtons(
                                            color:
                                                Color.fromRGBO(51, 61, 75, 0.4),
                                            selectedColor: Color.fromARGB(
                                                255, 151, 84, 251),
                                            fillColor: Color.fromRGBO(
                                                151, 84, 251, 0.4),
                                            disabledColor: Color.fromRGBO(
                                                243, 243, 243, 1),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10)),
                                            borderColor: Colors.transparent,
                                            selectedBorderColor:
                                                Colors.transparent,
                                            children: <Widget>[
                                              Container(
                                                alignment: Alignment.center,
                                                width: (MediaQuery.of(context)
                                                            .size
                                                            .width -
                                                        43) /
                                                    2,
                                                child: Text('I',
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 20,
                                                      // color:
                                                      //     Color.fromRGBO(51, 61, 75, 0.4)
                                                    )),
                                              ),
                                              Container(
                                                alignment: Alignment.center,
                                                width: (MediaQuery.of(context)
                                                            .size
                                                            .width -
                                                        43) /
                                                    2,
                                                child: Text('E',
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 20,
                                                    )),
                                              ),
                                            ],
                                            isSelected: _mbti1,
                                            onPressed: (int index) {
                                              setState(() {
                                                // The button that is tapped is set to true, and the others to false.
                                                for (int i = 0;
                                                    i < _mbti1.length;
                                                    i++) {
                                                  _mbti1[i] = i == index;
                                                }
                                                title = 1;
                                                mbti = true;
                                              });
                                            },
                                          )),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.only(bottom: 20),
                                    child: SizedBox(
                                      height: 60,
                                      child: Container(
                                          padding: EdgeInsets.zero,
                                          decoration: BoxDecoration(
                                            color: Color.fromRGBO(
                                                243, 243, 243, 1),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10)),
                                          ),
                                          child: ToggleButtons(
                                            color:
                                                Color.fromRGBO(51, 61, 75, 0.4),
                                            selectedColor: Color.fromARGB(
                                                255, 151, 84, 251),
                                            fillColor: Color.fromRGBO(
                                                151, 84, 251, 0.4),
                                            disabledColor: Color.fromRGBO(
                                                243, 243, 243, 1),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10)),
                                            borderColor: Colors.transparent,
                                            selectedBorderColor:
                                                Colors.transparent,
                                            children: <Widget>[
                                              Container(
                                                alignment: Alignment.center,
                                                width: (MediaQuery.of(context)
                                                            .size
                                                            .width -
                                                        43) /
                                                    2,
                                                child: Text('N',
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 20,
                                                      // color:
                                                      //     Color.fromRGBO(51, 61, 75, 0.4)
                                                    )),
                                              ),
                                              Container(
                                                alignment: Alignment.center,
                                                width: (MediaQuery.of(context)
                                                            .size
                                                            .width -
                                                        43) /
                                                    2,
                                                child: Text('S',
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 20,
                                                    )),
                                              ),
                                            ],
                                            isSelected: _mbti2,
                                            onPressed: (int index) {
                                              setState(() {
                                                // The button that is tapped is set to true, and the others to false.
                                                for (int i = 0;
                                                    i < _mbti2.length;
                                                    i++) {
                                                  _mbti2[i] = i == index;
                                                }
                                                title = 1;
                                                mbti = true;
                                              });
                                            },
                                          )),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.only(bottom: 20),
                                    child: SizedBox(
                                      height: 60,
                                      child: Container(
                                          padding: EdgeInsets.zero,
                                          decoration: BoxDecoration(
                                            color: Color.fromRGBO(
                                                243, 243, 243, 1),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10)),
                                          ),
                                          child: ToggleButtons(
                                            color:
                                                Color.fromRGBO(51, 61, 75, 0.4),
                                            selectedColor: Color.fromARGB(
                                                255, 151, 84, 251),
                                            fillColor: Color.fromRGBO(
                                                151, 84, 251, 0.4),
                                            disabledColor: Color.fromRGBO(
                                                243, 243, 243, 1),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10)),
                                            borderColor: Colors.transparent,
                                            selectedBorderColor:
                                                Colors.transparent,
                                            children: <Widget>[
                                              Container(
                                                alignment: Alignment.center,
                                                width: (MediaQuery.of(context)
                                                            .size
                                                            .width -
                                                        43) /
                                                    2,
                                                child: Text('T',
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 20,
                                                      // color:
                                                      //     Color.fromRGBO(51, 61, 75, 0.4)
                                                    )),
                                              ),
                                              Container(
                                                alignment: Alignment.center,
                                                width: (MediaQuery.of(context)
                                                            .size
                                                            .width -
                                                        43) /
                                                    2,
                                                child: Text('F',
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 20,
                                                    )),
                                              ),
                                            ],
                                            isSelected: _mbti3,
                                            onPressed: (int index) {
                                              setState(() {
                                                // The button that is tapped is set to true, and the others to false.
                                                for (int i = 0;
                                                    i < _mbti3.length;
                                                    i++) {
                                                  _mbti3[i] = i == index;
                                                }
                                                title = 1;
                                                mbti = true;
                                              });
                                            },
                                          )),
                                    ),
                                  ),
                                  Container(
                                    child: SizedBox(
                                      height: 60,
                                      child: Container(
                                          padding: EdgeInsets.zero,
                                          decoration: BoxDecoration(
                                            color: Color.fromRGBO(
                                                243, 243, 243, 1),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10)),
                                          ),
                                          child: ToggleButtons(
                                            color:
                                                Color.fromRGBO(51, 61, 75, 0.4),
                                            selectedColor: Color.fromARGB(
                                                255, 151, 84, 251),
                                            fillColor: Color.fromRGBO(
                                                151, 84, 251, 0.4),
                                            disabledColor: Color.fromRGBO(
                                                243, 243, 243, 1),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10)),
                                            borderColor: Colors.transparent,
                                            selectedBorderColor:
                                                Colors.transparent,
                                            children: <Widget>[
                                              Container(
                                                alignment: Alignment.center,
                                                width: (MediaQuery.of(context)
                                                            .size
                                                            .width -
                                                        43) /
                                                    2,
                                                child: Text('J',
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 20,
                                                      // color:
                                                      //     Color.fromRGBO(51, 61, 75, 0.4)
                                                    )),
                                              ),
                                              Container(
                                                alignment: Alignment.center,
                                                width: (MediaQuery.of(context)
                                                            .size
                                                            .width -
                                                        43) /
                                                    2,
                                                child: Text('P',
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 20,
                                                    )),
                                              ),
                                            ],
                                            isSelected: _mbti4,
                                            onPressed: (int index) {
                                              setState(() {
                                                // The button that is tapped is set to true, and the others to false.
                                                for (int i = 0;
                                                    i < _mbti4.length;
                                                    i++) {
                                                  _mbti4[i] = i == index;
                                                }
                                                title = 1;
                                                mbti = true;
                                              });
                                            },
                                          )),
                                    ),
                                  ),
                                ]),
                              ],
                            ))),

                    //눈 무쌍,유쌍
                    Container(
                      padding: const EdgeInsets.only(top: 40, bottom: 20),
                      child: Text(
                        '눈',
                        style: TextStyle(
                            fontSize: 20,
                            color: Color.fromARGB(255, 51, 61, 75)),
                      ),
                    ),
                    SizedBox(
                      height: 60,
                      child: Container(
                          padding: EdgeInsets.zero,
                          decoration: BoxDecoration(
                            color: Color.fromRGBO(243, 243, 243, 1),
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                          child: ToggleButtons(
                            color: Color.fromRGBO(51, 61, 75, 0.4),
                            selectedColor: Color.fromARGB(255, 151, 84, 251),
                            fillColor: Color.fromRGBO(151, 84, 251, 0.4),
                            disabledColor: Color.fromRGBO(243, 243, 243, 1),
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            borderColor: Colors.transparent,
                            selectedBorderColor: Colors.transparent,
                            children: <Widget>[
                              Container(
                                alignment: Alignment.center,
                                width:
                                    (MediaQuery.of(context).size.width - 43) /
                                        2,
                                child: Text('무쌍',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      // color:
                                      //     Color.fromRGBO(51, 61, 75, 0.4)
                                    )),
                              ),
                              Container(
                                alignment: Alignment.center,
                                width:
                                    (MediaQuery.of(context).size.width - 43) /
                                        2,
                                child: Text('유쌍',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    )),
                              ),
                            ],
                            isSelected: _eyes,
                            onPressed: (int index) {
                              setState(() {
                                // The button that is tapped is set to true, and the others to false.
                                for (int i = 0; i < _eyes.length; i++) {
                                  _eyes[i] = i == index;
                                }
                                title = 1;
                                mbti = true;
                              });
                            },
                          )),
                    )
                  ]),
            )));
  }
}
