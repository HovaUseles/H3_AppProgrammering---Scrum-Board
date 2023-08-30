import 'package:get_it/get_it.dart';

import '../data_access/auth_data_handler.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton(() => AuthDataHandler());
  // locator.registerSingleton<ApiClient>(() => ApiClient(ApiClientType.secure));
}