import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cooing_front/model/response/question.dart';
import 'package:cooing_front/model/response/user.dart';
import 'package:cooing_front/model/response/answer.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:provider/provider.dart';

class Response {
  static FirebaseFirestore db = FirebaseFirestore.instance;
  static List<Question> _questions = [];
  static List<Answer> _answers = [];
  static List<dynamic> _hints = [];

  static int _nextQuestionIndex = 0;
  static int _nextFeedContentStringIndex = 0;

  static int _nextMsgIndex = 0;
  static int _nextMsgContentStringIndex = 0;

  // user
  static Future<void> createUser({required User newUser}) async {
    final docRef = db.collection("users").doc(newUser.uid);
    try {
      await docRef.set(newUser.toJson());
    } catch (e) {
      print("[createUser] Error getting document: $e");
    }
  }

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

  static Future<void> updateUser({required User newUser}) async {
    final docRef = db.collection("users").doc(newUser.uid);
    try {
      await docRef.update(newUser.toJson());
    } catch (e) {
      print("[updateUser] Error getting document: $e");
    }
  }

  static Future<void> deleteUser({required String userUid}) async {
    final docRef = db.collection("users").doc(userUid);
    try {
      await docRef.delete();
    } catch (e) {
      print("[deleteUser] Error getting document: $e");
    }
  }

  // Question

  static Future<Object?> readHint({required String ownerId}) async {
    try {
      Map<String, dynamic>? hints;
      final docRef = await FirebaseFirestore.instance
          .collection('openStatus')
          .doc(ownerId)
          .get();

      if (docRef.exists) {
        hints = {};

        docRef.data()?.entries.toList().forEach((entry) {
          hints![entry.key] = entry.value;
        });

        print(hints);
      }

      return hints;
    } catch (e) {
      print("[readHint] Error getting document: $e");
      return [];
    }
  }



  static Future<bool> readQuestionInFeed({required String schoolCode}) async {
    List<Question> newQuestions = [];

    final feedsSnapshot = await db
        .collection("feeds")
        .doc(schoolCode)
        .collection('feed_strings')
        .limit(1)
        .get();

    if (feedsSnapshot.docs.isNotEmpty) {
      final latestFeedDoc = feedsSnapshot.docs.first;

      final contentSnapshot =
          await latestFeedDoc.reference.collection('content_strings').get();

      if (contentSnapshot.docs.isNotEmpty) {
        final contentDocs = contentSnapshot.docs;
        print('contentDocs.length');
        print(contentDocs.length);
        // contentDocs.length
        if (_nextFeedContentStringIndex < contentDocs.length) {
          final latestContentDoc = contentDocs[_nextFeedContentStringIndex];
          final contentData = latestContentDoc.data()['content'];

          for (var data in contentData) {
            final waht = List<Map<String, dynamic>>.from(jsonDecode(data));

            for (var item in waht) {
              Question question = Question.fromJson(item);
              _questions.add(question);
            }
          }

          _nextFeedContentStringIndex += 1;
          return true; // 다음 content_string이 존재함
        } else {
          print('No more content_strings to fetch');
        }
      } else {
        print('content_strings collection is empty');
      }
    } else {
      print('feed_strings collection is empty');
    }

    return false; // 다음 content_string이 존재하지 않음
  }

  static Future<List<Question>> getQuestionsWithLimit(
      int limit, schoolCode) async {
    final startIndex = _nextQuestionIndex;
    final endIndex = startIndex + limit;

    if (startIndex >= _questions.length) {
      final a = await Response.readQuestionInFeed(schoolCode: schoolCode);
      if (!a) {
        return [];
      }
    }

    _nextQuestionIndex = endIndex;

    return _questions.sublist(startIndex, endIndex);
  }

  // static Future<List<Question?>> readQuestionsInFeedWithLimit(
  //     {required String schoolCode, required int limit}) async {
  //   List<Question?> questions = [];
  //   try {
  //     final middleQuery = db
  //         .collection('schools')
  //         .doc(schoolCode)
  //         .collection('feed')
  //         .orderBy('id', descending: true);
  //     final finalQuery = lastQuestionId.isNotEmpty
  //         ? middleQuery.startAfter([lastQuestionId]).limit(limit)
  //         : middleQuery.limit(limit);
  //     await finalQuery.get().then((documentSnapshots) {
  //       lastQuestionId = documentSnapshots.docs.last.data()['id'] as String;

