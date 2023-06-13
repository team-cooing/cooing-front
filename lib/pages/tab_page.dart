import 'package:cooing_front/model/response/answer.dart';
import 'package:cooing_front/model/response/question.dart';
import 'package:cooing_front/model/response/user.dart';
import 'package:cooing_front/pages/setting_page.dart';
import 'package:cooing_front/pages/feed_page.dart';
import 'package:cooing_front/pages/login/LoginScreen.dart';
import 'package:cooing_front/pages/message_page.dart';
import 'package:cooing_front/providers/UserProvider.dart';
import 'package:flutter/material.dart';
import 'package:cooing_front/pages/question_page.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:cooing_front/model/response/response.dart' as response;
import 'package:cooing_front/model/config/palette.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TabPage extends StatefulWidget {
  const TabPage({super.key});

  @override
  TabPageState createState() => TabPageState();
}

class TabPageState extends State<TabPage> with TickerProviderStateMixin {
  late TabController _tabController;
  late String uid = '';
  late User? user;
  late Question? currentQuestion;
  late List<Question?> feed = [];
  late String bonusQuestionId = '2023-06-08 16:12:16.416970';
  late List<Answer?> answers = [];
  late bool isNewMessage = false;
  late SharedPreferences prefs;
  bool isUserDataGetting = true;
  bool isLoading = true;
  late List<dynamic> openedIds = [];
  late Map<String, dynamic>? hint;

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

  @override
  void initState() {
    super.initState();

    // 1. 인자로 전달 받은 uid 가져오기
    uid = Get.arguments.toString();
    print('로그인 유저 UID: $uid');

    response.Response.readQuestionInFeed(schoolCode: '7530128');
    response.Response.readAnswerInMessage(userId: uid);

    // 2. Firebase에서 Data 가져오기
    getInitialDataFromFirebase();

    _tabController =
        TabController(length: myTabs.length, vsync: this, initialIndex: 0);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                  width: 18.w,
                  height: 18.h,
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

    return isLoading
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
              body: TabBarView(controller: _tabController, children: [
                QuestionPage(
                  user: user!,
                  currentQuestion: currentQuestion,
                  feed: feed,
                ),
                FeedPage(
                  user: user!,
                  feed: feed,
                  bonusQuestionId: bonusQuestionId,
                ),
                MessagePage(
                    user: user!,
                    answers: answers,
                    hint: hint,
                    cache: openedIds),
                SettingScreen(
                  user: user!,
                  currentQuestion: currentQuestion,
                ),
              ]),
            ));
  }

  Widget loadingView() {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Center(
                child: CircularProgressIndicator(
              color: Palette.mainPurple,
            )),
          ),
        ],
      ),
    );
  }

  Future<void> _loadIsOpenedFromCookie() async {
    prefs = await SharedPreferences.getInstance();
    final value = prefs.get('AnswerId');

    if (value is List<dynamic>) {
      openedIds = value.cast<String>().toList();
      print('openedId');

      print(openedIds);
    } else {
      // Handle the case when the value is not a list
    }
  }

  getInitialDataFromFirebase() async {
    // 1. User 데이터 가져오기

    await _loadIsOpenedFromCookie();
    hint = (await response.Response.readHint(ownerId: uid))
        as Map<String, dynamic>?;
    print(hint.runtimeType);
    print(hint);
    user = await getUserData();
    // 만약, 유저가 있다면
    if (user != null) {
      // 2. Current Question 데이터 가져오기
      currentQuestion = await getCurrentQuestionData();
      print(currentQuestion);
      print('----위는 퀘스천---');

      // 3. Feed Questions 데이터 가져오기
      feed = await getFeedQuestionsInSetOfTen();

      // 4. Answer 데이터 가져오기
      answers = await getAnswersInSetOfTen();
      print(answers);
      print('---위는 엔설----');

      setState(() {
        isLoading = false;
      });
    } else {
      // 로그인 페이지로 이동
      Get.offAll(LoginScreen());
    }
  }

  getUserData() async {
    // Firebase DB에서 User 읽기
    UserDataProvider userProvider = UserDataProvider();
    await userProvider.loadData();
    User? newUser = userProvider.userData;
    // User? newUser = await response.Response.readUser(userUid: uid);

    return newUser;
  }

  getCurrentQuestionData() async {
    // 만약, currentQuestionId가 있다면
    if (user!.currentQuestionId.isNotEmpty) {
      String currentQuestionId = user!.currentQuestionId;

      // currentQuestionId = '#{contentId}_{questionId}'
      // currentQuestionId를 contentId와 questionId로 분리
      String strippedVariable = currentQuestionId.replaceAll('#', ''); // # 제거
      List<String> ids = strippedVariable.split('_'); // _로 분리

      String contentId = ids[0];
      String questionId = ids[1];

      // Firebase DB에서 Question 읽기
      Question? newQuestion = await response.Response.readQuestion(
          contentId: contentId, questionId: questionId);
      print('불러옴');
      print(newQuestion!.isOpen);
      print(user!.currentQuestionId);

      return newQuestion;
    } else {
      print('없어?');
      return null;
    }
  }

  getFeedQuestionsInSetOfTen() async {
    // Firebase DB에서 feedQuestion 10개 읽기
    // await response.Response.readQuestionInFeed(schoolCode: '7530128');
    List<Question?> newFeedQuestions =
        await response.Response.getQuestionsWithLimit(1, '7530128');
    print('왜 안찍혀?');
    print(newFeedQuestions);
    // 보너스 질문 id 구하기
    // 가장 적은 질문을 가진 question 찾기
    // String questionIdWithMinAnswersNum = '';
    // int minAnswersNum = 999;

    // for (var question in newFeedQuestions) {
    //   // 만약, 질문이 있다면
    //   if (question != null) {
    //     // 만약, 이미 답변한 질문이라면
    //     if (user!.answeredQuestions.contains(question.id) ||
    //         question.owner == user!.uid) {
    //       continue;
    //     }

    //     // 만약, '가장 적은 질문을 가진 question'이 없다면
    //     if (questionIdWithMinAnswersNum.isEmpty) {
    //       questionIdWithMinAnswersNum = question.id;
    //     }

    //     Answer? lastAnswer =
    //         await response.Response.readLastAnswer(userId: question.owner);

    //     // 만약, 마지막 답변이 있다면
    //     if (lastAnswer != null) {
    //       // 만약, 마지막 답변이 지금 질문에 대한 것이 아니라면
    //       if (lastAnswer.questionId != question.id) {
    //         continue;
    //       }
    //       // 만약, 마지막 답변이 지금 질문에 대한 것이라면
    //       else {
    //         String extractedNumber = lastAnswer.id.substring(1, 7);
    //         int result = int.parse(extractedNumber);

    //         if (result < minAnswersNum) {
    //           questionIdWithMinAnswersNum = question.id;
    //           minAnswersNum = result;
    //         }
    //       }
    //     }
    //   }
    // }

    // bonusQuestionId = questionIdWithMinAnswersNum;

    return newFeedQuestions;
  }

  getAnswersInSetOfTen() async {
    // Firevase DB에서 feedQuestion 10개 읽기
    List<Answer?> newAnswers =
        await response.Response.getAnswersWithLimit(1, uid);

    // 최근 10개 중 안읽은 answer 있으면 New 표시
    for (var answer in newAnswers) {
      if (answer != null) {
        if (answer.isOpened == false) {
          isNewMessage = true;
        }
      }
    }

    return newAnswers;
  }
}
