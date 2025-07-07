import 'package:bread_place/data/dto/response/firebase/liked_bakery_dto.dart';
import 'package:bread_place/domain/entities/bakery.dart';
import 'package:bread_place/domain/entities/liked_bakery_entity.dart';


// Dto → Entity 변환
extension LikedBakeryDtoMapper on LikedBakeryDto {
  LikedBakeryEntity toEntity({Bakery? bakery}) {
    return LikedBakeryEntity(
      isNotificationAllowed: isNotificationAllowed,
      updatedAt: updatedAt,
      bakery: Bakery(
          id: bakeryId,
          displayName: displayName,
          languageCode: 'ko',
          formattedAddress: address ?? '',
          formattedPhoneNumber: '',
          location: Location(
              latitude: double.tryParse(locationLat ?? '') ?? 0.0,
              longitude: double.tryParse(locationLong ?? '') ?? 0.0,
          ),
          viewport: Viewport.empty(),
          plusCode: PlusCode.empty(),
          types: [],
          googleMapsUri: '',
          photoUri: '',
          photoId: ''
      ),
    );
  }
}

// Entity → Dto 변환
extension LikedBakeryEntityMapper on LikedBakeryEntity {
  LikedBakeryDto toDto() {
    return LikedBakeryDto(
      address: bakery?.formattedAddress ?? '',
      locationLat: bakery?.location.latitude.toString() ?? '',
      locationLong: bakery?.location.longitude.toString() ?? '',
      bakeryId: bakery?.id ?? '',
      isNotificationAllowed: isNotificationAllowed,
      updatedAt: updatedAt,
      displayName: bakery?.displayName ?? '',
    );
  }
}