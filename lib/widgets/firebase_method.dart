// Question 객체를 Firestore 문서로 변환하는 함수
import 'package:cooing_front/model/question_list.dart';
import 'package:cooing_front/model/Question.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import "dart:math";

Map<String, dynamic> _questionToFirestoreDocument(Question question) {
  return question.toJson();
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
        if (questionList.any((question) => question["id"] == info[0])) info,
    ];
    randomQuestion =
        filteredQuestions[Random().nextInt(filteredQuestions.length)];
  }
  return randomQuestion;
}
