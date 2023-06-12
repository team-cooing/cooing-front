import 'package:cooing_front/model/response/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final List<String> _textList = [
    '이름을 입력해주세요.',
    '휴대폰 번호를 입력해주세요.',
    '나이를 입력해주세요.'
  ];

  FocusNode node1 = FocusNode();
  FocusNode numberField = FocusNode();
  FocusNode ageField = FocusNode();

  bool name = false;
  bool number = false;
  bool age = false;

  bool button = false;
  bool enable = true;
  int title = 0;

  String _name = '';
  String _age = '';
  String _number = '';

  // var thirdField = FocusNode();
  void hideKeyboard() {
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as User;

    return WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: GestureDetector(
            onTap: hideKeyboard,
            child: Scaffold(
                appBar: AppBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                ),
                backgroundColor: Color(0xFFffffff),
                body: Container(
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
                          Visibility(
                            visible: age,
                            child: TextField(
                              keyboardType: TextInputType.number,
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              // focusNode: node1,
                              onChanged: (text) {
                                if (text.length == 2 &&
                                    _number.length == 11 &&
                                    _name.isNotEmpty &&
                                    int.parse(text) <= 19) {
                                  setState(() {
                                    button = true;
                                  });
                                } else {
                                  setState(() {
                                    button = false;
                                  });
                                }
                                setState(() {
                                  _age = text;
                                });

                                // 현재 텍스트필드의 텍스트를 출력
                              },
                              maxLength: 2,
                              focusNode: ageField,
                              autofocus: true,
                              decoration: InputDecoration(
                                  errorText: _age.isNotEmpty
                                      ? int.parse(_age) >= 20
                                          ? '만 19세 이상의 서비스 이용이 제한됩니다.'
                                          : null
                                      : null,
                                  counterText: '',
                                  focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Color.fromARGB(
                                              255, 151, 84, 251))),
                                  labelText: "나이",
                                  labelStyle: TextStyle(
                                      color:
                                          Color.fromARGB(255, 182, 183, 184))),
                            ),
                          ),
                          Visibility(
                            visible: number,
                            child: TextField(
                              autofocus: true,
                              focusNode: numberField,
                              maxLength: 11,
                              keyboardType: TextInputType.number,
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              onChanged: (text) {
                                if (text.length == 11 && _name.isNotEmpty) {
                                  setState(() {
                                    ageField.requestFocus();
                                    age = true;
                                    title = 2;
                                  });
                                } else {
                                  setState(() {
                                    button = false;
                                  });
                                }
                                setState(() {
                                  _number = text;
                                });
                                // 현재 텍스트필드의 텍스트를 출력
                              },
                              decoration: InputDecoration(
                                  counterText: '',
                                  focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Color.fromARGB(
                                              255, 151, 84, 251))),
                                  labelText: "휴대폰 번호",
                                  labelStyle: TextStyle(
                                      color:
                                          Color.fromARGB(255, 182, 183, 184))),
                            ),
                          ),
                          TextField(
                            focusNode: node1,
                            enabled: enable,
                            autofocus: true,
                            onChanged: (value) {
                              print(value.length);
                              if (value.isNotEmpty) {
                                setState(() {
                                  button = true;
                                });
                              }else {
                                setState(() {
                                  button = false;
                                });
                              }
                              setState(() {
                                _name = value;
                              });
                            },
                            decoration: InputDecoration(
                                focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color:
                                            Color.fromARGB(255, 151, 84, 251))),
                                labelText: "이름",
                                labelStyle: TextStyle(
                                    color: Color.fromARGB(255, 182, 183, 184))),
                          ),
                          Spacer(),
                          Visibility(
                              visible: button,
                              child: SizedBox(
                                  width: double.infinity,
                                  height: 50,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: Color.fromARGB(255, 151, 84, 251)),
                                    child: const Text('확인',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15)),
                                    onPressed: () {
                                      if (!number) {
                                        setState(() {
                                          numberField.requestFocus();
                                          enable = false;
                                          button = false;
                                          number = true;
                                          // node1.unfocus();
                                          title = 1;
                                        });
                                      } else {
                                        Navigator.pushNamed(
                                          context,
                                          'school',
                                          arguments: User(
                                            uid: args.uid,
                                            name: _name,
                                            profileImage: args.profileImage,
                                            gender: args.gender,
                                            number: _number,
                                            age: _age,
                                            birthday: args.birthday,
                                            school: args.school,
                                            schoolCode: args.schoolCode,
                                            schoolOrg: args.schoolOrg,
                                            grade: args.grade,
                                            group: args.group,
                                            eyes: args.eyes,
                                            mbti: args.mbti,
                                            hobby: args.hobby,
                                            style: args.style,
                                            isSubscribe: args.isSubscribe,
                                            candyCount: args.candyCount,
                                            recentDailyBonusReceiveDate: args
                                                .recentDailyBonusReceiveDate,
                                            recentQuestionBonusReceiveDate: args
                                                .recentQuestionBonusReceiveDate,
                                            questionInfos: args.questionInfos,
                                            answeredQuestions:
                                                args.answeredQuestions,
                                            currentQuestionId:
                                                args.currentQuestionId,
                                            currentQuestion: args.currentQuestion,
                                            serviceNeedsAgreement:
                                                args.serviceNeedsAgreement,
                                            privacyNeedsAgreement:
                                                args.privacyNeedsAgreement,
                                          ),
                                        );
                                      }
                                    },
                                  )))
                        ]),
                  ),
                ))));
  }
}

// class UserInfo {
//   String name;
//   String profileImage;
//   late int gender;
//   String number;
//   String age;
//   String birthday = '2000-02-24';
//   String school;
//   int grade;
//   int group;
//   String mbti;
//   String hobby;
//   List style;

//   UserInfo(
//       {required this.name,
//       required this.profileImage,
//       required this.number,
//       required this.age,
//       required this.school,
//       required this.grade,
//       required this.group,
//       required this.mbti,
//       required this.hobby,
//       required this.style});
// }