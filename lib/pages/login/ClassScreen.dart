import 'package:cooing_front/model/response/user.dart';
import 'package:cooing_front/pages/login/FeatureScreen.dart';
import 'package:cooing_front/pages/login/schoolScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ClassScreen extends StatefulWidget {
  const ClassScreen({super.key});

  @override
  _ClassScreenState createState() => _ClassScreenState();
}

class _ClassScreenState extends State<ClassScreen> {
  final List<String> _textList = ['몇 학년인가요?', '몇 반인가요?'];

  FocusNode _gradeFocus = FocusNode();
  FocusNode _groupFocus = FocusNode();

  bool grade = false;
  bool group = false;
  bool button = false;
  int title = 0;

  String _grade = '';
  String _group = '';

  // var thirdField = FocusNode();

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as User;

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          automaticallyImplyLeading: false, // 추가
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
                visible: group,
                child: TextField(
                  autofocus: true,
                  focusNode: _groupFocus,
                  maxLength: 2,
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  onChanged: (text) {
                    if (text.length >= 1 && _grade.length > 0) {
                      setState(() {
                        button = true;
                        // FocusScope.of(context).requestFocus(ageField);
                      });
                    } else {
                      setState(() {
                        button = false;
                      });
                    }
                    setState(() {
                      _group = text;
                    });
                  },
                  decoration: InputDecoration(
                      counterText: '',
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: Color.fromARGB(255, 151, 84, 251))),
                      labelText: "반",
                      labelStyle: new TextStyle(
                          color: Color.fromARGB(255, 182, 183, 184))),
                ),
              ),
              TextField(
                focusNode: _gradeFocus,
                autofocus: true,
                maxLength: 1,
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ],
                decoration: InputDecoration(
                    counterText: '',
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: Color.fromARGB(255, 151, 84, 251))),
                    labelText: "학년",
                    labelStyle: new TextStyle(
                        color: Color.fromARGB(255, 182, 183, 184))),
                onChanged: (text) {
                  if (text.length == 1) {
                    setState(() {
                      _groupFocus.requestFocus();
                      group = true;
                      title = 1;
                    });
                  }
                  if (text.length == 1 && _group.length > 0) {
                    setState(() {
                      button = true;
                    });
                  } else {
                    setState(() {
                      button = false;
                    });
                  }
                  setState(() {
                    _grade = text;
                  });
                },
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
                            Navigator.pushNamed(
                              context,
                              'feature',
                              arguments: User(
                                uid: args.uid,
                                name: args.name,
                                profileImage: args.profileImage,
                                gender: args.gender,
                                number: args.number,
                                age: args.age,
                                birthday: args.birthday,
                                school: args.school,
                                schoolCode: args.schoolCode,
                                schoolOrg: args.schoolOrg,
                                grade: int.parse(_grade),
                                group: int.parse(_group),
                                eyes: args.eyes,
                                mbti: args.mbti,
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
                          })))
            ]),
          ),
        ));
  }
}
