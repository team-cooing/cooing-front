import 'package:cooing_front/pages/HintPage.dart';
import 'package:cooing_front/model/response/answer.dart';
import 'package:cooing_front/model/response/user.dart';
import 'package:cooing_front/model/data/question_list.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:social_share/social_share.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:async';
import 'dart:io';

class AnswerDetailPage extends StatefulWidget {
  final User user;
  final Answer answer;
  const AnswerDetailPage({required this.user, required this.answer, super.key});

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
          leading: BackButton(color: Color.fromRGBO(51, 61, 75, 1)),
          actions: [
            IconButton(
                onPressed: () async {
                  final reportUrl = Uri.parse('https://pf.kakao.com/_kexoDxj');

                  if (await canLaunchUrl(reportUrl)) {
                    launchUrl(reportUrl);
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

  Widget _answerBody() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 20, top: 20.0),
          child: Text(
            "답변 확인",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 22.0,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        const Padding(padding: EdgeInsets.all(12.0)),
        Screenshot(
            controller: screenshotController,
            child: Container(
                padding: EdgeInsets.only(top: 15, bottom: 5),
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    Text(
                      "${answerData.nickname}이 보낸 메시지",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
      padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        color: const Color(0xff9754FB),
        child: Column(
          children: <Widget>[
            const Padding(padding: EdgeInsets.all(15.0)),
            imgUrl.isEmpty
                ? const CircularProgressIndicator()
                : Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(imgUrl),
                      ),
                    ),
                  ),
            Padding(
              padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 20),
              child: Text(
                questionContent,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
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
      height: 50,
      child: ElevatedButton(
          onPressed: () async {
            await Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext context) => HintScreen(
                      user: widget.user,
                      answer: widget.answer,
                    )));
          },
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: const Color(0xff9754FB),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
          ),
          child: const Text(
            "누가 보냈는지 확인하기",
            style: TextStyle(
                fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
          )),
    );

    var replyBtn = SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
          onPressed: () async {
            var path = await screenshot();
            if (path == null) {
              return;
            }
            SocialShare.shareInstagramStory(
                appId: '617417756966237',
                imagePath: path,
                backgroundTopColor: "#FFFFFF",
                backgroundBottomColor: "#9754FB",
                attributionURL: "");
          },
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: const Color(0xff333D4B),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
          ),
          child: const Text(
            "답장하기",
            style: TextStyle(
                fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
          )),
    );

    return SafeArea(
        child: Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).systemGestureInsets.bottom + 15,
              left: 20,
              right: 20,
            ),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  (isAnony!) ? fromWhoButton : SizedBox(height: 25),
                  Padding(padding: EdgeInsets.all(8)),
                  replyBtn
                ])));
  }
}
