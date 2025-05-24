import 'package:bread_place/data/dto/response/google/place/bakery_dto.dart';
import 'package:bread_place/data/dto/response/google/place/bakery_dto_detail/location.dart';
import 'package:bread_place/data/dto/response/google/place/bakery_dto_detail/plus_code.dart';
import 'package:bread_place/data/dto/response/google/place/bakery_dto_detail/view_port.dart';
import 'package:bread_place/domain/entities/bakery.dart';

// BakeryDto -> Bakery 변환
extension BakeryDtoMapper on BakeryDto {
  Bakery toEntity() {
    return Bakery(
      id: id,
      types: types,
      formattedAddress: formattedAddress ?? '',
      displayName: displayName?.text ?? '',
      languageCode: displayName?.languageCode ?? '',
      formattedPhoneNumber: formattedPhoneNumber ?? '',
      location: location?.toEntity() ?? Location.empty(),
      viewport: viewPort?.toEntity() ?? Viewport.empty(),
      plusCode: plusCode?.toEntity() ?? PlusCode.empty(),
      uri: uri ?? '',
      photos: photos?.first.name ?? "", // 사진 1장의 ID만 추출
    );
  }
}

// LocationDto -> Location 변환
extension LocationDtoMapper on LocationDto {
  Location toEntity() {
    return Location(latitude: latitude ?? 0.0, longitude: longitude ?? 0.0);
  }
}

// ViewportDto -> Viewport 변환 수정
extension ViewportDtoMapper on ViewportDto {
  Viewport toEntity() {
    return Viewport(
      low: low?.toEntity() ?? Location.empty(),
      high: high?.toEntity() ?? Location.empty(),
    );
  }
}

// PlusCodeDto -> PlusCode 변환 수정
extension PlusCodeDtoMapper on PlusCodeDto {
  PlusCode toEntity() {
    return PlusCode(
      globalCode: globalCode ?? '',
      compoundCode: compoundCode ?? '',
    );
  }
}