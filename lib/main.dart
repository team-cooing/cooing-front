// 2023.06.18 SUN Midas: ✅

import 'package:cooing_front/firebase_options.dart';
import 'package:cooing_front/pages/login/agree_screen.dart';
import 'package:cooing_front/pages/login/class_screen.dart';
import 'package:cooing_front/pages/login/login_screen.dart';
import 'package:cooing_front/pages/login/school_screen.dart';
import 'package:cooing_front/pages/login/sign_up_screen.dart';
import 'package:cooing_front/pages/login/splash_screen.dart';
import 'package:cooing_front/pages/login/welcome_screen.dart';
import 'package:cooing_front/pages/tab_page.dart';
import 'package:cooing_front/providers/UserProvider.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cooing_front/pages/login/feature_screen.dart';
import 'package:cooing_front/pages/login/multi_select_screen.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart' as kakao;
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

late AndroidNotificationChannel channel;
late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

void main() async {
  // 카카오 SDK 초기화
  kakao.KakaoSdk.init(nativeAppKey: '010e5977ad5bf0cfbc9ab47ebfaa14a2');
  WidgetsFlutterBinding.ensureInitialized();
  // 파이어베이스 초기화
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  channel = const AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    description:
        'This channel is used for important notifications.', // description
    importance: Importance.high,
  );

  var initialzationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  var initialzationSettingsIOS = IOSInitializationSettings(
    requestSoundPermission: true,
    requestBadgePermission: true,
    requestAlertPermission: true,
  );

  flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  var initializationSettings = InitializationSettings(
      android: initialzationSettingsAndroid, iOS: initialzationSettingsIOS);

  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
  );

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  if (defaultTargetPlatform == TargetPlatform.android) {
    InAppPurchaseAndroidPlatformAddition.enablePendingPurchases();
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserDataProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      var androidNotiDetails = AndroidNotificationDetails(
        channel.id,
        channel.name,
        channelDescription: channel.description,
      );
      var iOSNotiDetails = const IOSNotificationDetails();
      var details =
          NotificationDetails(android: androidNotiDetails, iOS: iOSNotiDetails);
      if (notification != null) {
        flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          details,
        );
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      print(message);
    });

    super.initState();
  }

  static FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  static FirebaseAnalyticsObserver observer =
      FirebaseAnalyticsObserver(analytics: analytics);

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(375, 844),
        minTextAdapt: true,
        builder: (context, child) {
          return GetMaterialApp(
            navigatorObservers: <NavigatorObserver>[observer],
            initialRoute: SplashScreen.routeName,
            routes: {
              SplashScreen.routeName: (context) => SplashScreen(),
              'home': (context) => const LoginScreen(),
              'signUp': (context) => const SignUpScreen(),
              'school': (context) => const SchoolScreen(),
              'class': (context) => const ClassScreen(),
              'feature': (context) => const FeatureScreen(),
              'select': (context) => const MultiSelectScreen(),
              'agree': (context) => const AgreeScreen(),
              'welcome': (context) => const WelcomeScreen(),
              'tab': (context) => const TabPage(),
              '_working': (context) => const TabPage(),
            },
          );
        });
  }
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('Handling a background message ${message.messageId}');
}
