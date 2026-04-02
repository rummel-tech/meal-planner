import 'package:flutter/widgets.dart';

/// Provides app-level configuration to descendant widgets via InheritedWidget.
class AppContext extends InheritedWidget {
  static const String appName = 'Meal Planner';

  final String environment;

  const AppContext({
    super.key,
    required this.environment,
    required super.child,
  });

  static AppContext of(BuildContext context) {
    final result = context.dependOnInheritedWidgetOfExactType<AppContext>();
    assert(result != null, 'No AppContext found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(AppContext oldWidget) =>
      environment != oldWidget.environment;
}

/// Convenience wrapper that inserts [AppContext] into the widget tree.
class AppContextProvider extends StatelessWidget {
  final String environment;
  final Widget child;

  const AppContextProvider({
    super.key,
    required this.environment,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return AppContext(
      environment: environment,
      child: child,
    );
  }
}
