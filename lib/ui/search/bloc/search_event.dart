import 'package:equatable/equatable.dart';

abstract class SearchEvent extends Equatable {
  const SearchEvent();
}

class SearchPlace extends SearchEvent {
  final String query;
  const SearchPlace({required this.query});

  @override
  List<Object?> get props => [query];
}