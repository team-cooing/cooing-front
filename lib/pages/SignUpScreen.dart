import 'package:cooing_front/model/User.dart';
import 'package:cooing_front/pages/SchoolScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
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

  bool number = false;
  bool age = false;
  bool button = true;
  int title = 0;

  String _age = '';
  String _number = '';

  // var thirdField = FocusNode();

  @override
  Widget build(BuildContext context) {
    // final node1 = FocusNode();
    final args = ModalRoute.of(context)!.settings.arguments as User;
    TextEditingController textEditingController =
        TextEditingController(text: args.name);
    // print(args.name);

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        backgroundColor: Color(0xFFffffff),
        body: Container(
          padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
          child: Form(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
                    if (text.length == 2) {
                      setState(() {
                        button = true;
                      });
                    }
                    _age = text;
                    // 현재 텍스트필드의 텍스트를 출력
                  },
                  maxLength: 2,
                  focusNode: ageField,
                  autofocus: true,
                  decoration: InputDecoration(
                      counterText: '',
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: Color.fromARGB(255, 151, 84, 251))),
                      labelText: "나이",
                      labelStyle: new TextStyle(
                          color: Color.fromARGB(255, 182, 183, 184))),
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
                    if (text.length == 11) {
                      setState(() {
                        age = true;
                        title = 2;
                        ageField.requestFocus();
                        // FocusScope.of(context).requestFocus(ageField);
                      });
                    }
                    _number = text;
                    // 현재 텍스트필드의 텍스트를 출력
                  },
                  decoration: InputDecoration(
                      counterText: '',
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: Color.fromARGB(255, 151, 84, 251))),
                      labelText: "휴대폰 번호",
                      labelStyle: new TextStyle(
                          color: Color.fromARGB(255, 182, 183, 184))),
                ),
              ),
              TextField(
                controller: textEditingController,
                focusNode: node1,
                onChanged: (value) {
                  textEditingController.selection = TextSelection.collapsed(
                      offset: textEditingController.text.length);
                  args.name = value;
                },
                autofocus: true,
                decoration: InputDecoration(
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: Color.fromARGB(255, 151, 84, 251))),
                    labelText: "이름",
                    labelStyle: new TextStyle(
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
                            primary: Color.fromARGB(255, 151, 84, 251)),
                        child: const Text('확인',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15)),
                        onPressed: () {
                          if (!number) {
                            numberField.requestFocus();
                            setState(() {
                              button = false;
                              number = true;
                              title = 1;
                            });
                          } else {
                            Navigator.pushNamed(
                              context,
                              'school',
                              arguments: User(
                                uid: args.uid,
                                name: args.name,
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
                                questionInfos: args.questionInfos,
                                answeredQuestions: args.answeredQuestions,
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
        ));
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
