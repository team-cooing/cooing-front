import 'package:cooing_front/model/response/user.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cooing_front/widgets/answer_url.dart';

class FeedPage extends StatefulWidget {
  final User user;

  const FeedPage({required this.user, super.key});

  @override
  State<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  final int _limit = 10; // 한 번에 가져올 문서 수
  late List<QueryDocumentSnapshot> _documents = [];
  late DocumentSnapshot<Object?>? _lastDocument;
  final CollectionReference _collectionReference =
      FirebaseFirestore.instance.collection('schools/7041275/feed/');

  @override
  void initState() {
    super.initState();

    _getDocuments();
  }

  void _onAnswerButtonPressed(String questionId, String questionContent,
      String profileImage, String name) {
    createDynamicLink(context, questionId, questionContent, profileImage, name);
  }

  // 초기 데이터를 가져오는 get함수
  Future<List<QueryDocumentSnapshot<Object?>>> _getDocuments() async {
    QuerySnapshot<Object?> snapshot;
    if (_documents.isEmpty) {
      snapshot = await _collectionReference
          .orderBy('id', descending: true)
          .limit(_limit)
          .get();
    } else {
      snapshot = await _collectionReference
          .orderBy('id', descending: true) // id 필드를 기준으로 내림차순으로 정렬합니다.
          .startAfter([_lastDocument?['id']]) // 마지막 문서의 id 값을 가져옵니다.
          .limit(_limit)
          .get();
    }

    _documents = [..._documents, ...snapshot.docs];
    _lastDocument = snapshot.docs.last;

    for (var i in snapshot.docs) {
      print((i.data().toString()));
    }

    setState(() {});

    return snapshot.docs;
  }

  Widget feedButton(int candy, String questionId, String questionContent,
      String profileImage, String name) {
    String btnText = '';

    if (candy > 0) {
      btnText = candy.toString();
      return Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
        SizedBox(
            width: 14.0,
            height: 14.0,
            child: Image(image: AssetImage('images/candy1.png'))),
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
    return SizedBox(
        width: 50.0,
        child: GestureDetector(
            //questionId, questionContent, profileImage 넘겨야함

            onTap: () {
              if (btnText == '답변하기') {
                print("tap 답변하기버튼");
                _onAnswerButtonPressed(
                    questionId, questionContent, profileImage, name);
              }
              // Get.to(() => AnswerPage(),
              // arguments: [questionId, questionContent, profileImage, name])
            },
            child: Text(
              btnText,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            )));
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
        body: NotificationListener<ScrollEndNotification>(
          onNotification: (notification) {
            if (notification.metrics.extentAfter == 0) {
              _getDocuments();
            }
            return true;
          },
          child: ScrollConfiguration(
            behavior:
                ScrollConfiguration.of(context).copyWith(scrollbars: false),
            child: ListView.builder(
              itemCount: _documents.length,
              itemBuilder: (BuildContext context, int index) {
                // if (index == _documents.length) {
                //   return ElevatedButton(
                //     onPressed: _loadMoreDocuments,
                //     child: Text('Load more'),
                //   );
                // }

                Map<String, dynamic> data =
                    _documents[index].data()! as Map<String, dynamic>;

                if (index == _documents.length - 1) {
                  _lastDocument = _documents[index];
                }

                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                            bottomRight: Radius.circular(20))),
                    elevation: 0,
                    margin:
                        EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      SizedBox(
                                        width: 42.0,
                                        height: 42.0,
                                        child: CircleAvatar(
                                          backgroundImage: NetworkImage(
                                              data['profileImage']),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(right: 14.0),
                                      ),
                                      Expanded(
                                        child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                data['name'] ?? '',
                                                maxLines: 2,
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
                                                  data['questionContent'] ?? '',
                                                  softWrap: true,
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    color: Color(0xff333D4B),
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ]),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                            Container(
                              width: 75,
                              alignment: Alignment.center,
                              child: ElevatedButton(
                                onPressed: null,
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  shadowColor: Colors.transparent,
                                  backgroundColor:
                                      Color.fromRGBO(151, 84, 251, 1),
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(10.0)),
                                ),
                                //questionId, questionContent, profileImage 넘겨야함
                                child: feedButton(
                                    0,
                                    data['questionContent'],
                                    data['questionId'],
                                    data['profileImage'],
                                    data['name']),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ));
  }
}
