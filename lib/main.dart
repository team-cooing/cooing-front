import 'package:cooing_front/firebase_options.dart';
import 'package:cooing_front/pages/CandyScreen.dart';
import 'package:cooing_front/pages/ClassScreen.dart';
import 'package:cooing_front/pages/HintPage.dart';
import 'package:cooing_front/pages/TokenLoginScreen.dart';
import 'package:cooing_front/pages/LoginScreen.dart';
import 'package:cooing_front/pages/SchoolScreen.dart';
import 'package:cooing_front/pages/SignUpScreen.dart';
import 'package:cooing_front/pages/SplashScreen.dart';
import 'package:cooing_front/pages/WelcomeScreen.dart';
import 'package:cooing_front/pages/question_page.dart';
import 'package:cooing_front/pages/tap_page.dart';
import 'package:cooing_front/providers/UserProvider.dart';
import 'package:flutter/material.dart';
import 'package:cooing_front/pages/FeatureScreen.dart';
import 'package:cooing_front/pages/MultiSelectscreen.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart' as kakao;
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

void main() async {
  kakao.KakaoSdk.init(nativeAppKey: '010e5977ad5bf0cfbc9ab47ebfaa14a2');
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(
    ChangeNotifierProvider(
      create: (context) => UserDataProvider(),
      child: MyApp(),
    ),
  );
}

String _initialRoute = 'home';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialRoute: '_working',
      // initialRoute: 'feature',
      routes: {
        SplashScreen.routeName: (context) => SplashScreen(),
        'home': (context) => const LoginScreen(),
        'token': (context) => const TokenLoginScreen(),
        'signUp': (context) => const SignUpScreen(),
        'school': (context) => const SchoolScreen(),
        'class': (context) => const ClassScreen(),
        'feature': (context) => const FeatureScreen(),
        'select': (context) => const MultiSelectscreen(),
        'welcome': (context) => const WelcomeScreen(),
        'tab': (context) => const TabPage(),
        'hint': (context) => const HintScreen(),
        'candy': (context) => const CandyScreen(),
        'question': (context) => const QuestionPage(),
        '_working': (context) => const TabPage(),
      },
    );
  }
}
