// 2023.06.20 TUE Midas: ✅
// 코드 효율성 점검: ✅
// 예외처리: ✅
// 중복 서버 송수신 방지: ✅

import 'package:cooing_front/pages/hint_page.dart';
import 'package:cooing_front/model/response/answer.dart';
import 'package:cooing_front/model/response/user.dart';
import 'package:cooing_front/model/data/question_list.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:social_share/social_share.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:async';
import 'dart:io';

class AnswerDetailPage extends StatefulWidget {
  final User user;
  final Answer answer;
  final Map<String, dynamic>? hint;

  const AnswerDetailPage(
      {required this.user,
      required this.answer,
      super.key,
      required this.hint});

  @override
  AnswerDetailPageState createState() => AnswerDetailPageState();
}

class AnswerDetailPageState extends State<AnswerDetailPage> {
  late CollectionReference answerDocRef;
  late CollectionReference questionDocRef;

  late String contentId;
  late String questionContent;

  late User userData;
  late Answer answerData;
  late String imgUrl = '';

  @override
  void initState() {
    super.initState();
    userData = widget.user;
    answerData = widget.answer;
    questionContent = QuestionList.questionList
        .elementAt(int.parse(widget.answer.contentId))['question'] as String;

    imgUrl = userData.profileImage;
  }

  int maxLength = 100;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: Color.fromARGB(0, 87, 56, 56),
          elevation: 0.0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            color: Colors.black54,
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          actions: [
            IconButton(
                onPressed: () async {
                  final reportUrl = Uri.parse('https://pf.kakao.com/_kexoDxj');

                  if (await canLaunchUrl(reportUrl)) {
                    launchUrl(reportUrl, mode: LaunchMode.externalApplication);
                  } else {
                    // ignore: avoid_print
                    print("Can't launch $reportUrl");
                  }
                },
                icon: Icon(Icons.warning_rounded),
                iconSize: 30,
                color: Colors.black45),
            Padding(
              padding: EdgeInsets.all(5),
            )
          ],
        ),
        body: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: IntrinsicHeight(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _answerBody(),
                          Spacer(),
                          bottomBtns(answerData.isAnonymous),
                        ],
                      ),
                    )));
          },
        ));
  }

  Future<String?> screenshot() async {
    var data = await screenshotController.capture();
    if (data == null) {
      return null;
    }
    final tempDir = await getTemporaryDirectory();
    final assetPath = '${tempDir.path}/temp.png';
    File file = await File(assetPath).create();
    await file.writeAsBytes(data);
    return file.path;
  }

  ScreenshotController screenshotController = ScreenshotController();

  Future<bool> checkInstagramAppInstalled() async {
    const instagramAppUrl = 'instagram://app';
    bool appInstalled = await canLaunchUrl(Uri.parse(instagramAppUrl));

    if (appInstalled) {
      return true;
    } else {
      return false;
    }
  }

  Widget _answerBody() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 20, top: 15.0).r,
          child: Text(
            "답변 확인",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 22.sp,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        Padding(padding: EdgeInsets.all(10).r),
        Screenshot(
            controller: screenshotController,
            child: Container(
                padding: EdgeInsets.only(top: 10, bottom: 10).r,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    Text(
                      "${answerData.nickname}이 보낸 메시지",
                      style: TextStyle(
                          fontSize: 18.sp, fontWeight: FontWeight.bold),
                    ),
                    _answerDetailCard(),
                  ],
                ))),
      ],
    );
  }

  Widget _answerDetailCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 20).r,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        color: const Color(0xff9754FB),
        child: Column(
          children: <Widget>[
            Padding(padding: EdgeInsets.all(15.0).w),
            imgUrl.isEmpty
                ? const CircularProgressIndicator()
                : Container(
                    width: 80.w,
                    height: 80.h,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(imgUrl),
                      ),
                    ),
                  ),
            Padding(
              padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 20).r,
              child: Text(
                questionContent,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16.sp,
                  color: Colors.white,
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 25),
              child: answerTxtView(),
            ),
          ],
        ),
      ),
    );
  }

  Widget answerTxtView() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(left: 15.0, right: 15.0, top: 30, bottom: 35),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white, width: 0)),
      child: Text(
        answerData.content,
        style: TextStyle(
          color: Colors.black,
        ),
      ),
    );
  }

  Widget bottomBtns(bool? isAnony) {
    var fromWhoButton = SizedBox(
      width: double.infinity,
      height: 60.h,
      child: ElevatedButton(
          onPressed: () async {
            await Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext context) => HintPage(
                      user: widget.user,
                      answer: widget.answer,
                      hint: widget.hint,
                    )));
          },
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: const Color(0xff9754FB),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
          ),
          child: Text(
            "누가 보냈는지 확인하기",
            style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: Colors.white),
          )),
    );

    var replyBtn = SizedBox(
      width: double.infinity,
      height: 60.h,
      child: ElevatedButton(
          onPressed: () async {
            var path = await screenshot();
            if (path == null) {
              return;
            }
            try {
              SocialShare.shareInstagramStory(
                      appId: '617417756966237',
                      imagePath: path,
                      backgroundTopColor: "#FFFFFF",
                      backgroundBottomColor: "#9754FB",
                      attributionURL: "")
                  .then((data) async {
                if (data == "error") {
                  const String instagramAndroidUrl =
                      'https://play.google.com/store/apps/details?id=com.instagram.android'; // Android Play Store 링크
                  const String instagramIOSUrl =
                      'https://apps.apple.com/app/instagram/id389801252'; // iOS App Store 링크

                  if (Platform.isAndroid) {
                    launchUrl(Uri.parse(instagramAndroidUrl),
                        mode: LaunchMode.externalApplication);
                  } else {
                    launchUrl(Uri.parse(instagramIOSUrl),
                        mode: LaunchMode.externalApplication);
                  }
                }
              });
            } catch (e) {
              print('인스타그램 공유 에러 - E: $e');
            }
          },
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: const Color(0xff333D4B),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
          ),
          child: Text(
            "답장하기",
            style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: Colors.white),
          )),
    );

    return SafeArea(
        child: Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).systemGestureInsets.bottom + 15,
              left: 25,
              right: 25,
            ),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  (isAnony!) ? fromWhoButton : SizedBox(height: 25.h),
                  Padding(padding: EdgeInsets.all(8)),
                  replyBtn
                ])));
  }
}
