import 'package:uni_links/uni_links.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';

class DynamicLink {
  Future<bool> setup() async {
    bool isExistDynamicLink = await _getInitialDynamicLink();
    _addListener();

    return isExistDynamicLink;
  }

  Future<bool> _getInitialDynamicLink() async {
    final String? deepLink = await getInitialLink();

    if (deepLink != null) {
      PendingDynamicLinkData? dynamicLinkData = await FirebaseDynamicLinks
          .instance
          .getDynamicLink(Uri.parse(deepLink));

      if (dynamicLinkData != null) {
        _redirectScreen(dynamicLinkData);

        return true;
      }
    }
    return false;
  }

  void _addListener() {
    FirebaseDynamicLinks.instance.onLink.listen((
      PendingDynamicLinkData dynamicLinkData,
    ) {
      _redirectScreen(dynamicLinkData);
    }).onError((error) {
      print(error);
      // logger.e(error);
    });
  }

  void _redirectScreen(PendingDynamicLinkData dynamicLinkData) {
    if (dynamicLinkData.link.queryParameters.containsKey('id')) {
      String link = dynamicLinkData.link.path.split('/').last;
      String id = dynamicLinkData.link.queryParameters['id']!;

      switch (link) {
        case 'AnswerPage':
          // Get.offAll(
          //     // () => AnswerPage(),
          //     );
          break;
      }
    }
  }

  Future<String> getShortLink(String screenName, String id) async {
    String dynamicLinkPrefix = 'https://cooing.page.link';

    final DynamicLinkParams = DynamicLinkParameters(
      link: Uri.parse('$dynamicLinkPrefix / $screenName?id=$id'),
      uriPrefix: dynamicLinkPrefix,
      androidParameters: const AndroidParameters(
        packageName: 'com.midas.cooing',
        minimumVersion: 0,
      ),
      iosParameters: const IOSParameters(
        bundleId: 'com.cooing.ios',
        minimumVersion: '0',
      ),
    );

    final dynamicLink =
        await FirebaseDynamicLinks.instance.buildShortLink(DynamicLinkParams);

    return dynamicLink.shortUrl.toString();
  }
}
