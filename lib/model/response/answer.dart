import 'dart:convert';

class Answer {
  String id; // 마이크로세컨드까지 보낸 시간으로 사용
  String time;
  String owner;
  int ownerGender;
  String content;
  String contentId;
  String questionId;
  String questionOwner;
  bool isAnonymous;
  String nickname;
  List<String> hint;
  List isOpenedHint; //bool List
  bool isOpened;

  Answer(
      {required this.id,
      required this.time,
      required this.owner,
      required this.ownerGender,
      required this.content,
      required this.contentId,
      required this.questionId,
      required this.questionOwner,
      required this.isAnonymous,
      required this.nickname,
      required this.hint,
      required this.isOpenedHint,
      required this.isOpened});

  factory Answer.fromJson(Map<String, dynamic> json) {
    return Answer(
      id: json['id'],
      time: json['time'],
      owner: json['owner'],
      ownerGender: json['ownerGender'] == '1' ? 1 : 0,
      content: json['content'],
      contentId: json['contentId'],
      questionId: json['questionId'],
      questionOwner: json['questionOwner'],
      isAnonymous: json['isAnonymous'] == 'true' ? true : false,
      nickname: json['nickname'],
      hint: json['hint'].substring(1, json['hint'].length - 1).split(", "),
      isOpenedHint: json['isOpenedHint']
          .substring(1, json['isOpenedHint'].length - 1)
          .split(", "),
      isOpened: json['isOpened'] == 'true',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id, // 마이크로세컨드까지 보낸 시간으로 사용
      'time': time,
      'owner': owner,
      'ownerGender': ownerGender,
      'content': content,
      'contentId': contentId,
      'questionId': questionId,
      'questionOwner': questionOwner,
      'isAnonymous': isAnonymous,
      'nickname': nickname,
      'hint': hint,
      'isOpenedHint': isOpenedHint, //bool List
      'isOpened': isOpened,
    };
  }
}
