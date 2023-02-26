import 'package:flutter/material.dart';

class MainAppBar extends StatefulWidget {
  const MainAppBar({super.key});
  @override
  State<MainAppBar> createState() => _MainAppBarState();
}

class _MainAppBarState extends State<MainAppBar>
    with SingleTickerProviderStateMixin {
  static const List<Tab> myTabs = <Tab>[
    Tab(text: '질문'),
    Tab(text: '피드'),
    Tab(text: '메시지'),
    Tab(
      text: '확인용', //text로 확인하기 위해(아이콘은 널값이라 오류나서)
      icon: Icon(Icons.settings),
    ),
  ];

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: myTabs.length);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      body: TabBarView(
        controller: _tabController,
        children: myTabs.map((Tab tab) {
          final String label = tab.text!.toLowerCase();
          return Center(
            child: Text(
              '여기는 $label tab',
              style: const TextStyle(fontSize: 35),
            ),
          );
        }).toList(),
      ),
    );
  }
}
