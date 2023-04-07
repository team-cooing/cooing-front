import 'package:flutter/material.dart';

class FeedPage extends StatefulWidget {
  const FeedPage({super.key});
  @override
  State<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  int candy = 0;
  final List feedElements = [
    {
      'user_name': '쿠잉 복권',
      'question': '오늘도 쿠잉이 캔디 쏜다~!',
      'question_time': '2023-04-04 09:30:11',
      'candy': -1
    },
    {
      'user_name': '신혜은',
      'question': '"내 첫인상은 어땠어?"',
      'question_time': '2023-04-04 10:30:11',
      'candy': 20
    },
    {
      'user_name': '백소현',
      'question': '"요즘 내 성격은 어떤 것 같아?"',
      'question_time': '2023-04-04 15:30:11',
      'candy': 0
    },
    {
      'user_name': '박길현',
      'question': '"만약, 지금의 기억을 가지고 과거로 돌아가면 어떨 것 같아?"',
      'question_time': '2023-04-04 19:30:11',
      'candy': 4
    },
  ];

  Widget feedButton(int candy) {
    String btnText = '';

    if (candy > 0) {
      btnText = candy.toString();
      return Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
        SizedBox(
            width: 14.0,
            height: 14.0,
            child: Image(image: AssetImage('images/icon_candy.png'))),
        Text(
          '  $btnText',
          style: TextStyle(
              fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
        )
      ]);
    } else if (candy == -1) {
      btnText = '받기';
    } else if (candy == 0) {
      btnText = '답변하기';
    }
    return Text(
      btnText,
      style: TextStyle(
          fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(20.0),
          child: AppBar(
            elevation: 0.0,
            backgroundColor: Colors.transparent,
          ),
        ),
        body: ScrollConfiguration(
          behavior: ScrollBehavior().copyWith(overscroll: false),
          child: ListView.builder(
              itemCount: feedElements.length,
              itemBuilder: ((context, index) {
                return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5),
                    child: Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20),
                                bottomRight: Radius.circular(20))),
                        elevation: 0,
                        margin: EdgeInsets.symmetric(
                            horizontal: 15.0, vertical: 10.0),
                        child: SizedBox(
                          width: double.infinity,
                          child: Container(
                            padding: EdgeInsets.all(25.0),
                            decoration: BoxDecoration(
                                color: Color(0xffF2F3F3),
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(20),
                                    topRight: Radius.circular(20),
                                    bottomRight: Radius.circular(20))),
                            child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          SizedBox(
                                            width: 42.0,
                                            height: 42.0,
                                            child: CircleAvatar(
                                              backgroundImage: AssetImage(
                                                  'images/sohee.jpg'),
                                            ),
                                          ),
                                          Padding(
                                              padding:
                                                  EdgeInsets.only(right: 14.0)),
                                          Column(
                                              mainAxisSize: MainAxisSize.min,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "${feedElements[index]['user_name']}",
                                                  softWrap: true,
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    color: Color(0xff333D4B),
                                                  ),
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.all(3),
                                                ),
                                                Flexible(
                                                  child: Text(
                                                    "${feedElements[index]['question']}",
                                                    overflow:
                                                        TextOverflow.visible,
                                                    softWrap: true,
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      color: Color(0xff333D4B),
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                              ])
                                        ],
                                      )
                                    ],
                                  ),
                                  Container(
                                      alignment: Alignment.center,
                                      child: ElevatedButton(
                                          onPressed: null,
                                          style: OutlinedButton.styleFrom(
                                            padding: EdgeInsets.zero,
                                            foregroundColor: Colors.white,
                                            backgroundColor:
                                                Color.fromRGBO(151, 84, 251, 1),
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        10.0)),
                                          ),
                                          child: feedButton(
                                              feedElements[index]['candy'])))
                                ]),
                          ),
                        )));
              })),
        ));
  }
}
