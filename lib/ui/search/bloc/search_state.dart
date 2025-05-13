import 'package:bread_place/data/dto/response/kakao/local_search/search_document.dart';
import 'package:bread_place/data/dto/response/kakao/local_search/search_response.dart';
import 'package:equatable/equatable.dart';

abstract class SearchState extends Equatable {
  const SearchState();

  @override
  List<Object?> get props => [];
}

class SearchInitial extends SearchState {}

class SearchLoading extends SearchState {}

class SearchSuccess extends SearchState {
  final List<SearchDocument> response;
  const SearchSuccess(this.response);

  @override
  List<Object?> get props => [response];
}

class SearchFailure extends SearchState {
  final String message;
  const SearchFailure(this.message);

  @override
  List<Object?> get props => [message];
}