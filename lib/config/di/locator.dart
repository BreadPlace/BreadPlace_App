import 'package:bread_place/data/repositories/kakao_search_repository_impl.dart';
import 'package:bread_place/data/services/api/kakao/kakao_dio_client.dart';
import 'package:bread_place/data/services/api/kakao/kakao_local_api.dart';
import 'package:bread_place/domain/repositories/kakao_search_repository.dart';
import 'package:bread_place/ui/search/bloc/search_bloc.dart';
import 'package:get_it/get_it.dart';

GetIt locator = GetIt.instance;

void initLocator() {
  // Kakao_local
  locator.registerLazySingleton<KakaoDioClient>(() => KakaoDioClient());
  locator.registerLazySingleton<KakaoLocalApi>(() => KakaoLocalApi(locator<KakaoDioClient>().dio));
  locator.registerLazySingleton<KakaoSearchRepository>(() => KakaoSearchRepositoryImpl(kakaoLocalApi: locator<KakaoLocalApi>()));
  locator.registerFactory(() => SearchBloc(locator<KakaoSearchRepository>()));
}
