import 'package:flutter/material.dart';

class FeedPage extends StatefulWidget {
  const FeedPage({super.key});

  @override
  State<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  final List _elements = [
    {
      'user_name': '신혜은',
      'question': '내 첫인상은 어땠어?',
      'question_time': '2020-10-31 19:30:11'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
