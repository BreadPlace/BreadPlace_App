import 'package:equatable/equatable.dart';

abstract class SearchEvent extends Equatable {
  const SearchEvent();

  @override
  List<Object?> get props => [];
}

class SearchPlace extends SearchEvent {
  final String keyword;
  const SearchPlace({required this.keyword});

  @override
  List<Object?> get props => [keyword];
}

class FetchResults extends SearchEvent { }