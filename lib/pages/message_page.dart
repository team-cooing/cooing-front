import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';

class MessagePage extends StatefulWidget {
  const MessagePage({super.key});

  @override
  State<MessagePage> createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  bool isChecked = true;
  bool isFemale = true;
  final List _elements = [
    {
      'questionNumber': '1',
      'question': '내 첫인상은 어땠어?',
      'isFemale': true,
      'isChecked': true,
      'answer_time': '2020-10-31 19:30:11'
    },
    {
      'questionNumber': '1',
      'question': '내 첫인상은 어땠어?',
      'isFemale': false,
      'isChecked': false,
      'answer_time': '2020-10-31 10:30:11'
    },
    {
      'questionNumber': '1',
      'question': '내 첫인상은 어땠어?',
      'isFemale': false,
      'isChecked': true,
      'answer_time': '2020-10-31 09:30:11'
    },
    {
      'questionNumber': '2',
      'question': '내 MBTI는 무슨 유형 같아?',
      'isFemale': true,
      'isChecked': true,
      'answer_time': '2023-03-01 10:30:11'
    },
    {
      'questionNumber': '2',
      'question': '내 MBTI는 무슨 유형 같아?',
      'isFemale': true,
      'isChecked': false,
      'answer_time': '2023-03-01 14:30:11'
    },
    {
      'questionNumber': '2',
      'question': '내 MBTI는 무슨 유형 같아?',
      'isFemale': false,
      'isChecked': false,
      'answer_time': '2023-03-01 19:30:11'
    },
    {
      'questionNumber': '2',
      'question': '내 MBTI는 무슨 유형 같아?',
      'isFemale': true,
      'isChecked': true,
      'answer_time': '2023-03-01 21:30:11'
    },
    {
      'questionNumber': '3',
      'question': '내가 제일 잘하는 과목은 뭘까?',
      'isFemale': true,
      'isChecked': false,
      'answer_time': '2023-04-05 10:30:11'
    },
    {
      'questionNumber': '3',
      'question': '내가 제일 잘하는 과목은 뭘까?',
      'isFemale': false,
      'isChecked': true,
      'answer_time': '2023-04-05 16:30:11'
    },
    {
      'questionNumber': '3',
      'question': '내가 제일 잘하는 과목은 뭘까?',
      'isFemale': true,
      'isChecked': false,
      'answer_time': '2023-04-05 19:30:11'
    },
    {
      'questionNumber': '3',
      'question': '내가 제일 잘하는 과목은 뭘까?',
      'isFemale': true,
      'isChecked': true,
      'answer_time': '2023-04-05 22:30:11'
    },
    {
      'questionNumber': '3',
      'question': '내가 제일 잘하는 과목은 뭘까?',
      'isFemale': false,
      'isChecked': false,
      'answer_time': '2023-04-05 23:58:11'
    },
  ];
  final Map questionList = {
    '1': '내 첫인상은 어땠어?',
    '2': '내 MBTI는 무슨 유형 같아?',
    '3': '내가 제일 잘하는 과목은 뭘까?'
  };

  Widget whatIcon(bool isFemale, bool isChecked) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        SizedBox(
            width: 25.0,
            height: 25.0,
            child: isFemale
                ? Image(image: AssetImage('images/icon_msg_girl.png'))
                : Image(image: AssetImage('images/icon_msg_boy.png'))),
        Positioned(
          bottom: 10,
          left: 15,
          child: SizedBox(
              width: 18.0,
              height: 18.0,
              child: isChecked
                  ? Image(image: AssetImage('images/icon_msg_opened.png'))
                  : null),
        )
      ],
    );
  }

  Widget answer_time_text(String answerTime) {
    final DateTime now = DateTime.now();
    DateTime answerDate = DateTime.parse(answerTime);
    // final DateFormat formatter = DateFormat('yyyy-MM-dd hh:mm:ss');
    // final String formatted_now = formatter.format(now);

    Duration duration = now.difference(answerDate);
    String time = '';
    int inMinutes = duration.inMinutes;
    int inHours = duration.inHours;
    int inDays = duration.inDays;

    if (inMinutes < 60) {
      time = '${inMinutes}m';
    } else if (inHours < 24) {
      time = '${inHours}h';
    } else if (inDays < 30) {
      time = '${inDays}d';
    } else if (inDays > 30) {
      if (inDays < 365) {
        time = '${(now.month - answerDate.month).abs()}m';
      } else if (inDays > 365) {
        time = '${now.year - answerDate.year}y';
      }
    }

    return Text(time);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: GroupedListView<dynamic, String>(
      elements: _elements,
      groupBy: (element) => element['questionNumber'],
      groupComparator: (value1, value2) => value2.compareTo(value1),
      itemComparator: ((element1, element2) =>
          element2['answer_time'].compareTo(element1['answer_time'])),
      order: GroupedListOrder.ASC,
      groupSeparatorBuilder: (
        String value,
      ) =>
          Padding(
              padding: const EdgeInsets.only(left: 20.0, top: 30, bottom: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '# $value번째 질문',
                    textAlign: TextAlign.left,
                    style: TextStyle(fontSize: 14),
                  ),
                  Padding(padding: EdgeInsets.all(3)),
                  Text(
                    '"${questionList[value]}"',
                    textAlign: TextAlign.left,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              )),
      itemBuilder: ((context, element) {
        return Card(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                  bottomRight: Radius.circular(20))),
          elevation: 0,
          margin: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
          child: SizedBox(
            width: double.infinity,
            child: Container(
              padding:
                  EdgeInsets.only(left: 25.0, right: 25, top: 30, bottom: 30),
              decoration: BoxDecoration(
                  color: Color(0xffF2F3F3),
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                      bottomRight: Radius.circular(20))),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            whatIcon(element['isFemale'], element['isChecked']),
                            Padding(padding: EdgeInsets.only(right: 20.0)),
                            element['isFemale']
                                ? Text(
                                    '청순한 여학생',
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: Color(0xff333D4B),
                                        fontWeight: FontWeight.bold),
                                  )
                                : Text(
                                    '훈훈한 남학생',
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: Color(0xff333D4B),
                                        fontWeight: FontWeight.bold),
                                  ),
                            Text(
                              '으로부터',
                              style: TextStyle(
                                fontSize: 16,
                                color: Color(0xff333D4B),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                    answer_time_text(element['answer_time'])
                  ]),
            ),
          ),
        );
      }),
    ));
  }
}
