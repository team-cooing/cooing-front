import 'package:flutter/material.dart';
import 'package:cooing_front/pages/tap_page.dart';
import 'package:cooing_front/widgets/link.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  void initState() {
    super.initState();
    // initDynamicLinks();
  }

  // void initDynamicLinks() async {
  //   final PendingDynamicLinkData data = await FirebaseDynamicLinks.instance.getInitialLink();

  //   FirebaseDynamicLinks.instance.onLink(
  //       onSuccess: (PendingDynamicLinkData dynamicLink) async {
  //         final Uri deepLink = dynamicLink.link;

  //         print(deepLink);
  //         print(deepLink.path);

  //       },
  //       onError: (OnLinkErrorException e) async {
  //         print('onLinkError');
  //         print(e.message);
  //       }
  //   );

  //   final PendingDynamicLinkData data = await FirebaseDynamicLinks.instance.getInitialLink();
  //   final Uri deepLink = data.link;

  //   print(deepLink);

  @override
  Widget build(BuildContext context) {
    return const TabPage();
  }
}
