import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meals_app/main.dart';

void main() {
  group('MealsApp', () {
    testWidgets('renders MaterialApp', (tester) async {
      await tester.pumpWidget(const MealsApp());
      expect(find.byType(MaterialApp), findsOneWidget);
    });

    testWidgets('shows loading state initially', (tester) async {
      await tester.pumpWidget(const MealsApp());
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('has correct title', (tester) async {
      await tester.pumpWidget(const MealsApp());
      final app = tester.widget<MaterialApp>(find.byType(MaterialApp));
      expect(app.title, 'Meal Planner');
    });

    testWidgets('debug banner is off', (tester) async {
      await tester.pumpWidget(const MealsApp());
      final app = tester.widget<MaterialApp>(find.byType(MaterialApp));
      expect(app.debugShowCheckedModeBanner, isFalse);
    });

    testWidgets('uses Material 3 theme', (tester) async {
      await tester.pumpWidget(const MealsApp());
      final app = tester.widget<MaterialApp>(find.byType(MaterialApp));
      expect(app.theme?.useMaterial3, isTrue);
    });

    testWidgets('renders Scaffold', (tester) async {
      await tester.pumpWidget(const MealsApp());
      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('does not throw on pump', (tester) async {
      await tester.pumpWidget(const MealsApp());
      await tester.pump(const Duration(seconds: 1));
      expect(tester.takeException(), isNull);
    });
  });
}
