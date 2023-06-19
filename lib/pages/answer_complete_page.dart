// 2023.06.20 TUE Midas: ✅
// 코드 효율성 점검: ✅
// 예외처리: ✅
// 중복 서버 송수신 방지: ✅

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AnswerCompleteScreen extends StatefulWidget {
  final String owner;
  final String uid;
  const AnswerCompleteScreen(
      {required this.owner,
      required this.uid,
      super.key});

  @override
  State<AnswerCompleteScreen> createState() => AnswerCompleteScreenState();
}

class AnswerCompleteScreenState extends State<AnswerCompleteScreen> {
  late String owner;
  late String uid;
  @override
  void initState() {
    super.initState();
    print(widget.uid);
    owner = widget.owner;
    uid = widget.uid;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: Scaffold(
          backgroundColor: Color(0xFFffffff),
          body: SizedBox(
              width: double.infinity,
              child: Column(children: [Expanded(child: mainView()), okBtn()])),
        ));
  }

  Widget mainView() {
    String messageContent = '';
    DateTime currentTime = DateTime.now();
    if (currentTime.minute != 0 && currentTime.minute != 30) {
      if (currentTime.minute > 30) {
        currentTime = currentTime.add(Duration(hours: 1));
        messageContent =
            '${currentTime.day}일 ${currentTime.hour}시 00분에\n$owner님께 답변이 전달돼요';
      } else {
        messageContent =
            '${currentTime.day}일 ${currentTime.hour}시 30분에\n$owner님께 답변이 전달돼요';
      }
    } else {
      messageContent = '성공적으로 $owner님께\n답변을 전달했어요';
    }

    return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
              width: 100.w,
              height: 100.w,
              child: Image(image: AssetImage('assets/images/icon_complete_send.png'))),
          Container(
            padding: EdgeInsets.only(top: 50, bottom: 7).r,
            child: Text(
              messageContent,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22.sp,
                  color: Color.fromARGB(255, 51, 61, 75)),
            ),
          ),
        ]);
  }

  Widget okBtn() {
    return SafeArea(
        child: Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).systemGestureInsets.bottom + 25,
              left: 25,
              right: 25,
            ),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop(true);
                      },
                      style: OutlinedButton.styleFrom(
                        fixedSize: Size.fromHeight(50),
                        foregroundColor: Colors.white,
                        backgroundColor: const Color(0xff9754FB),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14.0)),
                      ),
                      child: Text(
                        "확인",
                        style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      )),
                ])));
  }
}
