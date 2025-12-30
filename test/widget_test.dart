import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:xo_game/main.dart';

void main() {
  testWidgets('App loads HomeScreen', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const XOTicTacToeApp());

    // Verify that the HomeScreen is loaded
    expect(find.byType(Scaffold), findsOneWidget);
  });
}

