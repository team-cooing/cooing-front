import 'package:cooing_front/model/response/user.dart';
import 'package:cooing_front/pages/login/MultiSelectscreen.dart';
import 'package:flutter/material.dart';

class FeatureScreen extends StatefulWidget {
  const FeatureScreen({super.key});

  @override
  _FeatureScreenState createState() => _FeatureScreenState();
}

class _FeatureScreenState extends State<FeatureScreen> {
  final List<bool> _eyes = <bool>[false, false];
  final List<bool> _gender = <bool>[false, false];

  final List<bool> _mbti1 = <bool>[false, false];
  final List<bool> _mbti2 = <bool>[false, false];
  final List<bool> _mbti3 = <bool>[false, false];
  final List<bool> _mbti4 = <bool>[false, false];

  final List<bool> _button = <bool>[false, false, false, false];

  final List<String> _textList = [
    '당신의 성별은 무엇인가요?',
    'MBTI는?',
    '어떤 눈을 가졌나요?',
  ];

  int title = 0;
  bool visibleEyes = false;
  bool visibleMbti = false;

  int gender = 0;
  int eyes = 0;
  List<String> _mbti = <String>[];

  @override
  Widget build(BuildContext context) {
    // final node1 = FocusNode();
    final args = ModalRoute.of(context)!.settings.arguments as User;
    print(args);

    return WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              automaticallyImplyLeading: false, // 추가
            ),
            backgroundColor: Color(0xFFffffff),
            body: SingleChildScrollView(
                child: Column(children: [
              Container(
                  padding:
                      const EdgeInsets.only(left: 20, right: 20, bottom: 20),
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
                              opacity: visibleMbti ? 1.0 : 0.0,
                              duration: const Duration(milliseconds: 500),
                              child: Visibility(
                                  visible: visibleMbti,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.only(
                                            top: 40, bottom: 20),
                                        child: Text(
                                          'MBTI',
                                          style: TextStyle(
                                              fontSize: 20,
                                              color: Color.fromARGB(
                                                  255, 51, 61, 75)),
                                        ),
                                      ),
                                      Column(children: [
                                        Container(
                                          padding:
                                              const EdgeInsets.only(bottom: 20),
                                          child: SizedBox(
                                            height: 60,
                                            child: Container(
                                                padding: EdgeInsets.zero,
                                                decoration: BoxDecoration(
                                                  color: Color.fromRGBO(
                                                      243, 243, 243, 1),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(10)),
                                                ),
                                                child: ToggleButtons(
                                                  color: Color.fromRGBO(
                                                      51, 61, 75, 0.4),
                                                  selectedColor: Color.fromARGB(
                                                      255, 151, 84, 251),
                                                  fillColor: Color.fromRGBO(
                                                      151, 84, 251, 0.4),
                                                  disabledColor: Color.fromRGBO(
                                                      243, 243, 243, 1),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(10)),
                                                  borderColor:
                                                      Colors.transparent,
                                                  selectedBorderColor:
                                                      Colors.transparent,
                                                  children: <Widget>[
                                                    Container(
                                                      alignment:
                                                          Alignment.center,
                                                      width: (MediaQuery.of(
                                                                      context)
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
                                                      alignment:
                                                          Alignment.center,
                                                      width: (MediaQuery.of(
                                                                      context)
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
                                                      _button[0] = true;
                                                    });
                                                  },
                                                )),
                                          ),
                                        ),
                                        Container(
                                          padding:
                                              const EdgeInsets.only(bottom: 20),
                                          child: SizedBox(
                                            height: 60,
                                            child: Container(
                                                padding: EdgeInsets.zero,
                                                decoration: BoxDecoration(
                                                  color: Color.fromRGBO(
                                                      243, 243, 243, 1),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(10)),
                                                ),
                                                child: ToggleButtons(
                                                  color: Color.fromRGBO(
                                                      51, 61, 75, 0.4),
                                                  selectedColor: Color.fromARGB(
                                                      255, 151, 84, 251),
                                                  fillColor: Color.fromRGBO(
                                                      151, 84, 251, 0.4),
                                                  disabledColor: Color.fromRGBO(
                                                      243, 243, 243, 1),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(10)),
                                                  borderColor:
                                                      Colors.transparent,
                                                  selectedBorderColor:
                                                      Colors.transparent,
                                                  children: <Widget>[
                                                    Container(
                                                      alignment:
                                                          Alignment.center,
                                                      width: (MediaQuery.of(
                                                                      context)
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
                                                      alignment:
                                                          Alignment.center,
                                                      width: (MediaQuery.of(
                                                                      context)
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
                                                      _button[1] = true;
                                                    });
                                                  },
                                                )),
                                          ),
                                        ),
                                        Container(
                                          padding:
                                              const EdgeInsets.only(bottom: 20),
                                          child: SizedBox(
                                            height: 60,
                                            child: Container(
                                                padding: EdgeInsets.zero,
                                                decoration: BoxDecoration(
                                                  color: Color.fromRGBO(
                                                      243, 243, 243, 1),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(10)),
                                                ),
                                                child: ToggleButtons(
                                                  color: Color.fromRGBO(
                                                      51, 61, 75, 0.4),
                                                  selectedColor: Color.fromARGB(
                                                      255, 151, 84, 251),
                                                  fillColor: Color.fromRGBO(
                                                      151, 84, 251, 0.4),
                                                  disabledColor: Color.fromRGBO(
                                                      243, 243, 243, 1),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(10)),
                                                  borderColor:
                                                      Colors.transparent,
                                                  selectedBorderColor:
                                                      Colors.transparent,
                                                  children: <Widget>[
                                                    Container(
                                                      alignment:
                                                          Alignment.center,
                                                      width: (MediaQuery.of(
                                                                      context)
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
                                                      alignment:
                                                          Alignment.center,
                                                      width: (MediaQuery.of(
                                                                      context)
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
                                                      _button[2] = true;
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
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(10)),
                                                ),
                                                child: ToggleButtons(
                                                  color: Color.fromRGBO(
                                                      51, 61, 75, 0.4),
                                                  selectedColor: Color.fromARGB(
                                                      255, 151, 84, 251),
                                                  fillColor: Color.fromRGBO(
                                                      151, 84, 251, 0.4),
                                                  disabledColor: Color.fromRGBO(
                                                      243, 243, 243, 1),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(10)),
                                                  borderColor:
                                                      Colors.transparent,
                                                  selectedBorderColor:
                                                      Colors.transparent,
                                                  children: <Widget>[
                                                    Container(
                                                      alignment:
                                                          Alignment.center,
                                                      width: (MediaQuery.of(
                                                                      context)
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
                                                      alignment:
                                                          Alignment.center,
                                                      width: (MediaQuery.of(
                                                                      context)
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
                                                      _button[3] = true;
                                                    });
                                                  },
                                                )),
                                          ),
                                        ),
                                      ]),
                                    ],
                                  ))),

                          //눈 무쌍,유쌍
                          AnimatedOpacity(
                              opacity: visibleEyes ? 1.0 : 0.0,
                              duration: const Duration(milliseconds: 500),
                              child: Visibility(
                                  visible: visibleEyes,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.only(
                                            top: 40, bottom: 20),
                                        child: Text(
                                          '눈',
                                          style: TextStyle(
                                              fontSize: 20,
                                              color: Color.fromARGB(
                                                  255, 51, 61, 75)),
                                        ),
                                      ),
                                      SizedBox(
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
                                              color: Color.fromRGBO(
                                                  51, 61, 75, 0.4),
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
                                                  child: Text('무쌍',
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 16,
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
                                                  child: Text('유쌍',
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 16,
                                                      )),
                                                ),
                                              ],
                                              isSelected: _eyes,
                                              onPressed: (int index) {
                                                setState(() {
                                                  // The button that is tapped is set to true, and the others to false.
                                                  for (int i = 0;
                                                      i < _eyes.length;
                                                      i++) {
                                                    _eyes[i] = i == index;
                                                  }
                                                  eyes = index;
                                                  print(eyes);
                                                  title = 1;
                                                  visibleMbti = true;
                                                });
                                              },
                                            )),
                                      )
                                    ],
                                  ))),

                          //성별
                          Container(
                            padding: const EdgeInsets.only(top: 40, bottom: 20),
                            child: Text(
                              '성별',
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
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                ),
                                child: ToggleButtons(
                                  color: Color.fromRGBO(51, 61, 75, 0.4),
                                  selectedColor:
                                      Color.fromARGB(255, 151, 84, 251),
                                  fillColor: Color.fromRGBO(151, 84, 251, 0.4),
                                  disabledColor:
                                      Color.fromRGBO(243, 243, 243, 1),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                  borderColor: Colors.transparent,
                                  selectedBorderColor: Colors.transparent,
                                  children: <Widget>[
                                    Container(
                                      alignment: Alignment.center,
                                      width:
                                          (MediaQuery.of(context).size.width -
                                                  43) /
                                              2,
                                      child: Text('남',
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
                                          (MediaQuery.of(context).size.width -
                                                  43) /
                                              2,
                                      child: Text('여',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          )),
                                    ),
                                  ],
                                  isSelected: _gender,
                                  onPressed: (int index) {
                                    setState(() {
                                      // The button that is tapped is set to true, and the others to false.
                                      for (int i = 0; i < _gender.length; i++) {
                                        _gender[i] = i == index;
                                      }
                                      gender = index;

                                      print(gender);
                                      title = 2;
                                      visibleEyes = true;
                                    });
                                  },
                                )),
                          )
                        ]),
                  )),
            ])),
            bottomNavigationBar: AnimatedOpacity(
              opacity: !_button.contains(false) ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 500),
              child: Visibility(
                  visible: !_button.contains(false),
                  child: Padding(
                    padding: EdgeInsets.all(20),
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
                            if (_mbti1[0]) {
                              _mbti.add('I');
                            } else {
                              _mbti.add('E');
                            }
                            if (_mbti2[0]) {
                              _mbti.add('N');
                            } else {
                              _mbti.add('S');
                            }
                            if (_mbti3[0]) {
                              _mbti.add('T');
                            } else {
                              _mbti.add('F');
                            }
                            if (_mbti4[0]) {
                              _mbti.add('J');
                            } else {
                              _mbti.add('P');
                            }
                            Navigator.pushNamed(
                              context,
                              'select',
                              arguments: User(
                                uid: args.uid,
                                name: args.name,
                                profileImage: args.profileImage,
                                gender: gender,
                                number: args.number,
                                age: args.age,
                                birthday: args.birthday,
                                school: args.school,
                                schoolCode: args.schoolCode,
                                schoolOrg: args.schoolOrg,
                                grade: args.grade,
                                group: args.group,
                                eyes: eyes,
                                mbti: _mbti.join(''),
                                hobby: args.hobby,
                                style: args.style,
                                isSubscribe: args.isSubscribe,
                                candyCount: args.candyCount,
                                recentDailyBonusReceiveDate:
                                    args.recentDailyBonusReceiveDate,
                                recentQuestionBonusReceiveDate:
                                    args.recentQuestionBonusReceiveDate,
                                questionInfos: args.questionInfos,
                                answeredQuestions: args.answeredQuestions,
                                currentQuestionId: args.currentQuestionId,
                                serviceNeedsAgreement:
                                    args.serviceNeedsAgreement,
                                privacyNeedsAgreement:
                                    args.privacyNeedsAgreement,
                              ),
                            );
                          }),
                    ),
                  )),
            )));
  }
}
