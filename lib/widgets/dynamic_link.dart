import 'package:cooing_front/pages/answer_page.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:uni_links/uni_links.dart';
import 'package:get/get.dart';

class DynamicLink {
  Future<bool> setup(String uid) async {
    bool isExistDynamicLink = await _getInitialDynamicLink(uid);
    print("11111 $isExistDynamicLink");

    try {
      _addListener(uid);
    } catch (e) {
      print("여기ㅇㅇㅇㅇㅇㅇ $e");
    }

    return isExistDynamicLink;
  }

  Future<bool> _getInitialDynamicLink(String uid) async {
    final String? deepLink = await getInitialLink();
    print(222222);

    if (deepLink != null) {
      PendingDynamicLinkData? dynamicLinkData = await FirebaseDynamicLinks
          .instance
          .getDynamicLink(Uri.parse(deepLink));

      if (dynamicLinkData != null) {
        print("dynamicLinkData = $dynamicLinkData");
        _redirectScreen(dynamicLinkData);

        return true;
      }
    }

    return false;
  }

  void _addListener(String uid) {
    FirebaseDynamicLinks.instance.onLink.listen((
      PendingDynamicLinkData dynamicLinkData,
    ) {
      _redirectScreen(dynamicLinkData);
    }).onError((error) {
      print("addListener : $error");
      // logger.e(error);
    });
  }

  void _redirectScreen(PendingDynamicLinkData dynamicLinkData) {
    print(333333333);
    print(dynamicLinkData.link.path);
    print(dynamicLinkData.link.queryParameters.containsKey('cid'));
    if (dynamicLinkData.link.queryParameters.containsKey('cid')) {
      String? questionId = dynamicLinkData.link.path.split('/').last;
      String? contentId = dynamicLinkData.link.queryParameters['cid']!;
      print("_redirectScreen: questionId-$questionId, contentId-$contentId");

      if (questionId.isNotEmpty && contentId.isNotEmpty) {
        print("qid : $questionId , cid : $contentId");
        Get.offAll(() => AnswerPage(), arguments: {
          // "uid": uid,
          "questionId": questionId,
          "contentId": contentId
        });
      } else {
        print("qid : $questionId , cid : $contentId");
      }
    }
  }
}

Future<String> getShortLink(String questionId, String contentId) async {
  String dynamicLinkPrefix = 'https://midascooing.page.link';
  print("getShortLink() : questionId : $questionId , contentId : $contentId");
  final dynamicLinkParams = DynamicLinkParameters(
    uriPrefix: dynamicLinkPrefix,
    link: Uri.parse('$dynamicLinkPrefix/$questionId?cid=$contentId'),
    androidParameters: const AndroidParameters(
      packageName: 'com.midas.cooing',
      minimumVersion: 0,
    ),
    // iosParameters: const IOSParameters(
    //   bundleId: packageName,
    //   minimumVersion: '0',
    // ),
  );
  final dynamicLink =
      await FirebaseDynamicLinks.instance.buildShortLink(dynamicLinkParams);

  print("dynamicLink : ${dynamicLink.toString()}");
  return dynamicLink.shortUrl.toString();
}
