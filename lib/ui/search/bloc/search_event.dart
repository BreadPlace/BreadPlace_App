import 'package:equatable/equatable.dart';

abstract class SearchEvent extends Equatable {
  const SearchEvent();
}

class SearchPlace extends SearchEvent {
  final String keyword;
  const SearchPlace({required this.keyword});

  @override
  List<Object?> get props => [keyword];
}