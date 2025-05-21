import 'package:bread_place/domain/entities/bakery.dart';
import 'package:equatable/equatable.dart';

abstract class SearchState extends Equatable {
  const SearchState();

  @override
  List<Object?> get props => [];
}

class SearchInitial extends SearchState {}

class SearchLoading extends SearchState {}

class SearchSuccess extends SearchState {
  final List<Bakery> bakeries;

  const SearchSuccess({required this.bakeries});

  @override
  List<Object?> get props => [bakeries];
}

class SearchFailure extends SearchState {
  final String message;
  const SearchFailure(this.message);

  @override
  List<Object?> get props => [message];
}