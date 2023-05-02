import 'package:cooing_front/model/response/User.dart';
import 'package:cooing_front/pages/answer_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cooing_front/model/data/question_list.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:cooing_front/widgets/firebase_method.dart';

class MessagePage extends StatefulWidget {
  final User user;
  const MessagePage({required this.user, super.key});

  @override
  State<MessagePage> createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  bool isChecked = true;
  bool isFemale = true;

  // Firebase Firestore 인스턴스 생성
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  late CollectionReference contentCollectionRef;
  late CollectionReference userCollectionRef;
  late CollectionReference<Map<String, dynamic>> answerCollectionRef;
// 'contents'  의 document reference 초기화
  late DocumentReference contentDocRef;
  late DocumentReference userDocRef;
  late List<Map<String, dynamic>> msgcontentInfos;
  late Map<String, dynamic> questionAnswerMapList;
  late List<Map<String, dynamic>> groupList = [];
  @override
  void initState() {
    super.initState();

    String uid = widget.user.uid;
    userCollectionRef = firestore.collection('users');
    contentCollectionRef = firestore.collection('contents');
    answerCollectionRef = firestore.collection('answers');

    Future<User> getUserData() async {
      final prefs = await AsyncPrefsOperation();
      print(2222222222222);

      final userDataJson = prefs.getString('userData');
      if (userDataJson != null) {
        print("쿠키 에서 UserData 로드");
        print(userDataJson);
        Map<String, dynamic> userDataMap =
            json.decode(userDataJson); //z쿠키가 있ㅇㅡ면 쿠키 리턴
        return User.fromJson(userDataMap);
      } else {
        // Handle missing data
        print('No user data found in shared preferences');
        userDocRef = userCollectionRef.doc(uid);
        print("uid : $uid");
        print("firebase 에서 UserData 로드");
        return await getUserDocument(userDocRef, uid); //쿠키없으면 파베에서 유저 데이터 리턴
      }
    }

    try {
      late User userData;

      getUserData().then((data) {
        userData = data;
        msgcontentInfos = userData.questionInfos;
        if (msgcontentInfos.isEmpty) {
          print("userData - contentInfos is Empty");
        } else {
          getAnswersByQuestionIds(msgcontentInfos, answerCollectionRef)
              .then((value) {
            questionAnswerMapList = value;

            print("33333");
            questionAnswerMapList.forEach((key, value) {
              print("44444");
              print("key : $key value : $value");

              Map<String, dynamic> groupMap = {
                'contentId': key,
                // 'content': questionList.elementAt(int.parse(key))['question']
                //     as String,-
                'answers': value
              };
              groupList.add(groupMap);
              print("####groupList: $groupList");
            });

            setState(() {
              // 화면을 다시 그립니다.
              groupList = groupList;
            });
          });
        }
      });
    } on FormatException catch (e) {
      // Handle JSON decoding error
      print('Error decoding user data: $e');
    } catch (e) {
      // Handle other errors
      print('Error loading user data: $e');
    }
  }

  Widget whatIcon(bool gender, bool isChecked) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        SizedBox(
            width: 25.0,
            height: 25.0,
            child: gender
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

  Widget answerTimeText(String answerTime) {
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
        body: ScrollConfiguration(
            behavior: ScrollBehavior().copyWith(overscroll: false),
            child: GroupedListView<dynamic, int>(
              elements: groupList,
              groupBy: (element) => groupList.indexOf(element),
              groupComparator: (value1, value2) => value2.compareTo(value1),
              order: GroupedListOrder.ASC,
              groupSeparatorBuilder: (
                int value,
              ) {
                return Padding(
                    padding:
                        const EdgeInsets.only(left: 20.0, top: 30, bottom: 15),
                    child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '# ${value + 1}번째 질문',
                              textAlign: TextAlign.left,
                              style: TextStyle(fontSize: 14),
                            ),
                            Padding(padding: EdgeInsets.all(3)),
                            Text(
                              '"${QuestionList.questionList.elementAt(int.parse(groupList[value]['contentId']))['question'] as String}"',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ],
                        )));
              },
              itemBuilder: ((context, element) {
                List<Map<String, dynamic>> answers = element['answers'];
                if (answers.isEmpty) {
                  return Padding(
                      padding: EdgeInsets.symmetric(horizontal: 5),
                      child: GestureDetector(
                          onTap: () {
                            Get.to(() => AnswerDetailPage());
                          },
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
                                      padding: EdgeInsets.only(
                                          left: 25.0,
                                          right: 25,
                                          top: 5,
                                          bottom: 5),
                                      decoration: BoxDecoration(
                                          color: Color(0xffF2F3F3),
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(20),
                                              topRight: Radius.circular(20),
                                              bottomRight:
                                                  Radius.circular(20))),
                                      child: Center(
                                          child: Text(
                                        '이 질문에 대한 답변이 없습니다.',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Color(0xff333D4B),
                                        ),
                                      )))))));
                }

                return Column(
                    children: answers.map((answer) {
                  return Padding(
                      padding: EdgeInsets.symmetric(horizontal: 5),
                      child: GestureDetector(
                          onTap: () {
                            Get.to(() => AnswerDetailPage());
                          },
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
                                padding: EdgeInsets.only(
                                    left: 25.0, right: 25, top: 30, bottom: 30),
                                decoration: BoxDecoration(
                                    color: Color(0xffF2F3F3),
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(20),
                                        topRight: Radius.circular(20),
                                        bottomRight: Radius.circular(20))),
                                child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Row(
                                            children: [
                                              whatIcon(answer['gender'],
                                                  answer['isOpened']),
                                              Padding(
                                                  padding: EdgeInsets.only(
                                                      right: 20.0)),
                                              answer['gender']
                                                  ? Text(
                                                      '청순한 여학생',
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          color:
                                                              Color(0xff333D4B),
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    )
                                                  : Text(
                                                      '훈훈한 남학생',
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          color:
                                                              Color(0xff333D4B),
                                                          fontWeight:
                                                              FontWeight.bold),
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
                                      answerTimeText(answer['time'])
                                    ]),
                              ),
                            ),
                          )));
                }).toList());
              }),
            )));
  }
}
