import 'package:bread_place/data/dto/response/firebase/user_dto.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _db;

  FirestoreService(this._db);

  // 저장되지 않은 사용자라면 신규 저장
  Future<bool> saveUserId(UserDto user) async {
    try {
      bool exist = await isExistingUser(user.uid);

      // 이미 저장된 사용자
      if (exist) {
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

  // 해당 uid 를 가진 사용자가 있는지 확인
  Future<bool> isExistingUser(String uid) async {
    try {
      QuerySnapshot existingUsers =
          await _db
              .collection('users')
              .where('uid', isEqualTo: uid)
              .limit(1)
              .get();

      return existingUsers.docs.isNotEmpty ? true : false;
    } catch (e) {
      print("파이어베이스에 등록되지 않은 uid 입니다.. $e");
      return false;
    }
  }
}
