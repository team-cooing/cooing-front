import 'package:cooing_front/model/response/answer.dart';
import 'package:cooing_front/model/response/question.dart';
import 'package:cooing_front/model/response/user.dart';
import 'package:cooing_front/pages/SettingScreen.dart';
import 'package:cooing_front/pages/feed_page.dart';
import 'package:cooing_front/pages/login/LoginScreen.dart';
import 'package:cooing_front/pages/message_page.dart';
import 'package:flutter/material.dart';
import 'package:cooing_front/pages/question_page.dart';
import 'package:get/get.dart';
import 'package:cooing_front/model/response/response.dart' as response;
import 'package:cooing_front/model/config/palette.dart';

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
  late String bonusQuestionId;
  late List<Answer?> answers = [];

  bool isUserDataGetting = true;
  bool isLoading = true;

  List<Tab> myTabs = <Tab>[
    Tab(text: '질문'),
    Tab(text: '피드'),
    Tab(text: '메시지'),
    Tab(
      icon: Icon(Icons.settings),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController =
        TabController(length: myTabs.length, vsync: this, initialIndex: 0);

    // 1. 인자로 전달 받은 uid 가져오기
    uid = Get.arguments.toString();
    print('로그인 유저 UID: $uid');

    // 2. Firebase에서 Data 가져오기
    getInitialDataFromFirebase();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                    labelStyle: const TextStyle(
                        fontSize: 18.0, fontWeight: FontWeight.bold),
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
            MessagePage(user: user!, answers: answers,),
            SettingScreen(user: user!),
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

  getInitialDataFromFirebase() async {
    // 1. User 데이터 가져오기
    user = await getUserData();

    // 만약, 유저가 있다면
    if (user != null) {
      // 2. Current Question 데이터 가져오기
      currentQuestion = await getCurrentQuestionData();
      // 3. Feed Questions 데이터 가져오기
      feed = await getFeedQuestionsInSetOfTen();
      // 4. Answer 데이터 가져오기
      answers = await getAnswersInSetOfTen();

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
    User? newUser = await response.Response.readUser(userUid: uid);

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

      return newQuestion;
    } else {
      return null;
    }
  }

  getFeedQuestionsInSetOfTen() async {
    // Firebase DB에서 feedQuestion 10개 읽기
    List<Question?> newFeedQuestions =
    await response.Response.readQuestionsInFeedWithLimit(
        schoolCode: user!.schoolCode, limit: 10);

    // 보너스 질문 id 구하기
    // 가장 적은 질문을 가진 question 찾기
    String questionIdWithMinAnswersNum = '';
    int minAnswersNum = 999;

    for (var question in newFeedQuestions) {
      // 만약, 질문이 있다면
      if (question != null) {
        // 만약, 이미 답변한 질문이라면
        if(user!.answeredQuestions.contains(question.id) || question.owner==user!.uid){
          continue;
        }

        // 만약, '가장 적은 질문을 가진 question'이 없다면
        if (questionIdWithMinAnswersNum.isEmpty) {
          questionIdWithMinAnswersNum = question.id;
        }

        Answer? lastAnswer =await response.Response.readLastAnswer(
            userId: question.owner);

        // 만약, 마지막 답변이 있다면
        if (lastAnswer != null) {
          // 만약, 마지막 답변이 지금 질문에 대한 것이 아니라면
          if (lastAnswer.questionId != question.id) {
            continue;
          }
          // 만약, 마지막 답변이 지금 질문에 대한 것이라면
          else {
            String extractedNumber = lastAnswer.id.substring(1, 7);
            int result = int.parse(extractedNumber);

            if (result < minAnswersNum) {
              questionIdWithMinAnswersNum = question.id;
              minAnswersNum = result;
            }
          }
        }
      }
    }

    bonusQuestionId = questionIdWithMinAnswersNum;

    return newFeedQuestions;
  }

  getAnswersInSetOfTen() async {
    // Firevase DB에서 feedQuestion 10개 읽기
    List<Answer?> newAnswers = await response.Response.readAnswersWithLimit(
        userId: user!.uid, limit: 3);

    return newAnswers;
  }
}
