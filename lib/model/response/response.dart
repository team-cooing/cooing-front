import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cooing_front/model/response/User.dart';

class Response{
  static FirebaseFirestore db = FirebaseFirestore.instance;

  // user
  static Future<void> createUser(User newUser) async {
    final docRef = db.collection("users").doc(newUser.uid);
    try{
      await docRef.set(newUser.toJson());
    }catch(e){
      print("Error getting document: $e");
    }
  }
  static Future<User?> readUser(String userUid) async{
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
  static Future<void> updateUser(User newUser) async{
    final docRef = db.collection("users").doc(newUser.uid);
    try{
      await docRef.update(newUser.toJson());
    }catch(e){
      print("Error getting document: $e");
    }
  }
  static Future<void> deleteUser(String userUid) async{
    final docRef = db.collection("users").doc(userUid);
    try{
      await docRef.delete();
    }catch(e){
      print("Error getting document: $e");
    }
  }

  //
}