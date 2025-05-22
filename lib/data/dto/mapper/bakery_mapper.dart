import 'package:bread_place/data/dto/response/google/place/bakery_dto.dart';
import 'package:bread_place/data/dto/response/google/place/bakery_dto_detail/location.dart';
import 'package:bread_place/data/dto/response/google/place/bakery_dto_detail/plus_code.dart';
import 'package:bread_place/data/dto/response/google/place/bakery_dto_detail/view_port.dart';
import 'package:bread_place/domain/entities/bakery.dart';

// BakeryDto -> Bakery 변환
extension BakeryDtoMapper on BakeryDto {
  Bakery toEntity() {
    return Bakery(
      displayName: displayName.text,
      languageCode: displayName.languageCode,
      formattedAddress: formattedAddress,
      formattedPhoneNumber: formattedPhoneNumber,
      location: location.toEntity(),
      viewport: viewPort.toEntity(),
      id: id,
      plusCode: plusCode.toEntity(),
      uri: uri,
      types: types,
      photos: photos.name,
    );
  }
}

// LocationDto -> Location 변환
extension LocationDtoMapper on LocationDto {
  Location toEntity() {
    return Location(
      latitude: latitude,
      longitude: longitude,
    );
  }
}

// ViewportDto -> Viewport 변환
extension ViewportDtoMapper on ViewportDto {
  Viewport toEntity() {
    return Viewport(
      low: low.toEntity(),
      high: high.toEntity(),
    );
  }
}

// PlusCodeDto -> PlusCode 변환
extension PlusCodeDtoMapper on PlusCodeDto {
  PlusCode toEntity() {
    return PlusCode(
      globalCode: globalCode,
      compoundCode: compoundCode,
    );
  }
}