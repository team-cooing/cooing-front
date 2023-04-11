class Question {
  String id; // 마이크로세컨드까지 보낸 시간으로 사용
  String ownerProfileImage;
  String ownerName;
  String owner;
  String content;
  String receiveTime;
  String openTime;
  String url;
  bool isValidity; // 열려있냐 닫혀있냐? 0:닫힘 1: 열림

  Question({required this.id, required this.ownerProfileImage, required this.ownerName, required this.owner,
      required this.content, required this.receiveTime, required this.openTime, required this.url, required this.isValidity});



}
