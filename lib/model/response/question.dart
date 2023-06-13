import 'dart:convert';

class Question {
  String id; // 마이크로세컨드까지 보낸 시간으로 사용
  String ownerProfileImage;
  String ownerName;
  String owner;
  String content;
  String contentId;
  String receiveTime;
  String openTime;
  String url;
  String schoolCode;
  bool isOpen; // 열려있냐 닫혀있냐? 0:닫힘 1: 열림
  String fcmToken;

  Question(
      {required this.id,
      required this.ownerProfileImage,
      required this.ownerName,
      required this.owner,
      required this.content,
      required this.contentId,
      required this.receiveTime,
      required this.openTime,
      required this.url,
      required this.schoolCode,
      required this.isOpen,
      required this.fcmToken});

  factory Question.fromJson(Map<String, dynamic> json) {
    print('---');
    print(json['isOpen'] == 'true' ? true : false);
    print(json['isOpen'].runtimeType);
    return Question(
        id: json['id'],
        ownerProfileImage: json['ownerProfileImage'],
        ownerName: json['ownerName'],
        owner: json['owner'],
        content: json['content'],
        contentId: json['contentId'],
        receiveTime: json['receiveTime'], //답변받기 누른시간
        openTime: json['openTime'], //질문받기 누른 시간
        url: json['url'],
        schoolCode: json['schoolCode'],
        isOpen: json['isOpen'] is bool
            ? json['isOpen']
            : json['isOpen'] == 'true'
                ? true
                : false,
        fcmToken: json['fcmToken']);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'ownerProfileImage': ownerProfileImage,
      'ownerName': ownerName,
      'owner': owner,
      'content': content,
      'contentId': contentId,
      'receiveTime': receiveTime,
      'openTime': openTime,
      'url': url,
      'schoolCode': schoolCode,
      'isOpen': isOpen,
      'fcmToken': fcmToken
    };
  }
}
