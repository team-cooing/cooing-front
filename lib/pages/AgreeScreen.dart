import 'package:cooing_front/model/User.dart';
import 'package:cooing_front/pages/FeatureScreen.dart';
import 'package:cooing_front/pages/SchoolScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart' as kakao;
import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:cloud_firestore/cloud_firestore.dart';

class AgreeScreen extends StatefulWidget {
  const AgreeScreen({super.key});

  @override
  _AgreeScreenState createState() => _AgreeScreenState();
}

class _AgreeScreenState extends State<AgreeScreen> {
  FocusNode _gradeFocus = FocusNode();
  FocusNode _groupFocus = FocusNode();
  final List<bool> check = <bool>[true, true];
  final _authentication = firebase.FirebaseAuth.instance;

  bool grade = false;
  bool group = false;
  bool button = false;
  int title = 0;

  int _grade = 0;
  int _group = 0;

  // var thirdField = FocusNode();

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as User;

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
                '항목에 동의해주세요',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                    color: Color.fromARGB(255, 51, 61, 75)),
              ),
              Padding(padding: EdgeInsets.all(5)),
              Text(
                '서비스 이용을 위한 필수 동의 항목입니다',
                style: TextStyle(
                    fontSize: 14, color: Color.fromARGB(122, 51, 61, 75)),
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
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  GestureDetector(
                    child: Row(
                      children: [
                        Text(
                          '[필수] 서비스 이용약관',
                          style: TextStyle(
                              fontSize: 14,
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
                        launchUrl(reportUrl);
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
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  GestureDetector(
                    child: Row(
                      children: [
                        Text(
                          '[필수] 개인정보처리 방침',
                          style: TextStyle(
                              fontSize: 14,
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
                        launchUrl(reportUrl);
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
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: Color.fromARGB(255, 151, 84, 251)),
                    child: const Text('모두 동의하기',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15)),
                    onPressed: check[0] & check[1]
                        ? () async {
                            kakao.User user = await kakao.UserApi.instance.me();
                            final newUser = await _authentication
                                .createUserWithEmailAndPassword(
                              email: user.kakaoAccount!.email.toString(),
                              password: user.id.toString(),
                            );
                            final uid = newUser.user!.uid.toString();
                            print(uid);

                            final userRef =
                                FirebaseFirestore.instance.collection('users');

                            await userRef.doc(uid).set({
                              'uid': uid,
                              "name": args.name,
                              "profileImage": args.profileImage,
                              'gender': args.gender,
                              'age': args.age,
                              'number': args.number,
                              'birthday': args.birthday,
                              'school': args.school,
                              'schoolCode': args.schoolCode,
                              'grade': args.grade,
                              'group': args.group,
                              'eyes': args.eyes,
                              'mbti': args.mbti,
                              'hobby': args.hobby,
                              "style": args.style,
                              'isSubscribe': args.isSubscribe,
                              'candyCount': args.candyCount,
                              'questionInfos': args.questionInfos,
                              'serviceNeedsAgreement': check[0],
                              'privacyNeedsAgreement': check[1]
                            });

                            if (newUser.user != null) {
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
                                  questionInfos: args.questionInfos,
                                  answeredQuestions: args.answeredQuestions,
                                  serviceNeedsAgreement: check[0],
                                  privacyNeedsAgreement: check[1],
                                ),
                              );
                            }
                          }
                        : null,
                  ))
            ]),
          ),
        ));
  }
}
