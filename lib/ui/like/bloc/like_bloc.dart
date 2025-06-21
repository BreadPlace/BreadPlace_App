import 'package:bread_place/domain/entities/liked_bakery_entity.dart';
import 'package:bread_place/domain/usecases/liked_bakery_use_case.dart';
import 'package:bread_place/ui/like/bloc/like_event.dart';
import 'package:bread_place/ui/like/bloc/like_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LikeBloc extends Bloc<LikeEvent, LikeState> {
  final LikedBakeryUseCase _likedBakeryUseCase;

  LikeBloc(this._likedBakeryUseCase) : super(LikeState(status: LikeStatus.initial)) {
    on<FetchLikedBakeries>(_onFetchLikedBakeries);
    on<AddLike>(_onAddLike);
    on<RemoveLike>(_onRemoveLike);

  }

  /// 좋아요 목록에 추가
  Future<void> _onAddLike(AddLike event, Emitter emit) async {

    final liked = LikedBakeryEntity(
        isNotify: event.isNotify,
        updatedAt: DateTime.now().toIso8601String(),
        bakery: event.bakery);

    // 존재하지 않는 경우만 추가
    if (!state.bakeries.contains(liked)) {
      final updatedList = List<LikedBakeryEntity>.from(state.bakeries)
        ..add(liked);

      await _likedBakeryUseCase.addLike(liked, event.isNotify); // 파이어베이스에 저장

      emit(state.copyWith(
        status: LikeStatus.success,
        bakeries: updatedList,
      ));
    } else {
      print("_onAddLike : 이미 좋아요 한 빵집입니다");
    }
  }

  /// 좋아요 목록에서 제거
  Future<void> _onRemoveLike(RemoveLike event, Emitter emit) async {
    try {
      final updatedList = List<LikedBakeryEntity>.from(state.bakeries)
        ..removeWhere((b) => b.bakery?.id == event.bakery.id);

      await _likedBakeryUseCase.removeLike(event.bakery.id); // 파이어베이스 삭제

      emit(state.copyWith(
          status: LikeStatus.success,
          bakeries: updatedList
      ));
    } catch(e) {
      print("onRemoveLike 삭제 중 에러 $e");
    }

  }

  /// 서버에 저장된 좋아요 목록 가져오기
  Future<void> _onFetchLikedBakeries(FetchLikedBakeries event, Emitter emit) async {
    try {
      final likedBakeries = await _likedBakeryUseCase.fetchLikedBakeriesWithDetails();

      if(likedBakeries.isEmpty) {
        emit(state.copyWith(status: LikeStatus.empty, bakeries: []));
      } else {
        emit(state.copyWith(status: LikeStatus.success, bakeries: likedBakeries));
      }
    } catch (e) {
      emit(state.copyWith(
        status: LikeStatus.error,
        errorMessage: '좋아요한 베이커리 불러오기 실패',
      ));
    }
  }
}