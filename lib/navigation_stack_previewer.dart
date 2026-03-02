/// A visual navigation stack previewer for Flutter.
/// 
/// Swipe down from the top edge to see real-time screenshots of your 
/// navigation history and navigate back instantly by tapping on them.
library navigation_stack_previewer;

export 'src/di/injection_container.dart';
export 'src/services/navigation_history_service.dart' show NavigationHistoryService;
export 'src/services/navigation_stack_observer.dart';
export 'src/widgets/navigation_stack_previewer_wrapper.dart';
