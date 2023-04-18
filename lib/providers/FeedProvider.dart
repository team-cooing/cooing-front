import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SchoolFeedProvider extends ChangeNotifier {
  late FirebaseFirestore _firestore; // FirebaseFirestore 인스턴스를 저장하는 변수
  QuerySnapshot? _feedSnapshot; // 쿼리 결과를 저장하는 변수, null이 허용되도록 선언

  Future<void> getFeedElements(
      {required int limit, required DocumentSnapshot? startAfter}) async {
    _firestore = FirebaseFirestore.instance; // FirebaseFirestore 인스턴스 생성
    final feedRef = _firestore.collection('feed').orderBy('timestamp',
        descending:
            true); // 'feed' 컬렉션에서 'timestamp' 필드를 기준으로 내림차순 정렬된 Query 객체 생성
    Query query = feedRef.limit(10); // limit 개수만큼 쿼리 결과를 가져오는 Query 객체 생성
    if (startAfter != null) {
      query = query.startAfterDocument(
          startAfter); // startAfter 값이 있으면 해당 DocumentSnapshot 이후의 결과만 가져오는 Query 객체로 변경
    }
    _feedSnapshot =
        await query.get(); // Query 객체를 실행하고 결과를 _feedSnapshot 변수에 저장
    notifyListeners(); // 변경 내용을 리스너에 알림
  }

  List<Map<String, dynamic>> get feedElements {
    return _feedSnapshot
            ?.docs // _feedSnapshot이 null일 경우 빈 리스트를 반환하고, 아닐 경우 QuerySnapshot에서 DocumentSnapshot 리스트를 추출
            .map((doc) => (doc.data() as Map<String, dynamic>)
              ..addAll({
                'id': doc.id
              })) // DocumentSnapshot에서 Map 형식으로 데이터 추출하고 'id' 필드 추가
            .toList() ??
        []; // 리스트로 반환하되, null인 경우 빈 리스트를 반환
  }
}
