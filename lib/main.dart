import 'package:flutter/material.dart';
import 'package:cooing_front/pages/main_page.dart';
import 'package:cooing_front/pages/kakaoLogin_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: KakaoLoginPage(),
    );
  }
}
