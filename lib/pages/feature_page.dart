import 'package:flutter/material.dart';
import 'package:toggle_switch/toggle_switch.dart';

class FeaturePage extends StatefulWidget {
  const FeaturePage({super.key});

  @override
  _FeaturePageState createState() => _FeaturePageState();
}

class _FeaturePageState extends State<FeaturePage> {
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
            padding: const EdgeInsets.only(left: 20, right: 0, bottom: 20),
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
                    Container(
                      padding: const EdgeInsets.only(top: 40, bottom: 20),
                      child: Text(
                        '눈',
                        style: TextStyle(
                            fontSize: 20,
                            color: Color.fromARGB(255, 51, 61, 75)),
                      ),
                    ),
                    Container(
                      // width: double.infinity,
                      child: ToggleSwitch(
                        minWidth: double.infinity,
                        minHeight: 60.0,
                        initialLabelIndex: 0,
                        // fontSize: 18,
                        cornerRadius: 8.0,
                        activeFgColor: Color.fromRGBO(151, 84, 251, 1),
                        inactiveBgColor: Color.fromRGBO(243, 242, 242, 1),
                        inactiveFgColor: Color.fromRGBO(51, 61, 75, 0.4),
                        totalSwitches: 2,
                        labels: ['무쌍', '유쌍'],
                        activeBgColors: [
                          [Color.fromRGBO(151, 84, 251, 0.2)],
                          [Color.fromRGBO(151, 84, 251, 0.2)],
                        ],
                        onToggle: (index) {
                          print('switched to: $index');
                        },
                        customTextStyles: [
                          TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color.fromRGBO(151, 84, 251, 1),
                              fontSize: 16),
                          TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color.fromRGBO(151, 84, 251, 1),
                              fontSize: 16),
                        ],
                      ),
                    ),
                  ]),
            )));
  }
}
