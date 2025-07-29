import 'package:bread_place/data/dto/response/firebase/recommend_bakery_dto.dart';
import 'package:bread_place/domain/entities/recommend_bakery_entity.dart';

extension RecommendBakeryMapper on RecommendBakeryDto {
  RecommendBakeryEntity toEntity(){
    return RecommendBakeryEntity(
        bakeryId: id,
        name: name,
    );
  }
}
