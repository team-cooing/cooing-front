// 2023.06.19 MON Midas: ✅
// 코드 효율성 점검: ✅
// 예외처리: ✅
// 중복 서버 송수신 방지: ✅

import 'package:cooing_front/model/response/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

class AgreeScreen extends StatefulWidget {
  const AgreeScreen({super.key});

  @override
  State<AgreeScreen> createState() => _AgreeScreenState();
}

class _AgreeScreenState extends State<AgreeScreen> {
  final List<bool> check = <bool>[true, true];

  bool grade = false;
  bool group = false;
  bool button = false;
  int title = 0;

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as User;

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
            body: Container(
              padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
              child: Form(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '항목에 동의해주세요',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 22.sp,
                            color: Color.fromARGB(255, 51, 61, 75)),
                      ),
                      Padding(padding: EdgeInsets.all(5)),
                      Text(
                        '서비스 이용을 위한 필수 동의 항목입니다',
                        style: TextStyle(
                            fontSize: 14.sp,
                            color: Color.fromARGB(122, 51, 61, 75)),
                      ),
                      Padding(padding: EdgeInsets.all(15)),
                      Row(
                        children: [
                          Checkbox(
                            value: check[0],
                            onChanged: (bool? value) {
                              setState(() {
                                check[0] = !check[0];
                              });
                            },
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15)),
                            checkColor: Colors.white,
                            activeColor: Color(0xff9754FB),
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                          ),
                          GestureDetector(
                            child: Row(
                              children: [
                                Text(
                                  '[필수] 서비스 이용약관',
                                  style: TextStyle(
                                      fontSize: 14.sp,
                                      color: Color.fromARGB(255, 51, 61, 75)),
                                ),
                                Icon(
                                  Icons.navigate_next,
                                  color: Color.fromRGBO(51, 61, 75, 0.8),
                                ),
                              ],
                            ),
                            onTap: () async {
                              final reportUrl = Uri.parse(
                                  "https://we-cooing.notion.site/9a8b8ef68b964b5881c57ce50657854d");

                              if (await canLaunchUrl(reportUrl)) {
                                launchUrl(reportUrl,
                                    mode: LaunchMode.externalApplication);
                              } else {
                                // ignore: avoid_print
                                print("Can't launch $reportUrl");
                              }
                            },
                          )
                        ],
                      ),
                      Row(
                        children: [
                          Padding(padding: EdgeInsets.all(0)),
                          Checkbox(
                            value: check[1],
                            onChanged: (bool? value) {
                              setState(() {
                                check[1] = !check[1];
                              });
                            },
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15)),
                            checkColor: Colors.white,
                            activeColor: Color(0xff9754FB),
                            materialTapTargetSize:
                            MaterialTapTargetSize.shrinkWrap,
                          ),
                          GestureDetector(
                            child: Row(
                              children: [
                                Text(
                                  '[필수] 개인정보처리 방침',
                                  style: TextStyle(
                                      fontSize: 14.sp,
                                      color: Color.fromARGB(255, 51, 61, 75)),
                                ),
                                Icon(
                                  Icons.navigate_next,
                                  color: Color.fromRGBO(51, 61, 75, 0.8),
                                ),
                              ],
                            ),
                            onTap: () async {
                              final reportUrl = Uri.parse(
                                  "https://we-cooing.notion.site/909def3b7b194ac48fabe0f142f60176");

                              if (await canLaunchUrl(reportUrl)) {
                                launchUrl(reportUrl,
                                    mode: LaunchMode.externalApplication);
                              } else {
                                // ignore: avoid_print
                                print("Can't launch $reportUrl");
                              }
                            },
                          )
                        ],
                      ),
                      Spacer(),
                      SizedBox(
                          width: double.infinity,
                          height: 50.h,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Color.fromARGB(255, 151, 84, 251)),
                            onPressed: check[0] & check[1]
                                ? () {
                              Navigator.pushNamed(
                                context,
                                'welcome',
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
                                  recentQuestionBonusReceiveDate:
                                  args.recentQuestionBonusReceiveDate,
                                  questionInfos: args.questionInfos,
                                  answeredQuestions:
                                  args.answeredQuestions,
                                  currentQuestion: args.currentQuestion,
                                  serviceNeedsAgreement: check[0],
                                  privacyNeedsAgreement: check[1],
                                ),
                              );
                            }
                                : null,
                            child: Text('모두 동의하기',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 15.sp)),
                          ))
                    ]),
              ),
            )));
  }
}