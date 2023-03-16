import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:cooing_front/pages/answer_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  void initState() {
    getDynamicLink();
  }

  void getDynamicLink() async {
    final PendingDynamicLinkData data =
        await FirebaseDynamicLinks.instance.getInitialLink();
    final Uri initialLink = data7.link;

    
  }

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: AnswerPage(),
    );
  }
}
