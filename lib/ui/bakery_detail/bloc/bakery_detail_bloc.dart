import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:bread_place/domain/entities/bakery.dart';

part 'bakery_detail_event.dart';
part 'bakery_detail_state.dart';

class BakeryDetailBloc extends Bloc<BakeryDetailEvent, BakeryDetailState> {
  BakeryDetailBloc(Bakery bakery) : super(BakeryDetailInitial(bakery: bakery));
}