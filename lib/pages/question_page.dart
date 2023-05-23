import 'package:cooing_front/model/config/palette.dart';
import 'package:cooing_front/model/data/question_list.dart';
import 'package:cooing_front/model/response/question.dart';
import 'package:cooing_front/model/response/response.dart';
import 'package:cooing_front/model/response/user.dart';
import 'package:cooing_front/widgets/dynamic_link.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:screenshot/screenshot.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart';
import 'package:social_share/social_share.dart';

// ignore: must_be_immutable
class QuestionPage extends StatefulWidget {
  final User user;
  Question? currentQuestion;
  final List<Question?> feed;

  QuestionPage(
      {required this.user,
      required this.currentQuestion,
      required this.feed,
      super.key});

  @override
  State<QuestionPage> createState() => _QuestionPageState();
}

class _QuestionPageState extends State<QuestionPage> {
  bool isQuestionReceived = false;
  bool isQuestionOpen = false;
  bool hasQuestionCloseTimePassed = false;
  late String currentQuestionUrl;
  @override
  void initState() {
    super.initState();

    // Question에 대힌 변수 값 세팅
    setQuestionState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: _buildQuestionPage(),
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

  Widget _buildQuestionPage() {
    return Padding(
        padding: const EdgeInsets.all(25.0),
        child: SafeArea(
            child: Center(
                child: Column(children: [
          Screenshot(
            controller: screenshotController,
            child: purpleBox(),
          ),
          (isQuestionReceived & isQuestionOpen) ? shareCard() : SizedBox(),
        ]))));
  }

  Widget purpleBox() {
    DateTime? nextReceiveTime;
    DateTime? closeTime;

    // 만약, Current Question이 있다면
    if (widget.currentQuestion != null) {
      nextReceiveTime = DateTime.parse(widget.currentQuestion!.receiveTime)
          .add(Duration(hours: 24));
      // 만약, 질문을 오픈했다면
      if (widget.currentQuestion!.isOpen) {
        closeTime = DateTime.parse(widget.currentQuestion!.openTime)
            .add(Duration(hours: 24));
      }
    }

    return SizedBox(
      width: double.infinity,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        color: Palette.mainPurple,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 30,
              ),
              // 프로필 이미지
              widget.user.profileImage.isEmpty
                  ? const CircularProgressIndicator(
                      color: Palette.mainPurple,
                    )
                  : Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage(widget.user.profileImage),
                        ),
                      ),
                    ),
              SizedBox(
                height: 20,
              ),
              // 질문 텍스트
              Text(
                isQuestionReceived
                    ? widget.currentQuestion!.content
                    : '똑똑똑! 오늘의 질문이 도착했어요.',
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.white),
              ),
              SizedBox(
                height: 40,
              ),
              // 버튼
              OutlinedButton(
                onPressed: () async {
                  // 만약, 지금이 오픈한 질문의 Close Time 전이라면
                  if (isQuestionReceived &
                      isQuestionOpen &
                      !hasQuestionCloseTimePassed) {
                    return;
                  }

                  // 버튼 클릭 이벤트
                  onButtonInPurpleBoxClicked();
                },
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  backgroundColor: (isQuestionReceived &
                          isQuestionOpen &
                          !hasQuestionCloseTimePassed)
                      ? Colors.white.withOpacity(0.7)
                      : Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                // 버튼 텍스트
                child: Text(
                  isQuestionReceived
                      ? isQuestionOpen
                          ? '질문 닫기'
                          : (DateTime.now().day >
                                  DateTime.parse(
                                          widget.currentQuestion!.receiveTime)
                                      .day)
                              ? '새로운 질문 받기'
                              : '답변 받기'
                      : '질문 받기',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Palette.mainPurple),
                ),
              ),
              SizedBox(
                height: isQuestionReceived ? 20 : 0,
              ),
              // 안내 코멘트
              Text(
                isQuestionReceived
                    ? isQuestionOpen
                        ? hasQuestionCloseTimePassed
                            ? '새로운 질문이 도착했어요!'
                            : '해당 질문은 ${closeTime!.day}일 ${closeTime.hour}시 ${closeTime.minute}분부터 닫을 수 있습니다.'
                        : (DateTime.now().day >
                                DateTime.parse(
                                        widget.currentQuestion!.receiveTime)
                                    .day)
                            ? '새로운 질문이 도착했어요!'
                            : '다음 질문 도착은 ${nextReceiveTime!.day}일 00시 00분입니다.'
                    : '',
                style: TextStyle(color: Colors.white, fontSize: 10),
              ),
              SizedBox(
                height: 30,
              )
            ],
          ),
        ),
      ),
    );
  }

  setQuestionState() {
    // Current Question에 따른 현재 상태 설정
    // 만약, Current Question이 있다면
    if (widget.currentQuestion != null) {
      isQuestionReceived = true;
      //만약, Current Question이 오픈한 상태라면
      if (widget.currentQuestion!.isOpen) {
        isQuestionOpen = true;
        // 최소 오픈 시간
        DateTime closeTime = DateTime.parse(widget.currentQuestion!.openTime)
            .add(Duration(hours: 24));
        //만약, 지금 시간이 Current Question의 최소 오픈 시간을 지났다면
        if (DateTime.now().isAfter(closeTime)) {
          hasQuestionCloseTimePassed = true;
        } else {
          hasQuestionCloseTimePassed = false;
        }
      } else {
        isQuestionOpen = false;
      }
    } else {
      isQuestionReceived = false;
    }
  }

  onButtonInPurpleBoxClicked() async {
    // 만약, 질문을 받지 않은 상태라면
    if (!isQuestionReceived) {
      // 주요 기능: 질문 받기
      // 새로운 콘텐츠 id 받기
      List<String> questionDataIds = QuestionList.questionList
          .map((item) => item['id'].toString())
          .toList();
      List<String> receivedContentIds = widget.user.questionInfos
          .map((item) => item['contentId'].toString())
          .toList();
      questionDataIds.shuffle();
      String newContentId =
          questionDataIds.firstWhere((id) => !receivedContentIds.contains(id));

      // 새로운 질문 객체 생성
      DateTime now = DateTime.now();
      Question newQuestion = Question(
          id: now.toString(),
          ownerProfileImage: widget.user.profileImage,
          ownerName: widget.user.name,
          owner: widget.user.uid,
          content: QuestionList.questionList[int.parse(newContentId)]
              ['question'],
          contentId: newContentId,
          receiveTime: now.toString(),
          openTime: '',
          url: '',
          schoolCode: widget.user.schoolCode,
          isOpen: false);

      // 1-1. User 반영
      widget.user.questionInfos.add(
          {'contentId': newQuestion.contentId, 'questionId': newQuestion.id});
      widget.user.currentQuestionId = '#${newContentId}_${now.toString()}';
      // 1-2. Question 반영
      widget.currentQuestion = newQuestion;

      // 2-1. Firebase > Users > User 업데이트
      await Response.updateUser(newUser: widget.user);
      // 2-2. Firebase > Contents > Questions > Question 생성
      await Response.createQuestion(newQuestion: newQuestion);
    } else {
      // 만약, 질문을 오픈하지 않은 상태라면
      if (!isQuestionOpen) {
        // 만약, 질문 받은 시간 다음날이라면
        if (DateTime.now().day >
            DateTime.parse(widget.currentQuestion!.receiveTime).day) {
          // 1-1. User 반영
          widget.user.currentQuestionId = '';
          // 2-1. Firebase Users > User 업데이트
          await Response.updateUser(newUser: widget.user);
          widget.currentQuestion = null;
        } else {
          // 주요 기능: 질문 오픈하기
          // 1-1. Question 반영
          widget.currentQuestion!.isOpen = true;
          widget.currentQuestion!.openTime = DateTime.now().toString();
          widget.currentQuestion!.url = await getUrl(widget.currentQuestion!);
          // 1-2. Feed 반영
          widget.feed.insert(0, widget.currentQuestion);

          // 2-1. Firebase Contents > Questions > Question 업데이트
          await Response.updateQuestion(newQuestion: widget.currentQuestion!);
          // 2-2. Firebase Schools > Feed > Question 생성
          await Response.createQuestionInFeed(
              newQuestion: widget.currentQuestion!);
        }
      } else {
        // 주요 기능: 질문 닫기
        // 1-1. User 반영
        widget.user.currentQuestionId = '';
        // 1-2. Question 반영
        widget.currentQuestion!.isOpen = false;
        // 1-3. Feed 반영
        for (var i = 0; i < widget.feed.length; i++) {
          // 만약, 아이템이 있다면
          if (widget.feed[i] != null) {
            // 만약, 아이템의 현재 질문 아이다와 같다면
            if (widget.feed[i]!.id == widget.currentQuestion!.id) {
              widget.feed.removeAt(i);
              break;
            }
          }
        }
        // 2-1. Firebase Users > User 업데이트
        await Response.updateUser(newUser: widget.user);
        // 2-2. Firebase Contents > Questions > Question 업데이트
        await Response.updateQuestion(newQuestion: widget.currentQuestion!);
        // 2-3. Firebase Schools > Feed > Question 삭제
        await Response.deleteQuestionInFeed(
            schoolCode: widget.currentQuestion!.schoolCode,
            questionId: widget.currentQuestion!.id);

        widget.currentQuestion = null;
      }
    }

    setState(() {
      setQuestionState();
    });
  }

  Future<String> getUrl(Question question) async {
    // TODO: 혜은 - url 생성한 걸 가져오는 코드 추가해야됨
    currentQuestionUrl = await getShortLink(question);
    return currentQuestionUrl;
  }

  void _onShareButtonPressed(var path) {
    //공유 버튼 클릭시
    String facebookId = "617417756966237";

    SocialShare.shareInstagramStory(
            appId: facebookId,
            imagePath: path,
            backgroundTopColor: "#ffffff",
            backgroundBottomColor: "#9754FB",
            attributionURL: "www.naver.com")
        .then((data) {
      print("?????? $data");
      if (data == "error") {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Palette.mainPurple,
            content: Text("Instagram이 없습니다!"),
            duration: Duration(seconds: 2),
            action: SnackBarAction(
              //추가로 작업을 넣기. 버튼넣기라 생각하면 편하다.
              label: '설치', //버튼이름
              onPressed: () {
                
              }, //버튼 눌렀을때.
            ),
          ),
        );
      }
    });
  }

  void _onCopyButtonPressed(String url) {
    //복사 버튼 클릭시 클립보드에 복사
    Clipboard.setData(ClipboardData(text: url));

    //하단에 "링크복사완료!" 메시지 스낵바

    // 스낵바 나타남
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Palette.mainPurple,
        content: Text(
          '링크 복사완료!',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        duration: Duration(seconds: 2),
      ),
    );
  }

  Widget shareCard() {
    //링크복사, 인스타그램 아이콘
    AssetImage iconLink = AssetImage('images/icon_copyLink.png');
    AssetImage iconInstagram = AssetImage('images/icon_instagram.png');

    return (Column(children: <Widget>[
      shareBlock(iconLink, "1단계", "링크 복사하기", "복사"),
      shareBlock(iconInstagram, "2단계", "친구들에게 공유", "공유"),
    ]));
  }

  Widget shareBlock(
      AssetImage assetImage, String level, String title, String buttonTxt) {
    return Container(
      padding: const EdgeInsets.only(top: 20),
      child: SizedBox(
        width: double.infinity,
        height: 85.0,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20),
          decoration: BoxDecoration(
              color: Color(0xffF2F3F3),
              borderRadius: BorderRadius.circular(20)),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    SizedBox(
                        width: 25.0,
                        height: 25.0,
                        child: Image(image: assetImage)),
                    Padding(padding: EdgeInsets.only(right: 15.0)),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          level,
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xff333D4B),
                          ),
                        ),
                        Text(
                          title,
                          style: TextStyle(
                              fontSize: 16,
                              color: Color(0xff333D4B),
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    )
                  ],
                )
              ],
            ),
            ElevatedButton(
              onPressed: () async {
                if (buttonTxt == '복사') {
                  _onCopyButtonPressed(widget.currentQuestion!.url);
                } else {
                  //"공유" 버튼 클릭 시, pupleBox 사진 찍음
                  var path = await screenshot();
                  _onShareButtonPressed(path);
                }
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.white,
                shadowColor: Colors.transparent,
                backgroundColor: Color.fromRGBO(151, 84, 251, 1),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)),
              ),
              child: Text(
                buttonTxt,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
