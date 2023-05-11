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
  static String lastQuestionId = '';
  static Future<void> createQuestionInFeed({required Question newQuestion}) async {
    final docRef = db.collection("schools").doc(newQuestion.schoolCode).collection('feed').doc(newQuestion.id);
    try{
      await docRef.set(newQuestion.toJson());
    }catch(e){
      print("Error getting document: $e");
    }
  }
  static Future<Question?> readQuestionInFeed({required String schoolCode, required String questionId}) async{
    Question? question;
    final docRef = db.collection("schools").doc(schoolCode).collection('feed').doc(questionId);
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
    try{
      final middleQuery = db.collection('schools').doc(schoolCode).collection('feed').orderBy('id', descending: true);
      final finalQuery = lastQuestionId.isNotEmpty? middleQuery.startAfter([lastQuestionId]).limit(limit) : middleQuery.limit(limit);
      await finalQuery.get().then((documentSnapshots){

        lastQuestionId = documentSnapshots.docs.last.data()['id'] as String;

        for(var i in documentSnapshots.docs){
          questions.add(Question.fromJson(i.data()));
        }
      });
    }

    catch(e){
      print("Error getting document: $e");
    }

    return questions;
  }
  static Future<void> updateQuestionInFeed({required Question newQuestion}) async{
    final docRef = db.collection("schools").doc(newQuestion.schoolCode).collection('feed').doc(newQuestion.id);
    try{
      await docRef.update(newQuestion.toJson());
    }catch(e){
      print("Error getting document: $e");
    }
  }
  static Future<void> deleteQuestionInFeed({required String schoolCode, required String questionId}) async{
    final docRef = db.collection("schools").doc(schoolCode).collection('feed').doc(questionId);
    try{
      await docRef.delete();
    }catch(e){
      print("Error getting document: $e");
    }
  }

  // Answer
  static String lastAnswerId = '';
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
  static Future<List<Answer?>> readAnswersWithLimit({required String userId, required int limit}) async{
    List<Answer?> answers = [];

    try{
      final middleQuery = db.collection('answers').doc(userId).collection('answers').orderBy('time', descending: false);
      final finalQuery = lastAnswerId.isNotEmpty? middleQuery.startAfter([lastAnswerId]).limit(limit) : middleQuery.limit(limit);
      await finalQuery.get().then((documentSnapshots){

        lastAnswerId = documentSnapshots.docs.last.data()['time'] as String;

        for(var i in documentSnapshots.docs){
          answers.add(Answer.fromJson(i.data()));
        }
      });
    }

    catch(e){
      print("Error getting document: $e");
    }

    return answers;
  }
  static Future<Answer?> readLastAnswer({required String userId}) async{
    Answer? answer;

    try{
      final middleQuery = db.collection('answers').doc(userId).collection('answers').orderBy('time', descending: false);
      final finalQuery = middleQuery.limit(1);
      await finalQuery.get().then((documentSnapshots){
        answer = Answer.fromJson(documentSnapshots.docs[0].data());
      });
    }

    catch(e){
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