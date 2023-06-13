import 'package:cooing_front/model/config/palette.dart';
import 'package:cooing_front/model/data/question_list.dart';
import 'package:cooing_front/model/response/answer.dart';
import 'package:cooing_front/model/response/response.dart';
import 'package:cooing_front/model/response/user.dart';
import 'package:cooing_front/pages/answer_detail_page.dart';
import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:flutter/material.dart';

class MessagePage extends StatefulWidget {
  final User user;
  final List<Answer?> answers;
  final Map<String, dynamic>? hint;

  const MessagePage(
      {super.key,
      required this.user,
      required this.answers,
      required this.hint});

  @override
  State<MessagePage> createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  late BuildContext pageContext;
  Map<String, List<Answer>> categorizedAnswers = {};

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    pageContext = context;

    // answers questionId에 따라 카테고리화
    categorizedAnswers.clear();
    for (var questionInfo in widget.user.questionInfos) {
      categorizedAnswers[questionInfo['questionId']] = [];
    }
    for (var answer in widget.answers) {
      if (answer != null) {
        categorizedAnswers[answer.questionId]!.add(answer);
      }
    }

    return _buildMessagePage();
  }

  Widget _buildMessagePage() {
    return CustomRefreshIndicator(
      onRefresh: _handleRefresh,
      trigger: IndicatorTrigger.trailingEdge,
      trailingScrollIndicatorVisible: false,
      leadingScrollIndicatorVisible: true,
      child: ListView.builder(
          itemCount: widget.user.questionInfos.length,
          itemBuilder: (BuildContext context, int index) {
            return Padding(
                padding: EdgeInsets.only(
                    bottom:
                        index == widget.user.questionInfos.length - 1 ? 30 : 0),
                child: questionItem(index));
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
                              width: 16,
                              height: 16,
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
                            controller.isLoading ? "답변을 가져오고 있어요" : "당겨요",
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

  Widget questionItem(int questionIndex) {
    String questionId = widget.user.questionInfos.reversed
        .toList()[questionIndex]['questionId'];

    // 만약, 카테고리화된 답변이 없다면
    if (categorizedAnswers[questionId]!.isEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
              padding: const EdgeInsets.only(
                  left: 20, right: 20, top: 30, bottom: 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '#${widget.user.questionInfos.length - questionIndex}번째 질문',
                    textAlign: TextAlign.left,
                    style: TextStyle(fontSize: 14),
                  ),
                  Padding(padding: EdgeInsets.all(3)),
                  Text(
                    '"${QuestionList.questionList.elementAt(int.parse(widget.user.questionInfos.reversed.toList()[questionIndex]['contentId']))['question'] as String}"',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              )),
          SizedBox(
              width: double.infinity,
              child: Container(
                  margin:
                      EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 0),
                  padding: EdgeInsets.symmetric(horizontal: 25, vertical: 30),
                  decoration: BoxDecoration(
                      color: Color(0xffF2F3F3),
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                          bottomRight: Radius.circular(20))),
                  child: Center(
                      child: Text(
                    '이 질문에 대한 답변이 없습니다.',
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xff333D4B),
                    ),
                  ))))
        ],
      );
    } else {
      return ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: categorizedAnswers[questionId]!.length,
          itemBuilder: (BuildContext context, int index) {
            // answers 속 index
            int answerIndex =
                widget.answers.indexOf(categorizedAnswers[questionId]![index]);

            // 만약, 첫번째 아이템이라면
            if (index == 0) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                      padding: const EdgeInsets.only(
                          left: 20, right: 20, top: 30, bottom: 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '#${widget.user.questionInfos.length - questionIndex}번째 질문',
                            textAlign: TextAlign.left,
                            style: TextStyle(fontSize: 14),
                          ),
                          Padding(padding: EdgeInsets.all(3)),
                          Text(
                            '"${QuestionList.questionList.elementAt(int.parse(widget.user.questionInfos.reversed.toList()[questionIndex]['contentId']))['question'] as String}"',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ],
                      )),
                  answerItem(answerIndex)
                ],
              );
            }

            // 만약, Answer 아이템이 null이라면
            if (widget.answers[answerIndex] == null) {
              return SizedBox();
            }

            return answerItem(answerIndex);
          });
    }
  }

  Widget answerItem(int index) {
    return GestureDetector(
        onTap: () async {
          await Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext context) => AnswerDetailPage(
                    user: widget.user,
                    answer: widget.answers[index]!,
                    hint: widget.hint,
                  )));

          if (!widget.answers[index]!.isOpened) {
            // widget.answers[index]!.isOpened = true;
            // await Response.updateAnswer(newAnswer: widget.answers[index]!);
          }

          setState(() {});
        },
        child: Container(
          margin: EdgeInsets.only(
            left: 20.0,
            right: 20.0,
            top: 20,
          ),
          child: SizedBox(
            width: double.infinity,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 25, vertical: 30),
              decoration: BoxDecoration(
                  color: Color(0xffF2F3F3),
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                      bottomRight: Radius.circular(20))),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            Stack(
                              clipBehavior: Clip.none,
                              children: [
                                SizedBox(
                                    width: 25.0,
                                    height: 25.0,
                                    child: widget.answers[index]!.ownerGender ==
                                            0
                                        ? Image(
                                            image: AssetImage(
                                                'images/icon_msg_boy.png'))
                                        : Image(
                                            image: AssetImage(
                                                'images/icon_msg_girl.png'))),
                                Positioned(
                                  bottom: 10,
                                  left: 15,
                                  child: SizedBox(
                                      width: 18.0,
                                      height: 18.0,
                                      child: widget.answers[index]!.isOpened
                                          ? Image(
                                              image: AssetImage(
                                                  'images/icon_msg_opened.png'))
                                          : null),
                                )
                              ],
                            ),
                            Padding(padding: EdgeInsets.only(right: 20.0)),
                            Text(
                              widget.answers[index]!.nickname,
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Color(0xff333D4B),
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              '으로부터',
                              style: TextStyle(
                                fontSize: 16,
                                color: Color(0xff333D4B),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                    Text(getFormattedAnswerTime(widget.answers[index]!))
                  ]),
            ),
          ),
        ));
  }

  String getFormattedAnswerTime(Answer answer) {
    String result = '';
    DateTime now = DateTime.now();
    DateTime answerTime = DateTime.parse(answer.time);

    Duration duration = now.difference(answerTime);

    int minuteDifference = duration.inMinutes;
    int hourDifference = duration.inHours;
    int dayDifference = duration.inDays;
    int monthDifference =
        (now.year - answerTime.year) * 12 + now.month - answerTime.month;
    int yearDifference = now.year - answerTime.year;

    if (minuteDifference < 60) {
      result = '${minuteDifference}m';
    } else if (hourDifference < 24) {
      result = '${hourDifference}h';
    } else if (dayDifference < 30) {
      result = '${dayDifference}d';
    } else if (monthDifference < 12) {
      result = '${monthDifference}mon';
    } else {
      result = '${yearDifference}y';
    }

    return result;
  }

  Future<void> _handleRefresh() async {
    // Firebase Answers > Answers > Answer 5개 추가로 읽기
    List<Answer?> newAnswers =
        await Response.getAnswersWithLimit(1, widget.user.uid);
    widget.answers.addAll(newAnswers);

    if (newAnswers.isEmpty) {
      await Future.delayed(Duration(seconds: 2));
    }

    setState(() {
      if (newAnswers.isEmpty) {
        showSnackBar(pageContext, '받은 답변을 모두 가져왔어요!');
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
