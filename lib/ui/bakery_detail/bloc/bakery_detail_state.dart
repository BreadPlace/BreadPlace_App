part of 'bakery_detail_bloc.dart';

abstract class BakeryDetailState extends Equatable {
  const BakeryDetailState();

  @override
  List<Object?> get props => [];
}

class BakeryDetailInitial extends BakeryDetailState {
  final Bakery bakery;

  const BakeryDetailInitial({
    required this.bakery
  });

  @override
  List<Object?> get props => [bakery];
}