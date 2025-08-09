import 'package:bread_place/config/constants/exception/geofence_exception.dart';
import 'package:bread_place/domain/entities/bakery.dart';
import 'package:bread_place/domain/entities/liked_bakery_entity.dart';
import 'package:bread_place/domain/usecases/geofencing_use_case.dart';
import 'package:bread_place/domain/usecases/liked_bakery_use_case.dart';
import 'package:bread_place/ui/like/bloc/like_event.dart';
import 'package:bread_place/ui/like/bloc/like_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LikeBloc extends Bloc<LikeEvent, LikeState> {
  final LikedBakeryUseCase _likedBakeryUseCase;
  final GeofencingUseCase _geofencingUseCase;

  LikeBloc(this._likedBakeryUseCase, this._geofencingUseCase) : super(LikeState(status: LikeStatus.initial)) {
    on<FetchLikedBakeries>(_onFetchLikedBakeries);
    on<ResetLikedBakeries>(_onResetLikedBakeries);
    on<AddLike>(_onAddLike);
    on<RemoveLike>(_onRemoveLike);
    on<ToggleNotification>(_onToggleNotificationAndUpdateGeofence);
    on<InitializeGeofence>(_onInitializeGeofenceRegistration);
  }

  /// 좋아요 목록에 추가
  Future<void> _onAddLike(AddLike event, Emitter emit) async {

    final liked = LikedBakeryEntity(
        isNotificationAllowed: event.isNotificationAllowed,
        updatedAt: DateTime.now().toIso8601String(),
        bakery: event.bakery);

    // 존재하지 않는 경우만 추가
    if (!state.bakeries.contains(liked)) {
      final updatedList = List<LikedBakeryEntity>.from(state.bakeries)
        ..add(liked);

      await _likedBakeryUseCase.addLike(liked, event.isNotificationAllowed); // 파이어베이스에 저장

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

  /// 해당 빵집 Notification 허용 여부 토글 + 지오펜스 등록
  Future<void> _onToggleNotificationAndUpdateGeofence(ToggleNotification event,
      Emitter<LikeState> emit) async {
    Bakery bakery = event.bakery;
    bool currentState = event.isNotificationAllowed;
    bool newState = !currentState;
    String location = event.bakery.formattedLocationWithDetail;

    emit(state.copyWith(status: LikeStatus.loading));

    try {
      await _updateGeofenceLocation(location);
      final updateList = _updateIsAllowed(bakery, newState);

      await _updateNotificationStatus(bakery.id, newState);

      emit(state.copyWith(
          bakeries: updateList,
          status: LikeStatus.success));

    } on GeofenceLimitExceededException catch (e) {
      emit(state.copyWith(
        status: LikeStatus.geofenceLimitExceeded,
        errorMessage: e.message,
      ));
    } catch (e) {
      emit(state.copyWith(
          status: LikeStatus.error,
          errorMessage: '알림 등록 중 오류가 발생했습니다. 다시 시도해 주세요.'));
    }
  }

  List<LikedBakeryEntity> _updateIsAllowed(Bakery bakery, bool isAllowed) {
    return state.bakeries.map((liked) {
      if (liked.bakery?.id == bakery.id) {
        return LikedBakeryEntity(
          isNotificationAllowed: isAllowed,
          updatedAt: liked.updatedAt,
          bakery: liked.bakery,
        );
      }
      return liked;
    }).toList();
  }

  Future<void> _updateNotificationStatus(String bakeryId, bool newState) async {
      await _likedBakeryUseCase.updateIsNotificationAllowed(bakeryId, newState);
  }

  Future<void> _updateGeofenceLocation(String formattedLocation) async {
      await _geofencingUseCase.updateGeofenceLocation(formattedLocation);
  }

  void _onResetLikedBakeries(ResetLikedBakeries event, Emitter emit) {
    emit(state.copyWith(
      bakeries: []
    ));
  }

  Future<List<String>> getLocalSavedGeofence() async {
    return await _geofencingUseCase.getLocalSavedLocations();
  }
  
  Future<void> _onInitializeGeofenceRegistration(InitializeGeofence event, Emitter<LikeState> emit) async {
    try {
      await _geofencingUseCase.initializeGeofenceFromLocalStorage();
    } catch (e) {
      print("InitializeGeofence error $e");
    }
    emit(state.copyWith(status: LikeStatus.geofenceInitSuccess));
  }
}