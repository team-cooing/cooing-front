import 'package:app_links/app_links.dart';
import 'package:cooing_front/model/response/question.dart';
import 'package:cooing_front/pages/tab_page.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:get/get.dart';
import 'package:uni_links/uni_links.dart';

class DynamicLink {
  static Question? targetQuestion;

  Future<bool> setup(String uid) async {
    bool isExistDynamicLink = await _getInitialDynamicLink(uid);

    _addListener(uid);

    return isExistDynamicLink;
  }

  Future<bool> _getInitialDynamicLink(String uid) async {

    // await Future.delayed(Duration(seconds: 2));

    final _appLinks = AppLinks();
    final String? deepLink = await getInitialLink();


    if (deepLink != null) {
      PendingDynamicLinkData? dynamicLinkData = await FirebaseDynamicLinks
          .instance
          .getDynamicLink(Uri.parse(deepLink));

      if (dynamicLinkData != null) {
        _redirectScreen(uid, dynamicLinkData);
        return true;
      }
    }
    //terminate 상태에서 링크캐치하기
    else{
      final Uri? uri = await _appLinks.getInitialAppLink();
        if (uri != null){
          final PendingDynamicLinkData? appLinkData = await FirebaseDynamicLinks.instance.getDynamicLink(uri);

          if(appLinkData != null){
            _redirectScreen(uid, appLinkData);
            return true;
          }
        }
    }

    return false;
  }

  void _addListener(String uid) {
    FirebaseDynamicLinks.instance.onLink.listen((
        PendingDynamicLinkData dynamicLinkData,) {
      _redirectScreen(uid, dynamicLinkData);
    }).onError((error) {
      print("In dynamicLink() - addListener : $error");
    });
  }

  void _redirectScreen(String uid, PendingDynamicLinkData dynamicLinkData) {
    if (dynamicLinkData.link.queryParameters.containsKey('cid')) {
      // String? questionId
      String questionId =
          dynamicLinkData.link.path
              .split('/')
              .last; //questionId

      String contentId =
          dynamicLinkData.link.queryParameters['cid'] ?? ""; //contentId
      String ownerId =
          dynamicLinkData.link.queryParameters['ownerId'] ?? ""; //ownerId
      String content =
          dynamicLinkData.link.queryParameters['content'] ?? ""; //content
      String ownerName =
          dynamicLinkData.link.queryParameters['ownerName'] ?? ""; //ownerName
      String ownerProfileImage =
          dynamicLinkData.link.queryParameters['imgUrl'] ??
              ""; //ownerProfileImg
      String receiveTime =
          dynamicLinkData.link.queryParameters['rcvTime'] ?? ""; //receiveTime
      String fcmToken = dynamicLinkData.link.queryParameters['fcmToken'] ?? "";

      // 임시 Question
      Question question = Question(
          id: questionId.replaceAll('%20', ' '),
          //url 에서의 %20 -> ' ' 공백으로 바꿈
          ownerProfileImage: ownerProfileImage,
          ownerName: ownerName.replaceAll('%20', ' '),
          owner: ownerId,
          content: content.replaceAll('%20', ' '),
          contentId: contentId,
          receiveTime: receiveTime.replaceAll('+', ' '),
          openTime: '',
          url: '',
          schoolCode: '',
          isOpen: false,
          fcmToken: fcmToken.replaceAll('%20', ' ')
      );

      targetQuestion = question;

      Get.offAll(() =>
          TabPage(isLinkEntered: true));
    }
  }
}

Future<String> getShortLink(Question question) async {
  String dynamicLinkPrefix = 'https://midascooing.page.link';
  final dynamicLinkParams = DynamicLinkParameters(
      uriPrefix: dynamicLinkPrefix,
      link: Uri.parse(
          '$dynamicLinkPrefix/${question.id}?cid=${question
              .contentId}&content=${question.content}&ownerId=${question
              .owner}&ownerName=${question.ownerName}&imgUrl=${question
              .ownerProfileImage}&rcvTime=${question.receiveTime}&fcmToken=${question.fcmToken}'),
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
      NavigationInfoParameters(forcedRedirectEnabled: false)
  );

  final dynamicLink =
  await FirebaseDynamicLinks.instance.buildShortLink(
      dynamicLinkParams, shortLinkType: ShortDynamicLinkType.unguessable);

  return dynamicLink.shortUrl.toString();
}
