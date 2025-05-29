import 'package:bread_place/data/services/api/google/google_place_endpoint.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class GooglePlaceDioClient {
  final Dio dio;

  GooglePlaceDioClient()
    : dio = Dio(
        BaseOptions(
          baseUrl: 'https://places.googleapis.com/',
          connectTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 10),
          responseType: ResponseType.json,
          headers: {
            'Content-Type': 'application/json',
            'X-Goog-Api-Key': dotenv.env['GOOGLE_CLOUD_KEY'],
            'Accept-Language': 'ko',
          },
        ),
      ) {
    dio.interceptors.addAll({
      InterceptorsWrapper(
        onRequest: (options, handler) {
          // Endpoint 에 따라 필요한 Header 추가
          if(options.path == GooglePlaceEndpoint.searchText) {
            options.headers['X-Goog-FieldMask'] = 'places.displayName,places.formattedAddress,places.location,places.viewport,places.id,places.plusCode,places.googleMapsUri,places.types,places.photos,places.nationalPhoneNumber';
          }

          handler.next(options);
        }
      ),
      LogInterceptor(
        responseBody: true
      )
    });
  }
}
