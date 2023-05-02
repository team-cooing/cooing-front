import 'package:flutter/material.dart';
import 'package:cooing_front/pages/tab_page.dart';
import 'package:cooing_front/widgets/link.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return const TabPage();
  }

  @override
  void initState() {
    super.initState();
    DynamicLink().setup();
  }
}
