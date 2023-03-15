import 'package:flutter/material.dart';

class FeaturePage extends StatefulWidget {
  const FeaturePage({super.key});

  @override
  _FeaturePageState createState() => _FeaturePageState();
}

class _FeaturePageState extends State<FeaturePage> {
  final List<bool> _selected = <bool>[false, false];

  final List<String> _textList = [
    '어떤 눈을 가졌나요?',
    'MBTI는?',
    '좋아하는 취미는?',
    '나는 OOO 스타일?',
  ];
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
                      _textList[0],
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                          color: Color.fromARGB(255, 51, 61, 75)),
                    ),
                    // MBTI
                    Container(
                      padding: const EdgeInsets.only(top: 40, bottom: 20),
                      child: Text(
                        'MBTI',
                        style: TextStyle(
                            fontSize: 20,
                            color: Color.fromARGB(255, 51, 61, 75)),
                      ),
                    ),
                    Column(children: [
                      Container(
                        child: SizedBox(
                            height: 60,
                            child: Column(children: [
                              ToggleButtons(
                                selectedColor:
                                    Color.fromARGB(255, 151, 84, 251),
                                fillColor: Color.fromRGBO(151, 84, 251, 0.2),
                                disabledColor: Color.fromRGBO(243, 242, 242, 1),
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(8)),
                                children: <Widget>[
                                  Container(
                                    alignment: Alignment.center,
                                    width: (MediaQuery.of(context).size.width -
                                            43) /
                                        2,
                                    child: Text('I',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                            color: Color.fromARGB(
                                                255, 151, 84, 251))),
                                  ),
                                  Container(
                                    alignment: Alignment.center,
                                    width: (MediaQuery.of(context).size.width -
                                            43) /
                                        2,
                                    child: Text('E',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                            color: Color.fromARGB(
                                                255, 151, 84, 251))),
                                  ),
                                ],
                                isSelected: _selected,
                                onPressed: (int index) {
                                  setState(() {
                                    // The button that is tapped is set to true, and the others to false.
                                    for (int i = 0; i < _selected.length; i++) {
                                      _selected[i] = i == index;
                                    }
                                  });
                                },
                              ),
                            ])),
                      ),
                      Container(
                        child: SizedBox(
                            height: 60,
                            child: Column(children: [
                              ToggleButtons(
                                selectedColor:
                                    Color.fromARGB(255, 151, 84, 251),
                                fillColor: Color.fromRGBO(151, 84, 251, 0.2),
                                disabledColor: Color.fromRGBO(243, 242, 242, 1),
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(8)),
                                children: <Widget>[
                                  Container(
                                    alignment: Alignment.center,
                                    width: (MediaQuery.of(context).size.width -
                                            43) /
                                        2,
                                    child: Text('N',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                            color: Color.fromARGB(
                                                255, 151, 84, 251))),
                                  ),
                                  Container(
                                    alignment: Alignment.center,
                                    width: (MediaQuery.of(context).size.width -
                                            43) /
                                        2,
                                    child: Text('S',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                            color: Color.fromARGB(
                                                255, 151, 84, 251))),
                                  ),
                                ],
                                isSelected: _selected,
                                onPressed: (int index) {
                                  setState(() {
                                    // The button that is tapped is set to true, and the others to false.
                                    for (int i = 0; i < _selected.length; i++) {
                                      _selected[i] = i == index;
                                    }
                                  });
                                },
                              ),
                            ])),
                      ),
                      Container(
                        child: SizedBox(
                            height: 60,
                            child: Column(children: [
                              ToggleButtons(
                                selectedColor:
                                    Color.fromARGB(255, 151, 84, 251),
                                fillColor: Color.fromRGBO(151, 84, 251, 0.2),
                                disabledColor: Color.fromRGBO(243, 242, 242, 1),
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(8)),
                                children: <Widget>[
                                  Container(
                                    alignment: Alignment.center,
                                    width: (MediaQuery.of(context).size.width -
                                            43) /
                                        2,
                                    child: Text('T',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                            color: Color.fromARGB(
                                                255, 151, 84, 251))),
                                  ),
                                  Container(
                                    alignment: Alignment.center,
                                    width: (MediaQuery.of(context).size.width -
                                            43) /
                                        2,
                                    child: Text('F',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                            color: Color.fromARGB(
                                                255, 151, 84, 251))),
                                  ),
                                ],
                                isSelected: _selected,
                                onPressed: (int index) {
                                  setState(() {
                                    // The button that is tapped is set to true, and the others to false.
                                    for (int i = 0; i < _selected.length; i++) {
                                      _selected[i] = i == index;
                                    }
                                  });
                                },
                              ),
                            ])),
                      ),
                      Container(
                        child: SizedBox(
                            height: 60,
                            child: Column(children: [
                              ToggleButtons(
                                selectedColor:
                                    Color.fromARGB(255, 151, 84, 251),
                                fillColor: Color.fromRGBO(151, 84, 251, 0.2),
                                disabledColor: Color.fromRGBO(243, 242, 242, 1),
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(8)),
                                children: <Widget>[
                                  Container(
                                    alignment: Alignment.center,
                                    width: (MediaQuery.of(context).size.width -
                                            43) /
                                        2,
                                    child: Text('J',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                            color: Color.fromARGB(
                                                255, 151, 84, 251))),
                                  ),
                                  Container(
                                    alignment: Alignment.center,
                                    width: (MediaQuery.of(context).size.width -
                                            43) /
                                        2,
                                    child: Text('P',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                            color: Color.fromARGB(
                                                255, 151, 84, 251))),
                                  ),
                                ],
                                isSelected: _selected,
                                onPressed: (int index) {
                                  setState(() {
                                    // The button that is tapped is set to true, and the others to false.
                                    for (int i = 0; i < _selected.length; i++) {
                                      _selected[i] = i == index;
                                    }
                                  });
                                },
                              ),
                            ])),
                      ),
                    ]),
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
                      child: ToggleButtons(
                        selectedColor: Color.fromARGB(255, 151, 84, 251),
                        fillColor: Color.fromRGBO(151, 84, 251, 0.2),
                        disabledColor: Color.fromRGBO(243, 242, 242, 1),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(8)),
                        children: <Widget>[
                          Container(
                            alignment: Alignment.center,
                            width: (MediaQuery.of(context).size.width - 43) / 2,
                            child: Text('무쌍',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Color.fromARGB(255, 151, 84, 251))),
                          ),
                          Container(
                            alignment: Alignment.center,
                            width: (MediaQuery.of(context).size.width - 43) / 2,
                            child: Text('유쌍',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Color.fromARGB(255, 151, 84, 251))),
                          ),
                        ],
                        isSelected: _selected,
                        onPressed: (int index) {
                          setState(() {
                            // The button that is tapped is set to true, and the others to false.
                            for (int i = 0; i < _selected.length; i++) {
                              _selected[i] = i == index;
                            }
                          });
                        },
                      ),
                    )
                  ]),
            )));
  }
}
