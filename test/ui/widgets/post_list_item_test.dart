import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_tech_task/domain/entities/post.dart';
import 'package:flutter_tech_task/localization/app_localizations.dart';
import 'package:flutter_tech_task/ui/widgets/post_list_item.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockFunction extends Mock {
  void call();
}

void main() {
  testWidgets('PostListItem displays post title and body correctly', (
    WidgetTester tester,
  ) async {
    // Create a test post
    const testPost = Post(
      id: 1,
      title: 'Test Title',
      body: 'Test Body',
      userId: 1,
      isSaved: false,
    );

    final mockOnTap = MockFunction();

    // Build our widget and trigger a frame
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: PostListItem(post: testPost, onTap: mockOnTap.call),
        ),
      ),
    );

    // Verify that the post title and body are displayed
    expect(find.text('Test Title'), findsOneWidget);
    expect(find.text('Test Body'), findsOneWidget);

    // Tap on the widget and verify that onTap is called
    await tester.tap(find.byType(InkWell));
    verify(mockOnTap.call()).called(1);
  });

  testWidgets('PostListItem displays saved chip when post is saved', (
    WidgetTester tester,
  ) async {
    // Create a test post that is saved
    const testSavedPost = Post(
      id: 1,
      title: 'Test Title',
      body: 'Test Body',
      userId: 1,
      isSaved: true,
    );

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
        home: Scaffold(body: PostListItem(post: testSavedPost, onTap: () {})),
      ),
    );

    // Wait for localization to load
    await tester.pumpAndSettle();

    // Verify that the saved chip is displayed
    expect(find.byType(Chip), findsOneWidget);
  });
}
