import 'package:bread_place/domain/usecases/firestore_use_case.dart';
import 'package:bread_place/domain/usecases/user_local_storage_use_case.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'report_review_event.dart';
part 'report_review_state.dart';

class ReportReviewBloc extends Bloc<ReportReviewEvent, ReportReviewState> {
  final FirestoreUseCase _fireStoreUseCase;
  final UserLocalStorageUseCase _userLocalStorageUseCase;
  final String _targetReviewId;

  ReportReviewBloc({
    required FirestoreUseCase fireStoreUseCase,
    required UserLocalStorageUseCase userLocalStorageUseCase,
    required String targetReviewId,
  })
      : _fireStoreUseCase = fireStoreUseCase,
        _userLocalStorageUseCase = userLocalStorageUseCase,
        _targetReviewId = targetReviewId,
  super(ReportReviewState()) {
    on<SendReport>(_onSendReport);
  }

  Future<void> _onSendReport(SendReport event, Emitter<ReportReviewState> emit) async {
    if(state.isLoading || event.title.isEmpty || event.content.isEmpty){
      return;
    }

    emit(state.copyWith(isLoading: true));

    final writerUid = await _userLocalStorageUseCase.getUserId();

    if(writerUid == null) {
      return;
    }

    await _fireStoreUseCase.reportReview(
        targetReviewId: _targetReviewId,
        writerUid: writerUid,
        title: event.title,
        content: event.content,
    );

    emit(state.copyWith(
        isLoading: false,
        isReportSuccess: true
    ));
  }
}