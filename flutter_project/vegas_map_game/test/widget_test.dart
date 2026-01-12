import 'package:flutter_test/flutter_test.dart';

import 'package:vegas_map_game/main.dart';

void main() {
  testWidgets('Vegas Map Game app loads correctly', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const VegasMapGameApp());

    // Verify that the main menu loads with the title
    expect(find.text('VEGAS MAP GAME'), findsOneWidget);
    
    // Verify the start button is present
    expect(find.text('START EXPLORING'), findsOneWidget);
    
    // Verify the how to play button is present
    expect(find.text('How to Play'), findsOneWidget);
  });

  testWidgets('Start button is tappable', (WidgetTester tester) async {
    await tester.pumpWidget(const VegasMapGameApp());

    // Verify start button exists
    final startButton = find.text('START EXPLORING');
    expect(startButton, findsOneWidget);
  });
}
