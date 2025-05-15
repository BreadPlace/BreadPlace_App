import 'package:bread_place/data/repositories/kakao_search_repository_impl.dart';
import 'package:bread_place/data/services/api/kakao/kakao_dio_client.dart';
import 'package:bread_place/data/services/api/kakao/kakao_local_api.dart';
import 'package:bread_place/domain/repositories/kakao_search_repository.dart';
import 'package:bread_place/ui/search/bloc/search_bloc.dart';
import 'package:get_it/get_it.dart';

GetIt di = GetIt.instance;

void initLocator() {
  // Kakao_local
  di.registerLazySingleton<KakaoDioClient>(() => KakaoDioClient());
  di.registerLazySingleton<KakaoLocalApi>(() => KakaoLocalApi(di<KakaoDioClient>().dio));
  di.registerLazySingleton<KakaoSearchRepository>(() => KakaoSearchRepositoryImpl(kakaoLocalApi: di<KakaoLocalApi>()));
  di.registerFactory(() => SearchBloc(di<KakaoSearchRepository>()));
}
