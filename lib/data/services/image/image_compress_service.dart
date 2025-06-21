import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

class ImageCompressService {
  Future<File> compressImage({
    required File image,
    double maxMB = 0.5,
    double maxWidth = 720,
    double maxHeight = 720,
  }) async {
    // 최대 용량 단위 Bytes로 변환
    final int maxBytes = (maxMB * 1024 * 1024).toInt();

    // 원본 용량 이미지
    final int originalBytes = image.lengthSync();

    // 1. 원본 이미지 크기가 작으면 바로 리턴
    if (originalBytes <= maxBytes) {
      return image;
    }

    // 2. 이미지 크기 분석(비율을 유지하면서 리사이징 하기위해 필요)
    final decodedImage = await decodeImageFromList(image.readAsBytesSync());
    final int originalWidth = decodedImage.width;
    final int originalHeight = decodedImage.height;

    // 3. 비율을 유지한 사이즈 계산 함수 실행
    final Size scaledSize = _calculateScaledSize(
      originalWidth: originalWidth,
      originalHeight: originalHeight,
      maxWidth: maxWidth,
      maxHeight: maxHeight,
    );

    // 4. 초기 quality 계산
    int quality = _calculateInitialQuality(originalBytes: originalBytes, maxBytes: maxBytes);

    // 5. 압축된 이미지를 저장할 경로와 객체 생성
    final String outputPath = image.path.replaceAll(
        // 파일 확장자와 이름을 ${원본 파일 이름}_compressed.jpg로 변경
        RegExp(r'\.(jpg|jpeg|png)$'),
        '_compressed.jpg'
    );

    // 6. 조건에 맞도록 압축 반복 실행
    while (true) {
      final result = await FlutterImageCompress.compressWithFile(
        image.path,
        minWidth: scaledSize.width.toInt(),
        minHeight: scaledSize.height.toInt(),
        quality: quality,
        format: CompressFormat.jpeg,
      );

      if (result == null) {
        throw Exception('압축 실패: 결과가 null입니다.');
      }

      // 조건에 맞으면 파일 리턴
      if (result.length <= maxBytes || quality <= 10) {
        return await File(outputPath).writeAsBytes(result);
      }

      quality -= 10;
    }
  }

  // 비율을 유지한 사이즈 계산
  Size _calculateScaledSize({
    required int originalWidth,
    required int originalHeight,
    required double maxWidth,
    required double maxHeight,
  }) {
    final widthRatio = maxWidth / originalWidth;
    final heightRatio = maxHeight / originalHeight;

    // 더 작은 축소 비율 리턴
    final scale = widthRatio < heightRatio ? widthRatio : heightRatio;

    return Size(
      originalWidth * scale,
      originalHeight * scale,
    );
  }

  int _calculateInitialQuality({
    required int originalBytes,
    required int maxBytes
  }) {
    final ratio = originalBytes / maxBytes;

    if (ratio <= 1.1) return 90;
    if (ratio <= 1.5) return 85;
    if (ratio <= 2.0) return 80;
    if (ratio <= 3.0) return 70;
    if (ratio <= 4.0) return 60;
    return 50;
  }
}