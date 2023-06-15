import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cooing_front/model/response/answer.dart';
import 'package:cooing_front/model/response/question.dart';

class ResponseOptimization {
  static FirebaseFirestore db = FirebaseFirestore.instance;

  // Feed
  static Future<void> createQuestionUploadRequest(
      {required Question newQuestion}) async {
    String time = getNowString();

    final docRef = db
        .collection('requests')
        .doc('feed_upload_requests')
        .collection(time)
        .doc(newQuestion.id);

    try {
      await docRef.set(newQuestion.toJson());
    } catch (e) {
      print('[createQuestionUploadRequest] Error getting document: $e');
    }
  }

  static Future<void> createQuestionDeleteRequest(
      {required Question newQuestion}) async {

    String time = getNowString();

    final docRef = db
        .collection('requests')
        .doc('feed_delete_requests')
        .collection(time)
        .doc(newQuestion.id);

    try {
      await docRef.set(newQuestion.toJson());
    } catch (e) {
      print('[createQuestionDeleteRequest] Error getting document: $e');
    }
  }

  // message
  static Future<void> createMessageUploadRequest(
      {required Answer newAnswer}) async {

    String time = getNowString();

    final docRef = db
        .collection('requests')
        .doc('message_upload_requests')
        .collection(time)
        .doc(newAnswer.id);

    try {
      await docRef.set(newAnswer.toJson());
    } catch (e) {
      print('[createMessageCreateRequest] Error getting document: $e');
    }
  }

  static String getNowString(){
    DateTime now = DateTime.now();
    String time =
        '${now.year}-${formatXX(now.month.toString())}-${formatXX(now.day.toString())} ${formatXX(now.hour.toString())}:${formatXX(now.minute.toString())}';

    return time;
  }
  
  static String formatXX(String date){
    String result = '';
    if(date.length<2){
      result = '0$date';
    }else{
      result = date;
    }
    
    return result;
  }
}
