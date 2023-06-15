import 'package:cooing_front/model/response/answer.dart';
import 'package:cooing_front/model/response/question.dart';
import 'package:cooing_front/model/response/response.dart';
import 'package:cooing_front/model/response/user.dart';

sendAnswer(User toUser, User fromUser, Question question) async {
  int currentNum = 2;

  DateTime now = DateTime.now();

  Answer newAnswer = Answer(
      id: '#00000${currentNum}_${now.toString()}',
      time: now.toString(),
      owner: fromUser.uid,
      ownerGender: 1,
      content: '예시입니다',
      contentId: '1',
      questionId: question.id,
      questionOwner: question.owner,
      isAnonymous: true,
      nickname: '활발한 남학생',
      hint: ['힌트 1', '힌트 2', '힌트 3'],
      isOpenedHint: [false, false, false],
      isOpened: false);

}