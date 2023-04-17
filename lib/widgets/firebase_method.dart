// Question 객체를 Firestore 문서로 변환하는 함수
import 'package:cooing_front/model/User.dart';
import 'package:cooing_front/model/question_list.dart';
import 'package:cooing_front/model/Question.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import "dart:math";
import 'package:shared_preferences/shared_preferences.dart';

Map<String, dynamic> _questionToFirestoreDocument(Question question) {
  return question.toJson();
}

Question initQuestion(Question question) {
  question.content = '';
  question.contentId = 0;
  question.receiveTime = '';
  question.openTime = '';
  question.url = '';
  question.isValidity = false;

  return question;
}

Future<void> addQuestionToFeed(
    String schoolCode, String questionId, Question data) async {
  final docRef = FirebaseFirestore.instance
      .collection('schools')
      .doc(schoolCode)
      .collection('feed')
      .doc(questionId);

  await docRef.set(_questionToFirestoreDocument(data));
}

Future<void> deleteQuestionFromFeed(
    String schoolCode, String questionId) async {
  final docRef = FirebaseFirestore.instance
      .collection('schools')
      .doc(schoolCode)
      .collection('feed')
      .doc(questionId);

  await docRef.delete();
}

Future<User> getUserDocument(DocumentReference docRef, String id) async {
  DocumentSnapshot doc = await docRef.get();
  User user;
  if (doc.exists) {
    // 문서가 존재합니다.
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    // 필요한 작업 수행
    user = User.fromJson(data);
  } else {
    user = User(
        birthday: '',
        uid: '',
        name: '',
        profileImage: '',
        gender: 0,
        number: '',
        age: '',
        school: '',
        schoolCode: '',
        schoolOrg: '',
        grade: 0,
        group: 0,
        eyes: 0,
        mbti: '',
        hobby: '',
        style: [],
        isSubscribe: false,
        candyCount: 0,
        questionInfos: [],
        answeredQuestions: [],
        serviceNeedsAgreement: false,
        privacyNeedsAgreement: false);
  }

  return user;
}

Future<Question> getDocument(DocumentReference docRef, String id) async {
  DocumentSnapshot doc = await docRef.get();
  Question question;
  if (doc.exists) {
    // 문서가 존재합니다.
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    // 필요한 작업 수행
    question = Question.fromJson(data);
  } else {
    question = Question(
      id: '',
      ownerProfileImage: '',
      ownerName: '',
      owner: '',
      content: '',
      contentId: 0,
      receiveTime: '',
      openTime: '',
      url: '',
      isValidity: false,
    );
    // 문서가 존재하지 않습니다.
  }

  return question;
}

// Firestore에 새로운 Question 객체를 추가하는 함수
Future<void> addNewQuestion(
    DocumentReference? documentRef, Question question) async {
  final document = _questionToFirestoreDocument(question);
  await documentRef?.set(document);
}

//FireStore에 이미 있는 question 값 업데이트
Future<void> updateQuestion(
    String section, dynamic updateStr, DocumentReference? docReference) async {
  Map<String, dynamic> data = {section: updateStr};
  await docReference?.update(data);
}

//이미 받았던 질문 필터링해서 새로운 <질문id,질문string> 리턴
Map<String, dynamic> filterQuestion(List questionInfos) {
  Map<String, dynamic> randomQuestion;
  if (questionInfos.isEmpty) {
    randomQuestion = questionList[Random().nextInt(questionList.length)];
  } else {
    List<Map<String, dynamic>> filteredQuestions = [
      for (var info in questionInfos)
        if (questionList
            .any((question) => question["id"].toString() == info[0]))
          info,
    ];
    randomQuestion =
        filteredQuestions[Random().nextInt(filteredQuestions.length)];
  }
  return randomQuestion;
}

Future<SharedPreferences> AsyncPrefsOperation() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  print(prefs);
  return prefs;
}
