import 'package:bread_place/data/dto/response/firebase/user_dto.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _db;

  FirestoreService(this._db);

  Future<bool> saveUser(UserDto user) async {
    try {
      // 해당 uid 를 가진 사용자가 이미 있는지 확인
      QuerySnapshot existingUsers = await _db
          .collection('users')
          .where('uid', isEqualTo: user.uid)
          .limit(1)
          .get();

      print("💙 ${existingUsers.docs.length}");

      // 이미 저장된 사용자
      if (existingUsers.docs.isNotEmpty) {
        return false;
      }

      // 새로운 사용자 등록
      await _db.collection('users').add(user.toJson());
      return true;
    } catch (e) {
      print("사용자 저장 중 오류: $e");
      return false;
    }
  }
}
