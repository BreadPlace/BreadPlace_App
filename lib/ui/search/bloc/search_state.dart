import 'package:bread_place/domain/entities/place.dart';
import 'package:equatable/equatable.dart';

abstract class SearchState extends Equatable {
  const SearchState();

  @override
  List<Object?> get props => [];
}

class SearchInitial extends SearchState {}

class SearchLoading extends SearchState {}

class SearchSuccess extends SearchState {
  final List<Place> places;
  const SearchSuccess(this.places);

  @override
  List<Object?> get props => [places];
}

class SearchFailure extends SearchState {
  final String message;
  const SearchFailure(this.message);

  @override
  List<Object?> get props => [message];
}