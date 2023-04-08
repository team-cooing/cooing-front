class User {
  String uid;
  String name;
  String profileImage;
  late int gender; // 0:남자 1:여자
  String number;
  String age; //int
  String birthday = '2000-02-24';
  String school;
  late String schoolCode;
  int grade;
  int group;
  int eyes; // 0:무쌍 1:유쌍
  String mbti;
  String hobby;
  List style;
  late bool IsSubscribe;
  late int candyCount;
  late List<List>
      questionInfos; // QuestionId_Info = [[ContentID, QuestionID], ... ]

  User({
    required this.uid,
    required this.name,
    required this.profileImage,
    required this.number,
    required this.age,
    required this.school,
    // required this.schoolCode,
    required this.grade,
    required this.group,
    required this.eyes,
    required this.mbti,
    required this.hobby,
    required this.style,
    // required this.questionInfos
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      uid: json['uid'],
      name: json['name'],
      profileImage: json['profileImage'],
      age: json['age'],
      number: json['number'],
      school: json['school'],
      grade: json['grade'],
      group: json['group'],
      eyes: json['eyes'],
      mbti: json['mbti'],
      hobby: json['hobby'],
      style: List<String>.from(json['style']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'name': name,
      'profileImage': profileImage,
      'age': age,
      'number': number,
      'school': school,
      'grade': grade,
      'group': group,
      'eyes': eyes,
      'mbti': mbti,
      'hobby': hobby,
      'style': style,
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
