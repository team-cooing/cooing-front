import 'package:cooing_front/pages/main_page.dart';
import 'package:flutter/material.dart';

class AskPage extends StatefulWidget {
  const AskPage({super.key});
  @override
  _AskPageState createState() => _AskPageState();
}

class _AskPageState extends State<AskPage> {
  final int _selectedPageIndex = 0;

  final List _pages = [
    const AskPage(),
    const Text('page2'),
    const Text('page3'),
    const Text('page4')
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: _pages[_selectedPageIndex]));
  }

  Widget _askBody() {
    String title = '<사진>';
    String contents = '똑똑똑! 오늘의 질문이 도착했어요.';

    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: SafeArea(
            child: SingleChildScrollView(
                child: Center(
                    child: Column(children: <Widget>[
          Text(
            title,
            style: const TextStyle(fontSize: 24.0),
          ),
          const Padding(padding: EdgeInsets.all(8.0)),
          Text(
            contents,
            style: const TextStyle(fontSize: 12.0),
          ),
          const Padding(padding: EdgeInsets.all(8.0)),
          SizedBox(
              width: 347.0,
              child: Card(
                child: Column(
                  children: <Widget>[
                    const SizedBox(
                      width: 80.0,
                      height: 80.0,
                      child: CircleAvatar(
                        backgroundImage: AssetImage('images/sohee.jpg'),
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          // foregroundColor: Colors('0xff9754FB'),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20))),
                      onPressed: null,
                      child: const Text('질문 받기'),
                    ),
                  ],
                ),
              ))
        ])))));
  }
}
