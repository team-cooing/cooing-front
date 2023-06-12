import 'dart:math';

import 'package:cooing_front/model/config/palette.dart';
import 'package:cooing_front/model/response/question.dart';
import 'package:cooing_front/model/response/response.dart';
import 'package:cooing_front/model/response/user.dart';
import 'package:cooing_front/pages/answer_page.dart';
import 'package:cooing_front/pages/lottery_complete_page.dart';
import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FeedPage extends StatefulWidget {
  final User user;
  final List<Question?> feed;
  final String bonusQuestionId;

  const FeedPage(
      {required this.user,
      required this.feed,
      required this.bonusQuestionId,
      super.key});

  @override
  State<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  late BuildContext pageContext;

  @override
  void initState() {
    super.initState();

    // 만약, 유저 데이터에 recentDailyBonusReceiveDate가 없다면
    if (widget.user.recentDailyBonusReceiveDate.isEmpty) {
      widget.user.recentDailyBonusReceiveDate = '2000-01-01 00:00:00.000000';
    }
    // 만약, 유저 데이터에recentQuestionBonusReceiveDate가 없다면
    if (widget.user.recentQuestionBonusReceiveDate.isEmpty) {
      widget.user.recentQuestionBonusReceiveDate = '2000-01-01 00:00:00.000000';
    }
  }

  @override
  Widget build(BuildContext context) {
    pageContext = context;

    return Scaffold(body: _buildFeedPage());
  }

  Widget _buildFeedPage() {
    return CustomRefreshIndicator(
      onRefresh: _handleRefresh,
      trigger: IndicatorTrigger.trailingEdge,
      trailingScrollIndicatorVisible: false,
      leadingScrollIndicatorVisible: true,
      child: ListView.builder(
          itemCount: widget.feed.length,
          itemBuilder: (BuildContext context, int index) {
            // 만약, Feed 아이템이 null이라면
            if (widget.feed[index] == null) {
              return SizedBox();
            }

            // 만약, index가 0이고, 데일리 보너스를 받지 않았다면
            if (index == 0 &&
                DateTime.now().isAfter(
                    DateTime.parse(widget.user.recentDailyBonusReceiveDate)
                        .add(Duration(hours: 24)))) {
              return Column(
                children: [feedItem(-1), feedItem(index)],
              );
            }

            return feedItem(index);
          }),
      builder: (
        BuildContext context,
        Widget child,
        IndicatorController controller,
      ) {
        return AnimatedBuilder(
            animation: controller,
            builder: (context, _) {
              final dy =
                  controller.value.clamp(0.0, 1.25) * -(150 - (150 * 0.25));
              return Stack(
                children: [
                  Transform.translate(
                    offset: Offset(0.0, dy),
                    child: child,
                  ),
                  Positioned(
                    bottom: -150,
                    left: 0,
                    right: 0,
                    height: 150,
                    child: Container(
                      transform: Matrix4.translationValues(0.0, dy, 0.0),
                      padding: const EdgeInsets.only(top: 30.0),
                      constraints: const BoxConstraints.expand(),
                      child: Column(
                        children: [
                          if (controller.isLoading)
                            Container(
                              margin: const EdgeInsets.only(bottom: 8.0),
                              width: 16.w,
                              height: 16.h,
                              child: const CircularProgressIndicator(
                                color: Palette.mainPurple,
                                strokeWidth: 2,
                              ),
                            )
                          else
                            const Icon(
                              Icons.keyboard_arrow_up,
                              color: Palette.mainPurple,
                            ),
                          Text(
                            controller.isLoading ? "질문을 가져오고 있어요" : "당겨요",
                            style: const TextStyle(
                              color: Palette.mainPurple,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              );
            });
      },
    );
  }

  Widget feedItem(int index) {
    return Card(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
              bottomRight: Radius.circular(20))),
      elevation: 0,
      margin: EdgeInsets.only(
          left: 20,
          right: 20,
          top: (index == 0 &&
                      !DateTime.now().isAfter(DateTime.parse(
                              widget.user.recentDailyBonusReceiveDate)
                          .add(Duration(hours: 24)))) ||
                  index == -1
              ? 30
              : 10,
          bottom: index == widget.feed.length - 1 ? 30 : 10),
      child: SizedBox(
        width: double.infinity,
        child: Container(
          padding: EdgeInsets.all(25.0),
          decoration: BoxDecoration(
              color: Color(0xffF2F3F3),
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                  bottomRight: Radius.circular(20))),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: 42.0.w,
                          height: 42.0.h,
                          child: CircleAvatar(
                            backgroundImage: index == -1
                                ? AssetImage('images/logo_128.png')
                                    as ImageProvider
                                : NetworkImage(
                                    widget.feed[index]!.ownerProfileImage),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(right: 14.0),
                        ),
                        Expanded(
                          child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  index == -1
                                      ? '쿠잉 복권'
                                      : widget.feed[index]!.ownerName,
                                  maxLines: 2,
                                  softWrap: true,
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    color: Color(0xff333D4B),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(3),
                                ),
                                Flexible(
                                  child: Text(
                                    index == -1
                                        ? '오늘도 쿠잉이 캔디 쏜다~!'
                                        : widget.feed[index]!.content,
                                    softWrap: true,
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      color: Color(0xff333D4B),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ]),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              index == -1 ? lotteryButton() : feedButton(widget.feed[index]!),
            ],
          ),
        ),
      ),
    );
  }

  Widget lotteryButton() {
    return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () async {
          int candyNum = Random().nextInt(3) + 1;

          // 복권 페이지로 이동
          await Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext context) => CandyCompletePage(
                    num: candyNum,
                  )));

          // User 반영
          widget.user.recentDailyBonusReceiveDate = DateTime.now().toString();
          widget.user.candyCount += candyNum;

          // Firebase > Users > User 업데이트
          await Response.updateUser(newUser: widget.user);

          setState(() {});
        },
        child: Container(
          width: 75.w,
          alignment: Alignment.center,
          child: ElevatedButton(
              onPressed: null,
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.white,
                shadowColor: Colors.transparent,
                backgroundColor: Color.fromRGBO(151, 84, 251, 1),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)),
              ),
              child: Text('받기',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ))),
        ));
  }

  Widget feedButton(Question question) {
    // 오늘 보너스 받았는지 확인
    bool isBonusReceivedToday = !DateTime.now().isAfter(
        DateTime.parse(widget.user.recentQuestionBonusReceiveDate)
            .add(Duration(hours: 24)));
    bool canReceiveBonus =
        question.id == widget.bonusQuestionId && !isBonusReceivedToday;

    return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () async {
          if (!widget.user.answeredQuestions.contains(question.id)) {
            // 만약, 보너스를 받을 수 있다면
            bool? isCompleted =
                await Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext context) => AnswerPage(
                          user: widget.user,
                          uid: widget.user.uid,
                          question: question,
                          isFromLink: false,
                        )));

            if (isCompleted != null) {
              // 만약, 답변이 완료되었다면
              if (isCompleted) {
                widget.user.answeredQuestions.add(question.id);
                if (canReceiveBonus) {
                  widget.user.recentQuestionBonusReceiveDate =
                      DateTime.now().toString();
                  widget.user.candyCount += 3;
                }

                await Response.updateUser(newUser: widget.user);
                setState(() {});
              }
            }
          }
        },
        child: Container(
          width: 75.w,
          alignment: Alignment.center,
          child: ElevatedButton(
              onPressed: null,
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.white,
                shadowColor: Colors.transparent,
                backgroundColor:
                    widget.user.answeredQuestions.contains(question.id)
                        ? Palette.mainPurple.withOpacity(0.4)
                        : Palette.mainPurple,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)),
              ),
              child: canReceiveBonus
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                          SizedBox(
                              width: 14.w,
                              height: 14.h,
                              child: Image(
                                  image: AssetImage('images/candy1.png'))),
                          SizedBox(
                            width: 6.w,
                          ),
                          Text(
                            '3',
                            style: TextStyle(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          )
                        ])
                  : Text(
                      widget.user.answeredQuestions.contains(question.id)
                          ? '답변완료'
                          : '답변하기',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    )),
        ));
  }

  Future<void> _handleRefresh() async {
    // Firebase Schools > Questions > Question 5개 추가로 읽기
    List<Question?> newQuestions = await Response.readQuestionsInFeedWithLimit(
        schoolCode: widget.user.schoolCode, limit: 5);
    widget.feed.addAll(newQuestions);

    if (newQuestions.isEmpty) {
      await Future.delayed(Duration(seconds: 2));
    }

    setState(() {
      if (newQuestions.isEmpty) {
        showSnackBar(pageContext, '우리 학교 질문을 모두 가져왔어요!');
      }
    });
  }

  void showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Palette.mainPurple,
        content: Text(message),
        duration: Duration(seconds: 2),
      ),
    );
  }
}
