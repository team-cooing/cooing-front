import 'package:flutter/material.dart';
import 'package:cooing_front/pages/main_page.dart';

class CompleteScreen extends StatefulWidget {
  const CompleteScreen({Key? key}) : super(key: key);

  @override
  State<CompleteScreen> createState() => CompleteScreenState();
}

class CompleteScreenState extends State<CompleteScreen> {
  @override
  Widget build(BuildContext context) {
    var owner = '박보영';

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
                  SizedBox(
                      width: 120.0,
                      height: 120.0,
                      child: Image(
                          image: AssetImage('images/icon_complete_send.png'))),
                  Container(
                    padding: EdgeInsets.only(top: 50, bottom: 7),
                    child: Text(
                      "성공적으로 $owner님께",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                          color: Color.fromARGB(255, 51, 61, 75)),
                    ),
                  ),
                  Text(
                    "답변을 전달했어요",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                        color: Color.fromARGB(255, 51, 61, 75)),
                  ),
                ])),
          ),
        ),
        bottomSheet: SafeArea(
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Padding(
                padding: EdgeInsets.only(
                  bottom:
                      MediaQuery.of(context).systemGestureInsets.bottom + 15,
                ),
                child: okBtn())
          ]),
        ));
  }

  Widget okBtn() {
    return Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
      SizedBox(
        width: 350,
        height: 60,
        child: ElevatedButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const MainPage()));
            },
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: const Color(0xff9754FB),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
            ),
            child: const Text(
              "확인",
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            )),
      )
    ]);
  }
}
