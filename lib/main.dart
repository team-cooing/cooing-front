import 'package:cooing_front/firebase_options.dart';
import 'package:cooing_front/pages/CandyScreen.dart';
import 'package:cooing_front/pages/ClassScreen.dart';
import 'package:cooing_front/pages/HintPage.dart';
import 'package:cooing_front/pages/LoginScreen.dart';
import 'package:cooing_front/pages/SchoolScreen.dart';
import 'package:cooing_front/pages/SignUpScreen.dart';
import 'package:cooing_front/pages/WelcomeScreen.dart';
import 'package:cooing_front/pages/question_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cooing_front/pages/main_page.dart';
import 'package:cooing_front/pages/FeatureScreen.dart';
import 'package:cooing_front/widgets/grid_boy.dart';
import 'package:cooing_front/pages/MultiSelectscreen.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart' as kakao;
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';

void main() async {
  kakao.KakaoSdk.init(nativeAppKey: '010e5977ad5bf0cfbc9ab47ebfaa14a2');
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialRoute: 'home',
      routes: {
        'home': (context) => const LoginScreen(),
        'signUp': (context) => const SignUpScreen(),
        'school': (context) => const SchoolScreen(),
        'class': (context) => const ClassScreen(),
        'feature': (context) => const FeatureScreen(),
        'select': (context) => const MultiSelectscreen(),
        'welcome': (context) => const WelcomeScreen(),
        'question': (context) => const QuestionPage(),
        'hint': (context) => const HintScreen(),
        'candy': (context) => const CandyScreen()
      },
    );
  }
}
