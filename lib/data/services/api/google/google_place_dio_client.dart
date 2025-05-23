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
            'X-Goog-FieldMask':
                'places.displayName,places.formattedAddress,places.location,places.viewport,places.id,places.plusCode,places.googleMapsUri,places.types,places.photos,places.nationalPhoneNumber',
          },
        ),
      );
}