  //       for (var i in documentSnapshots.docs) {
  //         print('i.data');
  //         print(i.data().runtimeType);
  //         questions.add(Question.fromJson(i.data()));
  //       }
  //       // print(questions);
  //     });
  //   } catch (e) {
  //     print("[readQuestionsInFeedWithLimit] Error getting document: $e");
  //   }

  //   return questions;
  // }



  static Future<bool> readAnswerInMessage({required String userId}) async {
    // List<Answer?> _answers = [];

    Answer? answer;
    final msgsSnapshot = await db
        .collection("messages")
        .doc(userId)
        .collection('message_strings')
        .limit(1)
        .get();

    if (msgsSnapshot.docs.isNotEmpty) {
      final latestMsgDoc = msgsSnapshot.docs.first;

      final contentSnapshot =
          await latestMsgDoc.reference.collection("content_strings").get();

      if (contentSnapshot.docs.isNotEmpty) {
        final contentDocs = contentSnapshot.docs;

        if (_nextMsgContentStringIndex < contentDocs.length) {
          final latestContentDoc = contentDocs[_nextMsgContentStringIndex];
          final contentData = latestContentDoc.data()['content'];

          for (var data in contentData) {
            final waht = List<Map<String, dynamic>>.from(jsonDecode(data));

            for (var item in waht) {
              Answer answer = Answer.fromJson(item);
              _answers.add(answer);
            }
          }
          _nextMsgContentStringIndex += 1;
          return true;
        } else {
          print('No more msg content_strings to fetch');
        }
      } else {
        print('msg content_strings collection is empty');
      }
    } else {
      print('msg_strings collection is empty');
    }

    return false;
  }

  static Future<List<Answer>> getAnswersWithLimit(int limit, userId) async {
    final startIndex = _nextMsgIndex;
    final endIndex = startIndex + limit;

    if (startIndex >= _answers.length) {
      final a = await Response.readAnswerInMessage(userId: userId);
      if (!a) {
        return [];
      }
    }

    _nextMsgIndex = endIndex;
    return _answers.sublist(startIndex, endIndex);
  }

  // static Future<List<Answer?>> readAnswersWithLimit(
  //     {required String userId, required int limit}) async {
  //   List<Answer?> answers = [];

  //   try {
  //     final middleQuery = db
  //         .collection('answers')
  //         .doc(userId)
  //         .collection('answers')
  //         .orderBy('time', descending: true);
  //     final finalQuery = lastAnswerId.isNotEmpty
  //         ? middleQuery.startAfter([lastAnswerId]).limit(limit)
  //         : middleQuery.limit(limit);
  //     await finalQuery.get().then((documentSnapshots) {
  //       lastAnswerId = documentSnapshots.docs.last.data()['time'] as String;

  //       for (var i in documentSnapshots.docs) {
  //         answers.add(Answer.fromJson(i.data()));
  //         print(i.data());
  //       }
  //     });
  //   } catch (e) {
  //     print("[readAnswersWithLimit] Error getting document: $e");
  //   }

  //   return answers;
  // }


  static Future<void> updateHint(
      {required Map<String, dynamic> newHint, required ownerId}) async {
    final docRef = db.collection('openStatus').doc(ownerId);

    try {
      await docRef.set(newHint);
    } catch (e) {
      print("[updateAnswer] Error getting document: $e");
    }
  }

  // static Future<void> updateAnswer({required Answer newAnswer}) async {
  //   final docRef = db
  //       .collection("answers")
  //       .doc(newAnswer.questionOwner)
  //       .collection('answers')
  //       .doc(newAnswer.id);
  //   try {
  //     await docRef.update(newAnswer.toJson());
  //   } catch (e) {
  //     print("[updateAnswer] Error getting document: $e");
  //   }
  // }

}
