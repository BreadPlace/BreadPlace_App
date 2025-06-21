import 'dart:io';

import 'package:bread_place/data/dto/mapper/user_mapper.dart';
import 'package:bread_place/data/services/firebase/firestore_service.dart';
import 'package:bread_place/data/services/image/image_compress_service.dart';
import 'package:bread_place/domain/entities/bakery.dart';
import 'package:bread_place/domain/entities/user_entity.dart';
import 'package:bread_place/domain/repositories/firestore_repository.dart';

class FirestoreRepositoryImpl implements FirestoreRepository {
  final FirestoreService _service;
  final ImageCompressService _imageCompressService;

  FirestoreRepositoryImpl({
    required FirestoreService service,
    required ImageCompressService imageCompressService,
  }) : _service = service,
       _imageCompressService = imageCompressService;

  @override
  Future<bool> saveUser(UserEntity user) async {
    return await _service.saveUserId(user.toDto());
  }

  @override
  Future<UserEntity?> fetchUserDataByUid(String uid) async {
    final userDto = await _service.fetchUserDataByUid(uid);
    if (userDto != null) {
      return userDto.toEntity();
    }
    return null;
  }

  Future<void> uploadBakeryReview(
    String userID,
    String userNickName,
    Bakery bakery,
    int starRate,
    String recommendBread,
    String content,
    File? image,
  ) async {
    File? compressedImage;

    if (image != null) {
      compressedImage = await _imageCompressService.compressImage(image: image);
    }

    await _service.uploadBakeryReview(
      userID,
      userNickName,
      bakery,
      starRate,
      recommendBread,
      content,
      compressedImage,
    );
  }
}
