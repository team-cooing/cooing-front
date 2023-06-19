// 2023.06.20 TUE Midas: ✅
// 코드 효율성 점검: ✅
// 예외처리: ✅
// 중복 서버 송수신 방지: ✅

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CandyCompleteScreen extends StatefulWidget {
  const CandyCompleteScreen({super.key});

  @override
  State<CandyCompleteScreen> createState() => CandyCompleteScreenState();
}

class CandyCompleteScreenState extends State<CandyCompleteScreen> {
  @override
  void initState() {
    super.initState();
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
    return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
              width: 120.w,
              height: 120.h,
              child: Image(image: AssetImage('assets/images/icon_complete_send.png'))),
          Container(
            padding: EdgeInsets.only(top: 50, bottom: 7),
            child: Text(
              "성공적으로 캔디 충전이",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22.sp,
                  color: Color.fromARGB(255, 51, 61, 75)),
            ),
          ),
          Text(
            "완료되었어요",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 22.sp,
                color: Color.fromARGB(255, 51, 61, 75)),
          ),
        ]);
  }

  Widget okBtn() {
    return SafeArea(
        child: Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).systemGestureInsets.bottom + 20,
              left: 20,
              right: 20,
            ),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      style: OutlinedButton.styleFrom(
                        fixedSize: Size.fromHeight(60),
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
