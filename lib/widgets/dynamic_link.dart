import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:uni_links/uni_links.dart';
import 'package:cooing_front/pages/answer_page.dart';
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
        _redirectScreen(dynamicLinkData, uid);

        return true;
      }
    }

    return false;
  }

  void _addListener(String uid) {
    List urlData = [];
    FirebaseDynamicLinks.instance.onLink.listen((
      PendingDynamicLinkData dynamicLinkData,
    ) {
      _redirectScreen(dynamicLinkData, uid);
    }).onError((error) {
      print("addListener : $error");
      // logger.e(error);
    });
  }

  void _redirectScreen(PendingDynamicLinkData dynamicLinkData, String uid) {
    print("333333333::::: ${dynamicLinkData.link}");
    if (dynamicLinkData.link.queryParameters.containsKey('cid')) {
      // String? questionId
      String questionId =
          dynamicLinkData.link.path.split('/').last; //questionId
      String? contentId =
          dynamicLinkData.link.queryParameters['cid']; //contentId
      String? ownerId =
          dynamicLinkData.link.queryParameters['ownerId']; //contentId
      String? content =
          dynamicLinkData.link.queryParameters['content']; //content
      String? ownerName =
          dynamicLinkData.link.queryParameters['ownerName']; //ownerName
      String? ownerProfileImage =
          dynamicLinkData.link.queryParameters['imgUrl']; //ownerProfileImg

      // print("_redirectScreen: questionId-$questionId, contentId-$contentId");
      Get.offAll(() => AnswerPage(), arguments: {
        "uid": uid,
        "questionId": questionId,
        "contentId": contentId,
        "content": content,
        "ownerId" : ownerId,
        "ownerName": ownerName,
        "ownerProfileImage": ownerProfileImage
      });
    }
  }
}

Future<String> getShortLink(String questionId, String contentId, String content,
    String ownerId, String ownerName, String ownerProfileImage) async {
  String dynamicLinkPrefix = 'https://midascooing.page.link';
  final dynamicLinkParams = DynamicLinkParameters(
    uriPrefix: dynamicLinkPrefix,
    link: Uri.parse(
        '$dynamicLinkPrefix/$questionId?cid=$contentId&content=$content&ownerId=$ownerId&ownerName=$ownerName&imgUrl=$ownerProfileImage'),
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

  return dynamicLink.shortUrl.toString();
}
