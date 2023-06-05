import 'package:cooing_front/model/response/question.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:cooing_front/pages/answer_page.dart';
import 'package:get/get.dart';
import 'package:uni_links/uni_links.dart';

class DynamicLink {
  Future<bool> setup(String uid) async {
    bool isExistDynamicLink = await _getInitialDynamicLink(uid);
    print("In dynamicLink() : $isExistDynamicLink");

    try {
      _addListener(uid);
    } catch (e) {
      print("In dynamicLink() ERROR : $e");
    }

    return isExistDynamicLink;
  }

  Future<bool> _getInitialDynamicLink(String uid) async {
    // final String? deepLink = await getInitialLink();
    // print("deepLink ::: $deepLink");
    // print("In dynamicLink() : link로 접속했는지 확인");
    // if (deepLink != null && deepLink.isNotEmpty) {
    //   PendingDynamicLinkData? dynamicLinkData = await FirebaseDynamicLinks
    //       .instance
    //       .getDynamicLink(Uri.parse(deepLink));

    //   if (dynamicLinkData != null) {
    //     print("dynamicLinkData = $dynamicLinkData");
    //     _redirectScreen(dynamicLinkData);

    //     return true;
    //   }
    // }

    // return false;
    await Future.delayed(Duration(seconds: 3));
    final PendingDynamicLinkData? initialLink =
        await FirebaseDynamicLinks.instance.getInitialLink();

    if (initialLink != null) {
      _redirectScreen(uid, initialLink);
      return true;
    }

    final String? deepLink = await getInitialLink();
    if (deepLink != null && deepLink.isNotEmpty) {
      FirebaseDynamicLinks.instance
          .getDynamicLink(Uri.parse(deepLink))
          .then((link) => _redirectScreen(uid, link!));
      return true;
    }

    return false;
  }

  void _addListener(String uid) {
    FirebaseDynamicLinks.instance.onLink.listen((
      PendingDynamicLinkData dynamicLinkData,
    ) {
      _redirectScreen(uid, dynamicLinkData);
    }).onError((error) {
      print("In dynamicLink() - addListener : $error");
    });
  }

  void _redirectScreen(String uid, PendingDynamicLinkData dynamicLinkData) {
    print("In dynamicLink() - _redirectScreen : ${dynamicLinkData.link}");
    if (dynamicLinkData.link.queryParameters.containsKey('cid')) {
      // String? questionId
      String questionId =
          dynamicLinkData.link.path.split('/').last; //questionId

      String contentId =
          dynamicLinkData.link.queryParameters['cid'] ?? ""; //contentId
      String ownerId =
          dynamicLinkData.link.queryParameters['ownerId'] ?? ""; //contentId
      String content =
          dynamicLinkData.link.queryParameters['content'] ?? ""; //content
      String ownerName =
          dynamicLinkData.link.queryParameters['ownerName'] ?? ""; //ownerName
      String ownerProfileImage =
          dynamicLinkData.link.queryParameters['imgUrl'] ??
              ""; //ownerProfileImg

      // print("_redirectScreen: questionId-$questionId, contentId-$contentId");
      // 임시 Question
      Question question = Question(
          id: questionId.replaceAll('%20', ' '), //url 에서의 %20 -> ' ' 공백으로 바꿈
          ownerProfileImage: ownerProfileImage,
          ownerName: ownerName.replaceAll('%20', ' '),
          owner: ownerId,
          content: content.replaceAll('%20', ' '),
          contentId: contentId,
          receiveTime: '',
          openTime: '',
          url: '',
          schoolCode: '',
          isOpen: false,
          fcmToken: '');

      Get.offAll(() => AnswerPage(
            question: question,
            user: null,
            uid: uid,
            isFromLink: true,
          ));
    }
  }
}

Future<String> getShortLink(Question question) async {
  String dynamicLinkPrefix = 'https://midascooing.page.link';
  final dynamicLinkParams = DynamicLinkParameters(
      uriPrefix: dynamicLinkPrefix,
      link: Uri.parse(
          '$dynamicLinkPrefix/${question.id}?cid=${question.contentId}&content=${question.content}&ownerId=${question.owner}&ownerName=${question.ownerName}&imgUrl=${question.ownerProfileImage}'),
      androidParameters: const AndroidParameters(
        packageName: 'com.midas.cooing',
        minimumVersion: 0,
      ),
      iosParameters: const IOSParameters(
        bundleId: 'com.midas.cooing',
        appStoreId: '6448777284',
        minimumVersion: '0',
      ),
      navigationInfoParameters:
          NavigationInfoParameters(forcedRedirectEnabled: true));
  final dynamicLink =
      await FirebaseDynamicLinks.instance.buildShortLink(dynamicLinkParams);

  return dynamicLink.shortUrl.toString();
}
