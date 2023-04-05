import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';

class answerListView extends StatefulWidget {
  const answerListView({super.key});

  @override
  State<answerListView> createState() => _answerListViewState();
}

class _answerListViewState extends State<answerListView> {
  final bool _isChecked = true;

  final List _elements = [
    {
      'questionNumber': '1',
      'question': '내 첫인상은 어땠나요?',
      'Who_Answer': '여자',
      'isChecked': true,
      'time': 2
    },
    {
      'questionNumber': '1',
      'question': '내 첫인상은 어땠나요?',
      'Who_Answer': '남자',
      'isChecked': false,
      'time': 2
    },
    {
      'questionNumber': '1',
      'question': '내 첫인상은 어땠나요?',
      'Who_Answer': '남자',
      'isChecked': true,
      'time': 2
    },
    {
      'questionNumber': '2',
      'question': '내 MBTI는 무슨 유형 같나요?',
      'Who_Answer': '남자',
      'isChecked': true,
      'time': 2
    },
    {
      'questionNumber': '2',
      'question': '내 MBTI는 무슨 유형 같나요?',
      'Who_Answer': '여자',
      'isChecked': false,
      'time': 2
    },
    {
      'questionNumber': '2',
      'question': '내 MBTI는 무슨 유형 같나요?',
      'Who_Answer': '남자',
      'isChecked': false,
      'time': 2
    },
    {
      'questionNumber': '2',
      'question': '내 MBTI는 무슨 유형 같나요?',
      'Who_Answer': '여자',
      'isChecked': true,
      'time': 2
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: GroupedListView<dynamic, String>(
          elements: _elements,
          groupBy: (element) => element['questionNumber'],
          groupComparator: (value1, value2) => value2.compareTo(value1),
          itemComparator: ((element1, element2) =>
              element1['time'].compareTo(element2['time'])),
          order: GroupedListOrder.DESC,
          groupSeparatorBuilder: (String value) => Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              value,
              textAlign: TextAlign.left,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ),
          itemBuilder: ((context, element) {
            return Card(
              elevation: 8.0,
              margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
              child:   SizedBox(
                  width: double.infinity,
                  height: 90.0,
                  child: Container(
                    padding: EdgeInsets.all(25.0),
                    decoration: BoxDecoration(
                        color: Color(0xffF2F3F3),
                        borderRadius: BorderRadius.circular(20)),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                children: [
                                  SizedBox(
                                      width: 25.0,
                                      height: 25.0,
                                      child: Image(
                                          image:
                                              AssetImage('images/candy1.png'))),
                                  Padding(
                                      padding: EdgeInsets.only(right: 10.0)),
                                  Text(
                                    "캔디 25개",
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: Color(0xff333D4B),
                                        fontWeight: FontWeight.bold),
                                  )
                                ],
                              )
                            ],
                          ),
                          // Text(_elements['time'])
                        ]),
                  ),
                ),
            );
          }),
        ));
  }
}
