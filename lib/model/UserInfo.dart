class UserInfo {
  String name;
  String profileImage;
  late int gender;
  String number;
  String age;
  String birthday = '2000-02-24';
  String school;
  int grade;
  int group;
  int eyes;
  String mbti;
  String hobby;
  List style;

  UserInfo(
      {required this.name,
      required this.profileImage,
      required this.number,
      required this.age,
      required this.school,
      required this.grade,
      required this.group,
      required this.eyes,
      required this.mbti,
      required this.hobby,
      required this.style});
}
