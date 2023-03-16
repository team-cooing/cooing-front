import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';

Future<String> getShortLink(String screenName, String id) async {
  String dynamicLinkPrefix = 'https://cooing.page.link';

  final DynamicLinkParams = DynamicLinkParameters(
    link: Uri.parse('$dynamicLinkPrefix / $screenName?id=$id'),
    uriPrefix: dynamicLinkPrefix,
    androidParameters: const AndroidParameters(
      packageName: 'com.cooing.android',
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
