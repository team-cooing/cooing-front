import 'package:cooing_front/firebase_options.dart';
import 'package:cooing_front/pages/ClassScreen.dart';
import 'package:cooing_front/pages/LoginScreen.dart';
import 'package:cooing_front/pages/SchoolScreen.dart';
import 'package:cooing_front/pages/SignUpScreen.dart';
import 'package:cooing_front/pages/WelcomeScreen.dart';
import 'package:flutter/material.dart';
import 'package:cooing_front/pages/FeatureScreen.dart';
import 'package:cooing_front/pages/MultiSelectscreen.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart' as kakao;
import 'package:firebase_core/firebase_core.dart';

import 'package:cooing_front/pages/answer_page.dart';

void main() async {
  kakao.KakaoSdk.init(nativeAppKey: '010e5977ad5bf0cfbc9ab47ebfaa14a2');
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '_Working',
      routes: {
        'home': (context) => const LoginScreen(),
        'signUp': (context) => const SignUpScreen(),
        'school': (context) => const SchoolScreen(),
        'class': (context) => const ClassScreen(),
        'feature': (context) => const FeatureScreen(),
        'select': (context) => const MultiSelectscreen(),
        'welcome': (context) => const WelcomeScreen(),

        //현재 작업 중인 페이지
        '_Working': (context) => const AnswerPage()
      },
    );
  }
}
