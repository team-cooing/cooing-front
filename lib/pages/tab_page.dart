import 'package:cooing_front/model/response/user.dart';
import 'package:cooing_front/pages/SettingScreen.dart';
import 'package:cooing_front/pages/login/LoginScreen.dart';
import 'package:flutter/material.dart';
import 'package:cooing_front/pages/question_page.dart';
import 'package:cooing_front/pages/message_page.dart';
import 'package:cooing_front/pages/feed_page.dart';
import 'package:get/get.dart';
import 'package:cooing_front/model/response/response.dart' as response;
import 'package:cooing_front/model/config/palette.dart';

class TabPage extends StatefulWidget {
  const TabPage({super.key});

  @override
  TabPageState createState() => TabPageState();
}

class TabPageState extends State<TabPage> with TickerProviderStateMixin {
  late String uid = '';
  late User? user;
  late TabController _tabController;
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
    print('TabPage: $uid');

    // 2. Firebase에서 User Data 가져오기
    getUserFromFirebase();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading? loadingView() : DefaultTabController(
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
            QuestionPage(user: user!,),
            FeedPage(user: user!),
            MessagePage(user: user!),
            SettingScreen(user: user!),
          ]),
        ));
  }

  Widget loadingView(){
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Center(
              child: CircularProgressIndicator(
                color: Palette.mainPurple,
              )
            ),
          ),
        ],
      ),
    );
  }

  getUserFromFirebase() async{
    // Firebase DB에서 User 읽기
    user = await response.Response.readUser(userUid: uid);

    // 만약, 유저가 있다면
    if(user!=null){
      setState(() {
        isLoading = false;
      });
    }else{
      // 로그인 페이지로 이동
      Get.offAll(LoginScreen());
    }
  }
}
