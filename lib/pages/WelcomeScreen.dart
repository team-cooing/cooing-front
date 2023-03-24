import 'dart:async';
import 'dart:convert';
import 'package:cooing_front/model/User.dart';
import 'package:cooing_front/pages/question_page.dart';
import 'package:cooing_front/pages/tap_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  void initState() {
    Timer(Duration(seconds: 3), () {
      Get.to(TabPage());
    });
    super.initState();
  }

  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as User;
    return Scaffold(
        // appBar: AppBar(
        //   backgroundColor: Colors.transparent,
        //   elevation: 0,
        // ),
        backgroundColor: Color(0xFFffffff),
        body: Container(
          padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
          child: Form(
            child: Center(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                  Container(
                    padding: EdgeInsets.all(10),
                    child: Text(
                      "회원가입 완료!",
                      style: TextStyle(
                          fontSize: 16, color: Color.fromRGBO(51, 61, 75, 0.6)),
                    ),
                  ),
                  Text(
                    " ${args.name}님,",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                        color: Color.fromARGB(255, 51, 61, 75)),
                  ),
                  Text(
                    "환영합니다!",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                        color: Color.fromARGB(255, 51, 61, 75)),
                  ),
                ])),
          ),
        ));
  }
}
