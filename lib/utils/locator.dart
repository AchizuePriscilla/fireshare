import 'package:fireshare/handlers/navigation_handler.dart';
import 'package:get_it/get_it.dart';

GetIt locator = GetIt.instance;

setUpLocator() {
  locator
      .registerLazySingleton<NavigationHandler>(() => NavigationHandlerImpl());
}
