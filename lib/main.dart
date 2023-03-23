<<<<<<< HEAD
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
=======
import 'package:cooing_front/pages/main_page.dart';
import 'package:flutter/material.dart';
>>>>>>> parent of 35a4f83 (Merge pull request #4 from team-cooing/kakao-login-page)
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
<<<<<<< HEAD

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

=======
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
>>>>>>> parent of 35a4f83 (Merge pull request #4 from team-cooing/kakao-login-page)
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MainPage(),
    );
  }
}
