import 'package:cooing_front/firebase_options.dart';
import 'package:cooing_front/pages/login/AgreeScreen.dart';
import 'package:cooing_front/pages/CandyScreen.dart';
import 'package:cooing_front/pages/login/ClassScreen.dart';
import 'package:cooing_front/pages/HintPage.dart';
import 'package:cooing_front/pages/login/TokenLoginScreen.dart';
import 'package:cooing_front/pages/login/LoginScreen.dart';
import 'package:cooing_front/pages/login/SchoolScreen.dart';
import 'package:cooing_front/pages/login/SignUpScreen.dart';
import 'package:cooing_front/pages/login/SplashScreen.dart';
import 'package:cooing_front/pages/WelcomeScreen.dart';
import 'package:cooing_front/pages/question_page.dart';
import 'package:cooing_front/pages/tab_page.dart';
import 'package:cooing_front/providers/FeedProvider.dart';
import 'package:cooing_front/providers/UserProvider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cooing_front/pages/login/FeatureScreen.dart';
import 'package:cooing_front/pages/login/MultiSelectscreen.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart' as kakao;
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';

void main() async {
  kakao.KakaoSdk.init(nativeAppKey: '010e5977ad5bf0cfbc9ab47ebfaa14a2');
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  if (defaultTargetPlatform == TargetPlatform.android) {
    InAppPurchaseAndroidPlatformAddition.enablePendingPurchases();
  }
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserDataProvider()),
        // ChangeNotifierProvider<SchoolFeedProvider>(
        //   create: (_) => SchoolFeedProvider(),
        //   lazy: false,
        // ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialRoute: SplashScreen.routeName,
      routes: {
        SplashScreen.routeName: (context) => SplashScreen(),
        'home': (context) => const LoginScreen(),
        'token': (context) => const TokenLoginScreen(),
        'signUp': (context) => const SignUpScreen(),
        'school': (context) => const SchoolScreen(),
        'class': (context) => const ClassScreen(),
        'feature': (context) => const FeatureScreen(),
        'select': (context) => const MultiSelectscreen(),
        'agree': (context) => const AgreeScreen(),
        'welcome': (context) => const WelcomeScreen(),
        'tab': (context) => const TabPage(),
        'hint': (context) => const HintScreen(),
        'candy': (context) => const CandyScreen(),
        '_working': (context) => const TabPage(),
      },
    );
  }
}
