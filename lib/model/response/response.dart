// 2023.06.19 MON Midas: ❌
// 코드 효율성 점검: ❌
// 예외처리: ❌
// 중복 서버 송수신 방지: ❌

import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cooing_front/model/response/question.dart';
import 'package:cooing_front/model/response/user.dart';
import 'package:cooing_front/model/response/answer.dart';

class Response {
  static FirebaseFirestore db = FirebaseFirestore.instance;
  static final List<Question> _questions = [];
  static final List<Answer> _answers = [];

  static int _feedContentStringIndex = 1;
  static int _feedCurrentPosition = 0;
  static bool _feedContentStringIsEmpty = false;

  static int _messageContentStringIndex = 1;
  static int _messageCurrentPosition = 0;
  static bool _messageContentStringIsEmpty = false;

  static QuerySnapshot<Map<String, dynamic>>? feedQuerySnapshot;
  static QuerySnapshot<Map<String, dynamic>>? messageQuerySnapshot;

  // user
  // ✅
  static Future<void> createUser({required User newUser}) async {
    final docRef = db.collection("users").doc(newUser.uid);
    try {
      await docRef.set(newUser.toJson());
    } catch (e) {
      print("[createUser] Error getting document: $e");
    }
  }

  // ✅
  static Future<User?> readUser({required String userUid}) async {
    User? user;
    final docRef = db.collection("users").doc(userUid);
    try {
      await docRef.get().then((DocumentSnapshot doc) {
        final data = doc.data() as Map<String, dynamic>;
        user = User.fromJson(data);
      });
    } catch (e) {
      print("[readUser] Error getting document: $e");
    }

    return user;
  }

  // ✅
  static Future<void> updateUser({required User newUser}) async {
    final docRef = db.collection("users").doc(newUser.uid);
    try {
      await docRef.update(newUser.toJson());
    } catch (e) {
      print("[updateUser] Error getting document: $e");
    }
  }

  // ✅
  static Future<void> deleteUser({required String userUid}) async {
    final docRef = db.collection("users").doc(userUid);
    try {
      await docRef.delete();
    } catch (e) {
      print("[deleteUser] Error getting document: $e");
    }
  }

  // Question
  static Future initFeedContentString({required String schoolCode}) async{
    feedQuerySnapshot = await db.collection('feeds').doc(schoolCode).collection('feed_strings')
        .orderBy('time', descending: true).limit(1)
        .get();
  }

  static Future readFeedContentString() async {
    if(!_feedContentStringIsEmpty){
      try{
        // content_string_${index} 의 content 가져오기
        List content = [];

        if(feedQuerySnapshot!=null){
          final docRef = feedQuerySnapshot!.docs.first.reference.collection('content_strings').doc('content_string_$_feedContentStringIndex');

          await docRef.get().then((DocumentSnapshot doc){
            final data = doc.data() as Map<String, dynamic>;
            content = data['content'];
          });

          for (var contentStr in content) {
            final contentList = List<Map<String, dynamic>>.from(jsonDecode(contentStr));

            for (var item in contentList) {
              Question question = Question.fromJson(item);
              _questions.add(question);
            }
          }

          _feedContentStringIndex += 1;
        }
      }catch(e){
        print('[readFeedContentString] Error getting document: $e');
      }
    }else{
      print('더이상 데이터가 존재하지 않습니다');
    }
  }

  static Future<List<Question>> getQuestionsWithLimit(int limit) async{
    List<Question> result = [];

    int endPosition = 0;

    // 만약, 남은 _question 10개 미만이라면
    if(_feedCurrentPosition+limit>_questions.length){
      await readFeedContentString();
    }

    if(_feedCurrentPosition+limit<=_questions.length){
      // 만약, 남은 _question 10개 이상이라면
      endPosition = _feedCurrentPosition+limit;
    }else{
      // 만약, 남은 _question 10개 미만이라면
      endPosition = _questions.length;
    }

    if(_feedCurrentPosition==_questions.length){
      _feedContentStringIsEmpty = true;
      return [];
    }else{
      for(var i =_feedCurrentPosition; i<endPosition;i++){
        result.add(_questions[i]);
      }

      _feedCurrentPosition = endPosition;

      return result;
    }
  }

