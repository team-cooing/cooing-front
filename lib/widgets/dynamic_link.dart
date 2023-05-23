import 'package:cooing_front/model/response/question.dart';
import 'package:cooing_front/model/response/user.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:uni_links/uni_links.dart';
import 'package:cooing_front/pages/answer_page.dart';
import 'package:get/get.dart';

class DynamicLink {
  Future<bool> setup(String uid) async {
    bool isExistDynamicLink = await _getInitialDynamicLink(uid);
    print("In dynamicLink() : $isExistDynamicLink");

    try {
      _addListener(uid);
    } catch (e) {
      print("In dynamicLink() : $e");
    }

    return isExistDynamicLink;
  }

  Future<bool> _getInitialDynamicLink(String uid) async {
    final String? deepLink = await getInitialLink();
    print("In dynamicLink() : link로 접속했는지 확인");
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
      print("In dynamicLink() - addListener : $error");
    });
  }

  void _redirectScreen(PendingDynamicLinkData dynamicLinkData, String uid) {
    print("In dynamicLink() - _redirectScreen : ${dynamicLinkData.link}");
    if (dynamicLinkData.link.queryParameters.containsKey('cid')) {
      // String? questionId
      // TODO: 혜은 - question에 있는 변수 모두
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

      // TODO: 혜은 - user, question 객체 만들어서 answer page에 전달
      // 임시 User
      User user = User(
          uid: uid,
          name: "",
          profileImage: "",
          gender: 0,
          number: '',
          age: '',
          birthday: '',
          school: '',
          schoolCode: '',
          schoolOrg: '',
          grade: 1,
          group: 1,
          eyes: 0,
          mbti: '',
          hobby: '',
          style: [],
          isSubscribe: false,
          candyCount: 0,
          recentQuestionBonusReceiveDate: '',
          recentDailyBonusReceiveDate: '',
          questionInfos: [],
          answeredQuestions: [],
          currentQuestionId: '',
          serviceNeedsAgreement: true,
          privacyNeedsAgreement: true);

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
          isOpen: false);

      Get.offAll(() => AnswerPage(
            question: question,
            user: user,
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
    // iosParameters: const IOSParameters(
    //   bundleId: packageName,
    //   minimumVersion: '0',
    // ),
  );
  final dynamicLink =
      await FirebaseDynamicLinks.instance.buildShortLink(dynamicLinkParams);

  return dynamicLink.shortUrl.toString();
}
