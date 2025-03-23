import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_tech_task/domain/entities/post.dart';
import 'package:flutter_tech_task/localization/app_localizations.dart';
import 'package:flutter_tech_task/ui/widgets/save_button_widget.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockCallback extends Mock {
  void call();
}

void main() {
  testWidgets('SaveButtonWidget shows save button for unsaved post', (
    WidgetTester tester,
  ) async {
    // Create an unsaved post
    const testPost = Post(
      id: 1,
      title: 'Test Title',
      body: 'Test Body',
      userId: 1,
      isSaved: false,
    );

    final mockOnPressed = MockCallback();

    // Build our widget and trigger a frame with proper localization
    await tester.pumpWidget(
      MaterialApp(
        // Add localization delegates
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: const [Locale('en', '')],
        home: Scaffold(
          body: SaveButtonWidget(post: testPost, onPressed: mockOnPressed.call),
        ),
      ),
    );

    // Wait for localization to load
    await tester.pumpAndSettle();

    // Log the widget tree to debug
    debugDumpApp();

    // Find the save button text and icon
    expect(find.text('Save'), findsOneWidget);
    expect(find.byIcon(Icons.bookmark_border), findsOneWidget);

    // Try finding any button type
    final buttonFinder = find.byWidgetPredicate(
      (widget) =>
          widget is ElevatedButton ||
          widget is TextButton ||
          widget is OutlinedButton ||
          widget is IconButton,
    );

    expect(
      buttonFinder,
      findsAtLeastNWidgets(1),
      reason: 'No button widget found',
    );

    // Tap the button
    await tester.tap(buttonFinder.first);
    verify(mockOnPressed.call()).called(1);
  });
}
