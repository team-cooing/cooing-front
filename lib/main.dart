import 'package:cooing_front/pages/SampleScreen.dart';
import 'package:flutter/material.dart';
import 'package:cooing_front/pages/main_page.dart';
import 'package:cooing_front/pages/kakaoLogin_page.dart';
import 'package:cooing_front/pages/feature_page.dart';
import 'package:cooing_front/widgets/grid_boy.dart';
import 'package:cooing_front/pages/MultiSelectscreen.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';

void main() {
  KakaoSdk.init(nativeAppKey: '010e5977ad5bf0cfbc9ab47ebfaa14a2');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: SampleScreen(),
    );
  }
}
