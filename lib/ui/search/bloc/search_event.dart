import 'package:equatable/equatable.dart';

abstract class SearchEvent extends Equatable {
  const SearchEvent();

  @override
  List<Object?> get props => [];
}

class SearchPlaceByText extends SearchEvent {
  final String keyword;
  const SearchPlaceByText({required this.keyword});

  @override
  List<Object?> get props => [keyword];
}

class SearchPlaceById extends SearchEvent {
  final String placeId;
  const SearchPlaceById({required this.placeId});

  @override
  List<Object?> get props => [placeId];
}