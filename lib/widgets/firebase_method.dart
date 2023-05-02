// Question 객체를 Firestore 문서로 변환하는 함수

import 'package:cooing_front/model/response/User.dart';
import 'package:cooing_front/model/data/question_list.dart';
import 'package:cooing_front/model/response/Question.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import "dart:math";
import 'package:shared_preferences/shared_preferences.dart';

import '../model/response/answer.dart';

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

Future<void> addQuestionToFeed(String schoolCode, Question question) async {
  final docRef = FirebaseFirestore.instance
      .collection('schools')
      .doc(schoolCode)
      .collection('feed')
      .doc(question.id);
  print("schooldCode : $schoolCode , question.id : ${question.id}");
  final Map<String, dynamic> feedQuestion = {
    'contentId': question.contentId,
    'id': question.contentId,
    'name': question.ownerName,
    'profileImage': question.ownerProfileImage,
    'questionContent': question.content,
    'questionId': question.id,
    'schoolCode': schoolCode

    // include other properties here...
  };

  await docRef.set(feedQuestion);
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

// TODO: 이미 받았던 질문 필터링 물어보기
// TODO: 답변 - availableIds ->  availableId

//이미 받았던 질문 필터링해서 새로운 <질문id,질문string> 리턴
Map<String, dynamic> filterQuestion(List<Map<String, dynamic>> questionInfos) {
  Map<String, dynamic> randomQuestion;
  print("filterQuestion ) questionInfos = $questionInfos");
  if (questionInfos.isEmpty) {
    return QuestionList.questionList[Random().nextInt(QuestionList.questionList.length)];
  } // questionInfos 에 있는 질문 id 를 추출합니다.
  Set<int> receivedIds =
      questionInfos.map((info) => int.parse(info['contentId'])).toSet();
  // questionList 에서 중복되지 않은 질문 id 를 추출합니다.
  List<int> availableIds = QuestionList.questionList
      .map((question) => question['id'])
      .where((id) => !receivedIds.contains(id))
      .cast<int>() // cast to list of int
      .toList();

  int randomId =
      availableIds.cast<int>().toList()[Random().nextInt(availableIds.length)];
  return QuestionList.questionList.firstWhere((question) => question['id'] == randomId);
}

Future<SharedPreferences> AsyncPrefsOperation() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  print(prefs);
  return prefs;
}

Future<Map<String, dynamic>> getAnswersByQuestionIds(
    List<Map<String, dynamic>> questionInfos,
    CollectionReference<Map<String, dynamic>> answerCollection) async {
  Map<String, dynamic> answerMapList = {};
  String currentQuestionId;
  String currentContentId;
  for (int i = 0; i < questionInfos.length; i++) {
    currentQuestionId = questionInfos[i]['questionId'];
    currentContentId = questionInfos[i]['contentId'];

    List<Map<String, dynamic>> currentAnswers =
        await getAnswerDocuments(answerCollection, currentQuestionId);
    currentAnswers.sort((a, b) => b['time'].compareTo(a['time']));

    answerMapList[currentContentId] = currentAnswers;
  }

  print("answerMapList: $answerMapList");

  return answerMapList;
}

Future<List<Map<String, dynamic>>> getAnswerDocuments(
    CollectionReference<Map<String, dynamic>> answerCollection,
    String questionId) async {
  QuerySnapshot querySnapshot =
      await answerCollection.where('questionId', isEqualTo: questionId).get();
  List<Map<String, dynamic>> answerInformList = [];

  for (DocumentSnapshot document in querySnapshot.docs) {
    Answer answer = await getAnsDoc(answerCollection, document.id);
    print(answer);
    Map<String, dynamic> inform = {
      // 'questionId': answer.questionId,
      'isOpened': answer.isOpened,
      'gender': answer.ownerGender,
      'time': answer.time,
      'nickname': answer.nickname
    };

    answerInformList.add(inform);
  }
  print("answerInformList : $answerInformList");
  return answerInformList;
}

Future<Answer> getAnsDoc(
    CollectionReference collectionReference, String id) async {
  DocumentReference docRef = collectionReference.doc(id);
  DocumentSnapshot doc = await docRef.get();
  Answer answer;

  if (doc.exists) {
    // 문서가 존재합니다.
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    // 필요한 작업 수행
    answer = Answer.fromJson(data);
    print("in getAnsDocument() : answer = $answer");
  } else {
    answer = Answer(
      id: '', // 마이크로세컨드까지 보낸 시간으로 사용
      time: '',
      owner: '',
      ownerGender: false,
      content: '',
      questionId: '',
      isAnonymous: false,
      nickname: '',
      hint: [],
      isOpenedHint: [], //bool List
      isOpened: false,
    );

    // 문서가 존재하지 않습니다.
  }

  return answer;
}
