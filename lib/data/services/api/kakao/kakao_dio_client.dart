import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class KakaoDioClient {
  final Dio dio;

  KakaoDioClient(): dio = Dio(
      BaseOptions(
        baseUrl: 'https://dapi.kakao.com',
        headers: {
          'Content-Type': 'application/json;charset=UTF-8',
          'Authorization': 'KakaoAK ${dotenv.env['KAKAO_REST_API_KEY']}',
        },
      ),
    )..interceptors.add(LogInterceptor(
    request: true,
    requestBody: true,
    responseBody: true,
    responseHeader: false,
    error: true,
  ));
}
