// 2023.06.19 MON Midas: ✅
// 코드 효율성 점검: ✅
// 예외처리: ✅
// 중복 서버 송수신 방지: ✅

import 'dart:io';
import 'dart:math';

import 'package:cooing_front/main.dart';
import 'package:cooing_front/model/response/answer.dart';
import 'package:cooing_front/model/response/question.dart';
import 'package:cooing_front/model/response/user.dart';
import 'package:cooing_front/pages/setting_page.dart';
import 'package:cooing_front/pages/feed_page.dart';
import 'package:cooing_front/pages/login/login_screen.dart';
import 'package:cooing_front/pages/message_page.dart';
import 'package:cooing_front/providers/hint_status_provider.dart';
import 'package:cooing_front/providers/user_provider.dart';
import 'package:cooing_front/widgets/dynamic_link.dart';
import 'package:cooing_front/widgets/loading_view.dart';
import 'package:flutter/material.dart';
import 'package:cooing_front/pages/question_page.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:cooing_front/model/response/response.dart' as response;
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TabPage extends StatefulWidget {
  const TabPage({super.key});

  @override
  TabPageState createState() => TabPageState();
}

class TabPageState extends State<TabPage> with TickerProviderStateMixin {
  BuildContext? scaffoldContext;
  late TabController _tabController;
  late String uid = '';
  late User? user;
  late Question? currentQuestion;
  late List<Question?> feeds = [];
  late String bonusQuestionId = '';
  late List<Answer?> answers = [];
  late bool isNewMessage = false;
  late SharedPreferences prefs;
  bool isUserDataGetting = true;
  bool isLoading = true;
  bool isDynamicLoading = true;
  List<dynamic> openedIds = [];
  late Map<String, dynamic> hints = {};

  List<Tab> myTabs = <Tab>[
    Tab(text: '질문'),
    Tab(text: '피드'),
    Tab(
      text: '메시지',
    ),
    Tab(
      icon: Icon(Icons.settings),
    ),
  ];

  BannerAd banner = BannerAd(
    listener: BannerAdListener(
      onAdFailedToLoad: (Ad ad, LoadAdError error) {},
      onAdLoaded: (_) {},
    ),
    size: AdSize.banner,
    adUnitId: UNIT_ID_BANNER[Platform.isIOS ? 'ios' : 'android']!,
    request: AdRequest(),
  )..load();

  @override
  void initState() {
    super.initState();

    // 1. 인자로 전달 받은 uid 가져오기
    uid = Get.arguments.toString();
    print('로그인 유저 UID: $uid 🙋');

    // 2. 필요한 Data 가져오기
    getInitialData();

    _tabController =
        TabController(length: myTabs.length, vsync: this, initialIndex: 0);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      DynamicLink.scaffoldContext = scaffoldContext;
      DynamicLink().setup(uid).then((value) {
        setState(() {
          isDynamicLoading = false;
        });
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    banner.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    scaffoldContext = context;

    myTabs[2] = Tab(
        icon: Stack(
      children: [
        SizedBox(
          width: double.infinity,
          height: double.infinity,
        ),
        Center(child: Text('메시지')),
        isNewMessage
            ? Positioned(
                right: 0,
                top: 5,
                child: Container(
                  alignment: Alignment.center,
                  width: 18,
                  height: 18,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: Color(0XFFEF4452),
                  ),
                  child: Text(
                    'N',
                    style: TextStyle(fontSize: 12.sp, color: Colors.white),
                  ),
                ),
              )
            : SizedBox(),
      ],
    ));

    return isLoading || isDynamicLoading
        ? loadingView()
        : DefaultTabController(
            length: myTabs.length,
            child: Scaffold(
              appBar: AppBar(
                automaticallyImplyLeading: false,
                backgroundColor: const Color(0xffFFFFFF),
                flexibleSpace: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TabBar(
                        controller: _tabController,
                        labelStyle: TextStyle(
                            fontSize: 18.sp, fontWeight: FontWeight.bold),
                        labelColor: Colors.black,
                        indicatorColor: Colors.transparent,
                        unselectedLabelColor: Colors.grey,
                        tabs: myTabs),
                  ],
                ),
              ),
              body: Column(
                children: [
                  Expanded(
                      child: TabBarView(controller: _tabController, children: [
                    QuestionPage(
                      user: user!,
                      currentQuestion: currentQuestion,
                      feed: feeds,
                    ),
                    FeedPage(
                      user: user!,
                      feed: feeds,
                      bonusQuestionId: bonusQuestionId,
                      hints: hints,
                    ),
                    MessagePage(
                        user: user!,
                        answers: answers,
                        hint: hints,
                        cache: openedIds),
                    SettingScreen(
                      user: user!,
                      currentQuestion: currentQuestion,
                    ),
                  ])),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: AdWidget(
                      ad: banner,
                    ),
                  )
                ],
              ),
            ));
  }

  getInitialData() async {
    try {
      // 1. User 데이터 가져오기
      user = await getUserData();

      // 1-2. HintStatus 데이터 가져오기
      HintStatusProvider hintStatusProvider = HintStatusProvider();
      await hintStatusProvider.loadHintStatusDataFromCookie();
      if (hintStatusProvider.hintStatusData != null) {
        hints = hintStatusProvider.hintStatusData!.isHintOpends;
      }

      // 2. Current Question 데이터 가져오기
      currentQuestion = user!.currentQuestion.isNotEmpty
          ? Question.fromJson(user!.currentQuestion)
          : null;

      // 3. Feed Questions 데이터 가져오기
      await response.Response.initFeedContentString(
          schoolCode: user!.schoolCode);
      feeds = await response.Response.getQuestionsWithLimit(10);

      if (feeds.isNotEmpty) {
        List<String> unansweredFeeds = [];
        for(var question in feeds){
          if(question!=null){
            if(user!.answeredQuestions.contains(question.id) == false){
              unansweredFeeds.add(question.id);
            }
          }
        }

        if(unansweredFeeds.isNotEmpty){
          bonusQuestionId = unansweredFeeds[Random().nextInt(unansweredFeeds.length)];
        }
      }

      // 4. Answer 데이터 가져오기
      await response.Response.initMessageContentString(uid: user!.uid);
      answers = await response.Response.getMessageWithLimit(10);

      openedIds = await _loadIsOpenedFromCookie();

      for (var i in answers) {
        if (i != null) {
          if (!openedIds.contains(i.id)) {
            setState(() {
              isNewMessage = true;
            });

            break;
          }
        }
      }

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      // 로그인 페이지로 이동
      Get.offAll(LoginScreen());
      print('알 수 없는 에러 - E: $e');
    }
  }

  Future<User?> getUserData() async {
    UserDataProvider userProvider = UserDataProvider();
    await userProvider.loadUserDataFromCookie();
    User? newUser = userProvider.userData;

    return newUser;
  }

  Future<List<dynamic>> _loadIsOpenedFromCookie() async {
    prefs = await SharedPreferences.getInstance();
    final value = prefs.get('AnswerId');

    if (value != null) {
      if (value is List<dynamic>) {
        return value.cast<String>().toList();
      } else {
        return [];
      }
    } else {
      return [];
    }
  }
}