  static Future initMessageContentString({required String uid}) async{
    messageQuerySnapshot = await db.collection('messages').doc(uid).collection('message_strings')
        .orderBy('time', descending: true).limit(1)
        .get();
  }

  static Future readMessageContentString() async {
    if(!_messageContentStringIsEmpty){
      try{
        // content_string_${index} 의 content 가져오기
        List content = [];

        if(messageQuerySnapshot!=null){
          final docRef = messageQuerySnapshot!.docs.first.reference.collection('content_strings').doc('content_string_$_messageContentStringIndex');

          await docRef.get().then((DocumentSnapshot doc){
            final data = doc.data() as Map<String, dynamic>;
            content = data['content'];
          });

          for (var contentStr in content) {
            final contentList = List<Map<String, dynamic>>.from(jsonDecode(contentStr));

            for (var item in contentList) {
              Answer answer = Answer.fromJson(item);
              _answers.add(answer);
            }
          }

          _messageContentStringIndex += 1;
        }
      }catch(e){
        print('[readMessageContentString] Error getting document: $e');
      }
    }else{
      print('더이상 데이터가 존재하지 않습니다');
    }
  }

  static Future<List<Answer>> getMessageWithLimit(int limit) async{
    List<Answer> result = [];

    int endPosition = 0;

    // 만약, 남은 _answers 10개 미만이라면
    if(_messageCurrentPosition+limit>_answers.length){
      await readMessageContentString();
    }

    if(_messageCurrentPosition+limit<=_answers.length){
      // 만약, 남은 _answers 10개 이상이라면
      endPosition = _messageCurrentPosition+limit;
    }else{
      // 만약, 남은 _answers 10개 미만이라면
      endPosition = _answers.length;
    }

    if(_messageCurrentPosition==_answers.length){
      _messageContentStringIsEmpty = true;
      return [];
    }else{
      for(var i =_messageCurrentPosition; i<endPosition;i++){
        result.add(_answers[i]);
      }

      _messageCurrentPosition = endPosition;

      return result;
    }
  }

  static Future<void> createHint(
      {required Map<String, dynamic> newHint, required ownerId}) async {
    final docRef = db.collection('openStatus').doc(ownerId);

    try {
      await docRef.set(newHint);
    } catch (e) {
      print("[updateAnswer] Error getting document: $e");
    }
  }

  static Future<Map<String, dynamic>> readHint({required String ownerId}) async {
    try {
      Map<String, dynamic> hints = {};

      final docRef = FirebaseFirestore.instance
          .collection('openStatus')
          .doc(ownerId);

      await docRef.get().then((DocumentSnapshot doc){
        final data = doc.data() as Map<String, dynamic>;
        for (var entry in data['is_hint_opends'].entries){
          hints[entry.key] = entry.value;
        }
      });

      return hints;
    } catch (e) {
      print("[readHint] Error getting document: $e");
      return {};
    }
  }

  static Future<void> updateHint(
      {required Map<String, dynamic> newHint, required ownerId}) async {
    final docRef = db.collection('openStatus').doc(ownerId);

    try {
      await docRef.update(newHint);
    } catch (e) {
      print("[updateAnswer] Error getting document: $e");
    }
  }

  static void initializeStaticVariables() {
    _questions.clear();
    _answers.clear();

    _feedContentStringIndex = 1;
    _feedCurrentPosition = 0;
    _feedContentStringIsEmpty = false;

    _messageContentStringIndex = 1;
    _messageCurrentPosition = 0;
    _messageContentStringIsEmpty = false;

    feedQuerySnapshot = null;
    messageQuerySnapshot = null;
  }
}
