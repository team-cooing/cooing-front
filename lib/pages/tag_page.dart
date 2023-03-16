import 'package:flutter/material.dart';
import 'package:cooing_front/pages/question_page.dart';

class TabPage extends StatefulWidget {
  const TabPage({super.key});

  @override
  TabPageState createState() => TabPageState();
}

class TabPageState extends State<TabPage> with TickerProviderStateMixin {
  late TabController _tabController;

  static const List<Tab> myTabs = <Tab>[
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
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // final int _selectedPageIndex = 0;

  // final List _pages = [
  //   const Text('질문'),
  //   const Text('피드'),
  //   const Text('메시지'),
  //   const Text('설정')
  // ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: myTabs.length,
        child: Scaffold(
          appBar: AppBar(
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
          body: TabBarView(controller: _tabController, children: const [
            QuestionPage(),
            Tab(icon: Icon(Icons.directions_car)),
            Tab(icon: Icon(Icons.directions_bike_outlined)),
            Tab(icon: Icon(Icons.directions_boat))
          ]),
        ));
  }
}
