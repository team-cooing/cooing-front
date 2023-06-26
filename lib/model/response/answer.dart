class Answer {
  String id; // 마이크로세컨드까지 보낸 시간으로 사용
  String time;
  String owner;
  int ownerGender;
  String content;
  String contentId;
  String questionId;
  String questionOwner;
  String questionOwnerFcmToken;
  bool isAnonymous;
  String nickname;
  List<dynamic> hint;
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
      required this.questionOwnerFcmToken,
      required this.isAnonymous,
      required this.nickname,
      required this.hint,
      required this.isOpenedHint,
      required this.isOpened});

  factory Answer.fromJson(Map<String, dynamic> json) {
    List isOpenedHintData = json['isOpenedHint'];
    for (var i = 0; i < isOpenedHintData.length; i++) {
      if (isOpenedHintData[i] is bool) {
        continue;
      } else {
        if (isOpenedHintData[i] == "true") {
          isOpenedHintData[i] = true;
        } else {
          isOpenedHintData[i] = false;
        }
      }
    }

    return Answer(
      id: json['id'],
      time: json['time'],
      owner: json['owner'],
      ownerGender: json['ownerGender'],
      content: json['content'],
      contentId: json['contentId'],
      questionId: json['questionId'],
      questionOwner: json['questionOwner'],
      questionOwnerFcmToken: json['questionOwnerFcmToken'],
      isAnonymous: json['isAnonymous'] is bool
          ? json['isAnonymous']
          : json['isAnonymous'] == 'true'
              ? true
              : false,
      nickname: json['nickname'],
      hint: json['hint'],
      isOpenedHint: isOpenedHintData,
      isOpened: json['isOpened'] is bool
          ? json['isOpened']
          : json['isOpened'] == 'true'
              ? true
              : false,
    );
  }

  Map<String, dynamic> toJson() {
    List isOpenedHintData = [];
    for(var i in isOpenedHint){
      isOpenedHintData.add(i.toString());
    }

    return {
      "id": id, // 마이크로세컨드까지 보낸 시간으로 사용
      "time": time,
      "owner": owner,
      "ownerGender": ownerGender,
      "content": content,
      "contentId": contentId,
      "questionId": questionId,
      "questionOwner": questionOwner,
      "questionOwnerFcmToken": questionOwnerFcmToken,
      "isAnonymous": isAnonymous.toString(),
      "nickname": nickname,
      "hint": hint,
      "isOpenedHint": isOpenedHintData, //bool List
      "isOpened": isOpened.toString(),
    };
  }
}
