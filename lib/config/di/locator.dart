import 'package:bread_place/config/di/di_bloc.dart';
import 'package:bread_place/config/di/di_repository.dart';
import 'package:bread_place/config/di/di_service.dart';
import 'package:bread_place/config/di/di_usecase.dart';
import 'package:bread_place/config/di/di_util.dart';
import 'package:get_it/get_it.dart';

GetIt di = GetIt.instance;

void initLocator() {
  registerUtil(di);
  registerService(di);
  registerRepository(di);
  registerUseCase(di);
  registerBloc(di);
}