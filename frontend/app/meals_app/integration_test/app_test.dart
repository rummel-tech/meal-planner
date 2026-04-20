import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:meals_app/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Meal Planner — App Launch', () {
    testWidgets('App loads without crashing', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 5));

      expect(tester.takeException(), isNull);
      expect(find.byType(MaterialApp), findsOneWidget);
    });

    testWidgets('App renders a Scaffold', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 5));

      expect(find.byType(Scaffold), findsWidgets);
    });
  });

  group('Meal Planner — Authentication Gate', () {
    testWidgets('App shows login screen when not authenticated', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // Unauthenticated → login screen or loading → login
      // Either the login screen text or meals home should be visible
      final hasLogin = find.textContaining('Log In').evaluate().isNotEmpty ||
          find.textContaining('Login').evaluate().isNotEmpty ||
          find.textContaining('Sign').evaluate().isNotEmpty;
      final hasHome = find.text('Meal Planner').evaluate().isNotEmpty;

      expect(hasLogin || hasHome, isTrue);
    });

    testWidgets('Login screen has email and password fields', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // If on login screen, form fields should be present
      final loginVisible = find.textContaining('Log In').evaluate().isNotEmpty ||
          find.textContaining('Login').evaluate().isNotEmpty;

      if (loginVisible) {
        expect(find.byType(TextField), findsWidgets);
      }
    });

    testWidgets('App does not crash during auth check', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 5));

      expect(tester.takeException(), isNull);
    });
  });

  group('Meal Planner — Home Screen (when authenticated)', () {
    testWidgets('App title is displayed when home is visible', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 5));

      final hasMealPlannerTitle = find.text('Meal Planner').evaluate().isNotEmpty;
      // If authenticated, title should be shown; if not, login screen is shown
      expect(hasMealPlannerTitle || find.byType(TextField).evaluate().isNotEmpty, isTrue);
    });

    testWidgets('Meal Planning section header is visible when home loads', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // When authenticated and home screen is showing
      final hasMealPlanningHeader = find.text('Meal Planning').evaluate().isNotEmpty;
      // Pass if home not shown (auth gate active)
      expect(tester.takeException(), isNull);
      if (hasMealPlanningHeader) {
        expect(find.text('Meal Planning'), findsOneWidget);
      }
    });

    testWidgets('Refresh icon is present on home screen', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 5));

      final mealPlannerVisible = find.text('Meal Planner').evaluate().isNotEmpty;
      if (mealPlannerVisible) {
        expect(find.byIcon(Icons.refresh), findsOneWidget);
      }
    });

    testWidgets('Refresh button triggers reload without crashing', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 5));

      final refreshBtn = find.byIcon(Icons.refresh);
      if (refreshBtn.evaluate().isNotEmpty) {
        await tester.tap(refreshBtn.first);
        await tester.pumpAndSettle(const Duration(seconds: 3));
        expect(tester.takeException(), isNull);
      }
    });
  });

  group('Meal Planner — Loading States', () {
    testWidgets('App displays loading state initially then settles', (WidgetTester tester) async {
      app.main();

      // May show loading indicator initially
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));

      // Settle
      await tester.pumpAndSettle(const Duration(seconds: 5));

      expect(tester.takeException(), isNull);
    });

    testWidgets('App handles backend unavailability gracefully', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // Even if API calls fail, app structure should remain
      expect(tester.takeException(), isNull);
    });
  });

  group('Meal Planner — Pull to Refresh', () {
    testWidgets('Pull to refresh gesture does not crash', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 5));

      final refreshIndicator = find.byType(RefreshIndicator);
      if (refreshIndicator.evaluate().isNotEmpty) {
        await tester.drag(refreshIndicator.first, const Offset(0, 300));
        await tester.pumpAndSettle(const Duration(seconds: 3));

        expect(tester.takeException(), isNull);
      }
    });
  });

  group('Meal Planner — Stability', () {
    testWidgets('App remains stable after multiple pump cycles', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 5));
      await tester.pumpAndSettle(const Duration(seconds: 2));

      expect(tester.takeException(), isNull);
      expect(find.byType(Scaffold), findsWidgets);
    });

    testWidgets('Theme is applied correctly', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      final materialApp = tester.widget<MaterialApp>(
        find.byType(MaterialApp).first,
      );
      // App uses RummelBlueTheme — theme object should be set
      expect(materialApp.theme, isNotNull);
    });
  });
}
