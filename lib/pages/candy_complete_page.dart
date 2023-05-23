import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cooing_front/pages/tab_page.dart';

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
    return Scaffold(
      backgroundColor: Color(0xFFffffff),
      body: SizedBox(
          width: double.infinity,
          child: Column(children: [Expanded(child: mainView()), okBtn()])),
    );
  }

  Widget mainView() {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
              width: 120.0,
              height: 120.0,
              child: Image(image: AssetImage('images/icon_complete_send.png'))),
          Container(
            padding: EdgeInsets.only(top: 50, bottom: 7),
            child: Text(
              "성공적으로 캔디 충전이",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                  color: Color.fromARGB(255, 51, 61, 75)),
            ),
          ),
          Text(
            "완료되었어요",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 22,
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
                        fixedSize: Size.fromHeight(50),
                        foregroundColor: Colors.white,
                        backgroundColor: const Color(0xff9754FB),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14.0)),
                      ),
                      child: const Text(
                        "확인",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      )),
                ])));
  }
}
