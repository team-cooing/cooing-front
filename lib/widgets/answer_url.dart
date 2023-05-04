import 'package:flutter/services.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:get/get.dart';
import 'package:cooing_front/pages/answer_page.dart';
import 'package:cooing_front/pages/login/SignUpScreen.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:provider/provider.dart';
import 'package:flutter/widgets.dart';
import 'package:cooing_front/providers/UserProvider.dart';

Future<void> createDynamicLink(BuildContext context, String questionId,
    String questionContent, String profileImage, String name) async {
  final DynamicLinkParameters parameters = DynamicLinkParameters(
    uriPrefix: 'https://cooing.page.link',
    link: Uri.parse(
        'https://cooing.page.link/answer?questionId=$questionId&questionContent=$questionContent&profileImage=$profileImage&name=$name'),
    androidParameters: AndroidParameters(
      packageName: 'com.example.cooing_front',
      minimumVersion: 125,
    ),
    // iosParameters: IosParameters(
    //     bundleId: 'com.example.ios',
    //     minimumVersion: '1.0.1',
    //     appStoreId: '123456789',
    // ),
    // googleAnalyticsParameters: GoogleAnalyticsParameters(
    //     campaign: 'example-promo',
    //     medium: 'social',
    //     source: 'orkut',
    // ),
    // itunesConnectAnalyticsParameters: ItunesConnectAnalyticsParameters(
    //     providerToken: '123456',
    //     campaignToken: 'example-promo',
    // ),
    socialMetaTagParameters: SocialMetaTagParameters(
      title: '재치있고 신박한 답변으로 친구를 감동시켜보세요!',
      description: 'This link works whether the app is installed or not!',
      imageUrl: Uri.parse('https://www.example.com/image.jpg'),
    ),
  );
  final authentication = firebase.FirebaseAuth.instance;

  var shortDynamicLink = await FirebaseDynamicLinks.instance.buildShortLink(
    parameters,
  );
  final Uri dynamicUrl = shortDynamicLink.shortUrl;

  Clipboard.setData(ClipboardData(text: dynamicUrl.toString()));
// Dynamic Link를 생성한 후, 클립보드에 저장합니다.
  print("clipboard 저장");
  if (authentication.currentUser != null) {
    // User is logged in, navigate to AnswerPage with user data
    final currentUser = authentication.currentUser!;
    final userDataProvider =
        Provider.of<UserDataProvider>(context, listen: false);
    final userData = userDataProvider.userData;

    Get.to(() => AnswerPage(
          user: userData!,
          questionId: questionId,
          questionContent: questionContent,
          profileImage: profileImage,
          name: name,
        ));
  } else {
    // User is not logged in, navigate to SignUpPage
    Get.to(() => SignUpScreen());
  }
// 생성한 Dynamic Link의 파라미터를 AnswerPage로 전달하여 이동합니다.
}
