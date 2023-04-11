class User {
  String uid;
  String name;
  String profileImage;
  int gender; // 0:남자 1:여자
  String number;
  String age; //int
  String birthday = '2000-02-24';
  String school;
  String schoolCode;
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
    required this.gender,
    required this.number,
    required this.age,
    required this.school,
    required this.schoolCode,
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
      gender: json['gender'],
      age: json['age'],
      number: json['number'],
      school: json['school'],
      schoolCode: json['schoolCode'],
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
      'gender': gender,
      'age': age,
      'number': number,
      'school': school,
      'schoolCode': schoolCode,
      'grade': grade,
      'group': group,
      'eyes': eyes,
      'mbti': mbti,
      'hobby': hobby,
      'style': style,
    };
  }
}




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
