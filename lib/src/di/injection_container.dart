import 'package:get_it/get_it.dart';
import '../services/navigation_history_service.dart';

/// Service locator instance.
final sl = GetIt.instance;

/// Initializes the dependency injection container.
Future<void> initNavHistory() async {
  sl.registerLazySingleton(() => NavigationHistoryService());
}
