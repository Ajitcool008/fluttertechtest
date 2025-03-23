import 'package:flutter/material.dart';
import 'package:flutter_tech_task/main.dart' as app;
import 'package:flutter_tech_task/ui/widgets/post_list_item.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('End-to-end post navigation test', () {
    testWidgets('navigate through app flow', (WidgetTester tester) async {
      // Start the app
      app.main();

      // Wait for app to load
      await tester.pumpAndSettle();

      // Wait a bit more for network requests
      await Future.delayed(const Duration(seconds: 3));
      await tester.pumpAndSettle();
      // UI changes and localization differences
      final postItemFinder = find.byType(PostListItem);

      // Try to give UI more time to load if posts aren't found immediately
      if (postItemFinder.evaluate().isEmpty) {
        await Future.delayed(const Duration(seconds: 3));
        await tester.pumpAndSettle();
      }

      expect(
        postItemFinder,
        findsAtLeastNWidgets(1),
        reason: 'No posts found in the list',
      );

      // Tap on the first post
      await tester.tap(postItemFinder.first);
      await tester.pumpAndSettle();

      // Try to find back button
      final backButtonFinder = find.byIcon(Icons.arrow_back);

      expect(
        backButtonFinder,
        findsOneWidget,
        reason: 'No back button found on details screen',
      );

      // Find any button on the details screen
      final buttonFinder = find.byWidgetPredicate(
        (widget) =>
            widget is ElevatedButton ||
            widget is TextButton ||
            widget is OutlinedButton ||
            widget is IconButton ||
            widget is MaterialButton,
      );

      expect(
        buttonFinder,
        findsAtLeastNWidgets(1),
        reason: 'No buttons found on details screen',
      );

      // Go back
      await tester.tap(backButtonFinder);
      await tester.pumpAndSettle();

      // Verify we're back at the list by finding posts again
      expect(find.byType(PostListItem), findsAtLeastNWidgets(1));
    });
  });
}
