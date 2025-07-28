import 'package:bread_place/domain/usecases/notification_use_case.dart';
import 'package:bread_place/ui/mypage/view/bloc/my_page_event.dart';
import 'package:bread_place/ui/mypage/view/bloc/my_page_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyPageBloc extends Bloc<MyPageEvent, MyPageState> {
  final NotificationUseCase _notificationUseCase;

  MyPageBloc({required NotificationUseCase notificationUseCase})
    : _notificationUseCase = notificationUseCase,
      super(MyPageState()) {
    on<OpenDeviceSetting>(_onOpenDeviceSetting);
  }

  Future<void> _onOpenDeviceSetting(
    OpenDeviceSetting event,
    Emitter<MyPageState> emit,
  ) async {
    await _notificationUseCase.openDeviceAppSettings();
  }
}
