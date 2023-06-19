// 2023.06.19 MON Midas: ✅
// 코드 효율성 점검: ✅
// 예외처리: ✅
// 중복 서버 송수신 방지: ✅

import 'package:cooing_front/model/response/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final formKey = GlobalKey<FormState>();

  final List<String> _textList = [
    '이름을 입력해주세요.',
    '휴대폰 번호를 입력해주세요.',
    '나이를 입력해주세요.'
  ];

  FocusNode node1 = FocusNode();
  FocusNode numberField = FocusNode();
  FocusNode ageField = FocusNode();

  bool isNameFilled = false;
  bool isNumberFilled = false;
  bool isAgeFilled = false;

  bool isButtonActive = false;
  int titleIndex = 0;

  String _name = '';
  String _age = '';
  String _number = '';

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
                      const EdgeInsets.only(left: 20, right: 20, bottom: 20).r,
                  child: Form(
                    key: formKey,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _textList[titleIndex],
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 22.sp,
                                color: Color.fromARGB(255, 51, 61, 75)),
                          ),
                          Visibility(
                            visible: isNumberFilled,
                            child: TextFormField(
                              onSaved: (val) {
                                setState(() {
                                  _age = val.toString();
                                });
                              },
                              validator: (val) {
                                if (val != null) {
                                  if (int.parse(val) < 15) {
                                    return '15세 미만은 서비스 이용이 제한됩니다';
                                  } else if (int.parse(val) > 19) {
                                    return '만 19세 이상은 서비스 이용이 제한됩니다';
                                  } else {
                                    return null;
                                  }
                                } else {
                                  return '나이를 입력해주세요';
                                }
                              },
                              keyboardType: TextInputType.number,
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              // focusNode: node1,
                              onChanged: (text) {
                                setState(() {
                                  _age = text;
                                  if (titleIndex == 2) {
                                    if (_name.isNotEmpty &&
                                        _number.length == 11 &&
                                        _age.length == 2 &&
                                        int.parse(_age) >= 15 &&
                                        int.parse(_age) <= 19) {
                                      isButtonActive = true;
                                    } else {
                                      isButtonActive = false;
                                    }
                                  }
                                });
                              },
                              maxLength: 2,
                              focusNode: ageField,
                              autofocus: true,
                              decoration: InputDecoration(
                                  errorText: _age.isNotEmpty && _age.length == 2
                                      ? int.parse(_age) >= 20
                                          ? '만 19세 이상은 서비스 이용이 제한됩니다.'
                                          : int.parse(_age) < 15
                                              ? '15세 미만은 서비스 이용이 제한됩니다.'
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
                            visible: isNameFilled,
                            child: TextFormField(
                              onSaved: (val) {
                                setState(() {
                                  _number = val.toString();
                                });
                              },
                              validator: (val) {
                                if (val != null) {
                                  if (val.length != 11) {
                                    return '올바른 휴대폰 번호를 입력해주세요';
                                  } else {
                                    if (!val.startsWith('010')) {
                                      return "'010'으로 시작하는 올바른 휴대폰 번호를 입력해주세요";
                                    } else {
                                      return null;
                                    }
                                  }
                                } else {
                                  return '휴대폰 번호를 입력해주세요';
                                }
                              },
                              autofocus: true,
                              focusNode: numberField,
                              maxLength: 11,
                              keyboardType: TextInputType.number,
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              onChanged: (text) {
                                setState(() {
                                  _number = text;
                                  if (titleIndex == 1) {
                                    if (text.length == 11) {
                                      ageField.requestFocus();
                                      isNumberFilled = true;
                                      titleIndex = 2;
                                    }
                                  } else if (titleIndex == 2) {
                                    if (_name.isNotEmpty &&
                                        _number.length == 11 &&
                                        _age.length == 2 &&
                                        int.parse(_age) >= 15 &&
                                        int.parse(_age) <= 19) {
                                      isButtonActive = true;
                                    } else {
                                      isButtonActive = false;
                                    }
                                  }
                                });
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
                          TextFormField(
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp('[ㄱ-ㅎㅏ-ㅣ가-힣]')),
                            ],
                            onSaved: (val) {
                              setState(() {
                                _name = val.toString();
                              });
                            },
                            validator: (val) {
                              if (val != null) {
                                final consonantsPattern = RegExp(
                                    r'^[ㄱ-ㅎ]*$'); // 한글 모음을 정규표현식으로 나타낸 패턴
                                final vowelsPattern = RegExp(
                                    r'^[ㅏ-ㅣ]*$'); // 한글 모음을 정규표현식으로 나타낸 패턴

                                for(var i=0; i<val.length; i++){
                                  if(consonantsPattern.hasMatch(val[i]) ||
                                      vowelsPattern.hasMatch(val[i])){
                                    return '올바른 이름을 입력해주세요';
                                  }
                                }

                                return null;
                              } else {
                                return '이름을 입력해주세요';
                              }
                            },
                            focusNode: node1,
                            autofocus: true,
                            onChanged: (value) {
                              setState(() {
                                _name = value;
                                if (titleIndex == 0) {
                                  isButtonActive = value.isNotEmpty;
                                } else if (titleIndex == 2) {
                                  if (_name.isNotEmpty &&
                                      _number.length == 11 &&
                                      _age.length == 2 &&
                                      int.parse(_age) >= 15 &&
                                      int.parse(_age) <= 19) {
                                    isButtonActive = true;
                                  } else {
                                    isButtonActive = false;
                                  }
                                }
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
                              visible: isButtonActive,
                              child: SizedBox(
                                  width: double.infinity,
                                  height: 50.h,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: Color.fromARGB(255, 151, 84, 251),
                                        disabledForegroundColor: titleIndex == 2
                                            ? Colors.white
                                            : null,
                                        disabledBackgroundColor: titleIndex == 2
                                            ? Color.fromRGBO(151, 84, 251, 0.2)
                                                .withOpacity(0.12)
                                            : null),
                                    onPressed: (){
                                      if (titleIndex == 0) {
                                        setState(() {
                                          numberField.requestFocus();
                                          isButtonActive = false;
                                          isNameFilled = true;
                                          titleIndex = 1;
                                        });
                                      } else {
                                        if (formKey.currentState != null) {
                                          // 만약, currentState 있다면
                                          if (formKey.currentState!
                                              .validate()) {
                                            formKey.currentState!.save();
                                            User newUser = User(
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
                                              recentDailyBonusReceiveDate:
                                              args.recentDailyBonusReceiveDate,
                                              recentQuestionBonusReceiveDate: args
                                                  .recentQuestionBonusReceiveDate,
                                              questionInfos: args.questionInfos,
                                              answeredQuestions:
                                              args.answeredQuestions,
                                              currentQuestion: args.currentQuestion,
                                              serviceNeedsAgreement:
                                              args.serviceNeedsAgreement,
                                              privacyNeedsAgreement:
                                              args.privacyNeedsAgreement,
                                            );
                                            Navigator.pushNamed(context, 'school',
                                                arguments: newUser);
                                          }
                                        }
                                      }
                                    },
                                    child: Text('확인',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15.sp)),
                                  ))),
                        ]),
                  ),
                ))));
  }

  void hideKeyboard() {
    FocusScope.of(context).unfocus();
  }
}
