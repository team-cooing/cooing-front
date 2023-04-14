class User {
  String uid;
  String name;
  String profileImage;
  int gender; // 0:남자 1:여자
  String number;
  String age; //int
  String birthday;
  String school;
  String schoolCode;
  String schoolOrg;
  int grade;
  int group;
  int eyes; // 0:무쌍 1:유쌍
  String mbti;
  String hobby;
  List style;
  bool isSubscribe;
  int candyCount;
  List<List> questionInfos;
  List<String> answeredQuestions;
  bool serviceNeedsAgreement;
  bool privacyNeedsAgreement;
  // QuestionId_Info = [[ContentID, QuestionID], ... ];

  User({
    required this.uid,
    required this.name,
    required this.profileImage,
    required this.gender,
    required this.number,
    required this.age,
    required this.birthday,
    required this.school,
    required this.schoolCode,
    required this.schoolOrg,
    required this.grade,
    required this.group,
    required this.eyes,
    required this.mbti,
    required this.hobby,
    required this.style,
    required this.isSubscribe,
    required this.candyCount,
    required this.questionInfos,
    required this.answeredQuestions,
    required this.serviceNeedsAgreement,
    required this.privacyNeedsAgreement,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        uid: json['uid'],
        name: json['name'],
        profileImage: json['profileImage'],
        gender: json['gender'],
        number: json['number'],
        age: json['age'],
        birthday: json['birthday'],
        school: json['school'],
        schoolCode: json['schoolCode'],
        schoolOrg: json['schoolOrg'],
        grade: json['grade'],
        group: json['group'],
        eyes: json['eyes'],
        mbti: json['mbti'],
        hobby: json['hobby'],
        style: List<String>.from(json['style']),
        isSubscribe: json['isSubscribe'],
        candyCount: json['candyCount'],
        questionInfos: json['questionInfos'] != null
            ? List<List<dynamic>>.from(json['questionInfos'])
            : [],
        answeredQuestions: json['answeredQuestions'] != null
            ? List<String>.from(json['answeredQuestions'])
            : [],
        serviceNeedsAgreement: json['serviceNeedsAgreement'],
        privacyNeedsAgreement: json['privacyNeedsAgreement']);
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'name': name,
      'profileImage': profileImage,
      'gender': gender,
      'age': age,
      'number': number,
      'birthday': birthday,
      'school': school,
      'schoolCode': schoolCode,
      'schoolOrg': schoolOrg,
      'grade': grade,
      'group': group,
      'eyes': eyes,
      'mbti': mbti,
      'hobby': hobby,
      'style': style,
      'isSubscribe': isSubscribe,
      'candyCount': candyCount,
      'questionInfos': questionInfos,
      'serviceNeedsAgreement': serviceNeedsAgreement,
      'privacyNeedsAgreement': privacyNeedsAgreement,
    };
  }
}


// class Question {
//   String id; // 마이크로세컨드까지 보낸 시간으로 사용
//   String ownerProfileImage;
//   String ownerName;
//   String owner;
//   String content;
//   String receiveTime;
//   String openTime;
//   String url;
//   bool isValidity; // 열려있냐 닫혀있냐?

//   Question(this.id, this.ownerProfileImage, this.ownerName, this.owner, this.content, this.receiveTime, this.openTime,
//       this.url, this.isValidity);
// }

// class Answer {
//   String id; // 마이크로세컨드까지 보낸 시간으로 사용
//   String time;
//   String owner;
//   int ownerGender;
//   String content;
//   String questionId;
//   bool isAnonymous;
//   String nickname;
//   List hint;
//   List isOpenedHint; //bool List
//   bool isOpened;

//   Answer(
//       this.id,
//       this.time,
//       this.owner,
//       this.ownerGender,
//       this.content,
//       this.questionId,
//       this.isAnonymous,
//       this.nickname,
//       this.hint,
//       this.isOpenedHint,
//       this.isOpened);
// }
