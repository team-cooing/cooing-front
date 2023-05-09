import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cooing_front/model/response/question.dart';
import 'package:cooing_front/model/response/user.dart';
import 'package:cooing_front/model/response/answer.dart';

class Response{
  static FirebaseFirestore db = FirebaseFirestore.instance;

  // user
  static Future<void> createUser({required User newUser}) async {
    final docRef = db.collection("users").doc(newUser.uid);
    try{
      await docRef.set(newUser.toJson());
    }catch(e){
      print("Error getting document: $e");
    }
  }
  static Future<User?> readUser({required String userUid}) async{
    User? user;
    final docRef = db.collection("users").doc(userUid);
    try{
      await docRef.get().then(
              (DocumentSnapshot doc) {
            final data = doc.data() as Map<String, dynamic>;
            user = User.fromJson(data);
          });
    }catch(e){
      print("Error getting document: $e");
    }

    return user;
  }
  static Future<void> updateUser({required User newUser}) async{
    final docRef = db.collection("users").doc(newUser.uid);
    try{
      await docRef.update(newUser.toJson());
    }catch(e){
      print("Error getting document: $e");
    }
  }
  static Future<void> deleteUser({required String userUid}) async{
    final docRef = db.collection("users").doc(userUid);
    try{
      await docRef.delete();
    }catch(e){
      print("Error getting document: $e");
    }
  }

  // Question
  static Future<void> createQuestion({required Question newQuestion}) async {
    final docRef = db.collection("contents").doc(newQuestion.contentId).collection('questions').doc(newQuestion.id);
    try{
      await docRef.set(newQuestion.toJson());
    }catch(e){
      print("Error getting document: $e");
    }
  }
  static Future<Question?> readQuestion({required String contentId, required String questionId}) async{
    Question? question;
    final docRef = db.collection("contents").doc(contentId).collection('questions').doc(questionId);
    try{
      await docRef.get().then(
              (DocumentSnapshot doc) {
            final data = doc.data() as Map<String, dynamic>;
            question = Question.fromJson(data);
          });
    }catch(e){
      print("Error getting document: $e");
    }

    return question;
  }
  static Future<void> updateQuestion({required Question newQuestion}) async{
    final docRef = db.collection("contents").doc(newQuestion.contentId).collection('questions').doc(newQuestion.id);
    try{
      await docRef.update(newQuestion.toJson());
    }catch(e){
      print("Error getting document: $e");
    }
  }
  static Future<void> deleteQuestion({required String contentId, required String questionId}) async{
    final docRef = db.collection("contents").doc(contentId).collection('questions').doc(questionId);
    try{
      await docRef.delete();
    }catch(e){
      print("Error getting document: $e");
    }
  }

  // Feed Question
  static Future<void> createQuestionInFeed({required Question newQuestion}) async {
    final docRef = db.collection("schools").doc(newQuestion.schoolCode).collection('feeds').doc(newQuestion.id);
    try{
      await docRef.set(newQuestion.toJson());
    }catch(e){
      print("Error getting document: $e");
    }
  }
  static Future<Question?> readQuestionInFeed({required String schoolCode, required String questionId}) async{
    Question? question;
    final docRef = db.collection("schools").doc(schoolCode).collection('feeds').doc(questionId);
    try{
      await docRef.get().then(
              (DocumentSnapshot doc) {
            final data = doc.data() as Map<String, dynamic>;
            question = Question.fromJson(data);
          });
    }catch(e){
      print("Error getting document: $e");
    }

    return question;
  }
  static Future<List<Question?>> readQuestionsInFeedWithLimit({required String schoolCode, required int limit}) async{
    List<Question?> questions = [];
    final docRef = db.collection("schools").doc(schoolCode).collection('feeds').orderBy('id', descending: true).limit(limit);
    try{
      QuerySnapshot snapshot = await docRef.get();
      for(var i in snapshot.docs){
        final data = i.data() as Map<String, dynamic>;
        questions.add(Question.fromJson(data));
      }
    }catch(e){
      print("Error getting document: $e");
    }

    return questions;
  }
  static Future<void> updateQuestionInFeed({required Question newQuestion}) async{
    final docRef = db.collection("schools").doc(newQuestion.schoolCode).collection('feeds').doc(newQuestion.id);
    try{
      await docRef.update(newQuestion.toJson());
    }catch(e){
      print("Error getting document: $e");
    }
  }
  static Future<void> deleteQuestionInFeed({required String schoolCode, required String questionId}) async{
    final docRef = db.collection("schools").doc(schoolCode).collection('feeds').doc(questionId);
    try{
      await docRef.delete();
    }catch(e){
      print("Error getting document: $e");
    }
  }

  // Answer
  static Future<void> createAnswer({required Answer newAnswer}) async {
    final docRef = db.collection("answers").doc(newAnswer.questionOwner).collection('answers').doc(newAnswer.id);
    try{
      await docRef.set(newAnswer.toJson());
    }catch(e){
      print("Error getting document: $e");
    }
  }
  static Future<Answer?> readAnswer({required String userId, required String answerId}) async{
    Answer? answer;
    final docRef = db.collection("answers").doc(userId).collection('answers').doc(answerId);
    try{
      await docRef.get().then(
              (DocumentSnapshot doc) {
            final data = doc.data() as Map<String, dynamic>;
            answer = Answer.fromJson(data);
          });
    }catch(e){
      print("Error getting document: $e");
    }

    return answer;
  }
  static Future<void> updateAnswer({required Answer newAnswer}) async{
    final docRef = db.collection("answers").doc(newAnswer.questionOwner).collection('answers').doc(newAnswer.id);
    try{
      await docRef.update(newAnswer.toJson());
    }catch(e){
      print("Error getting document: $e");
    }
  }
  static Future<void> deleteAnswer({required String userId, required String answerId}) async{
    final docRef = db.collection("answers").doc(userId).collection('answers').doc(answerId);
    try{
      await docRef.delete();
    }catch(e){
      print("Error getting document: $e");
    }
  }
}