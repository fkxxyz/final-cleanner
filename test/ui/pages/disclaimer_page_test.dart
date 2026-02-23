import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:final_cleaner/ui/pages/disclaimer_page.dart';
import 'package:final_cleaner/l10n/app_localizations.dart';

void main() {
  group('DisclaimerPage', () {
    testWidgets('renders with correct localized strings', (tester) async {
      bool agreeCalled = false;

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: DisclaimerPage(
            onAgree: () {
              agreeCalled = true;
            },
          ),
        ),
      );

      // Verify warning icon is displayed
      expect(find.byIcon(Icons.warning_amber_rounded), findsOneWidget);

      // Verify title is displayed
      expect(find.text('Warning'), findsOneWidget);

      // Verify body text contains key phrases
      expect(find.textContaining('advanced users'), findsOneWidget);
      expect(find.textContaining('permanently delete'), findsOneWidget);

      // Verify buttons are displayed
      expect(find.text('I Understand and Agree'), findsOneWidget);
      expect(find.text('Decline'), findsOneWidget);
    });

    testWidgets('Agree button triggers callback', (tester) async {
      bool agreeCalled = false;

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: DisclaimerPage(
            onAgree: () {
              agreeCalled = true;
            },
          ),
        ),
      );

      // Tap the Agree button
      await tester.tap(find.text('I Understand and Agree'));
      await tester.pumpAndSettle();

      // Verify callback was called
      expect(agreeCalled, isTrue);
    });

    testWidgets('Decline button shows AlertDialog', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: DisclaimerPage(
            onAgree: () {},
          ),
        ),
      );

      // Tap the Decline button
      await tester.tap(find.text('Decline'));
      await tester.pumpAndSettle();

      // Verify AlertDialog is shown
      expect(find.byType(AlertDialog), findsOneWidget);
      expect(
        find.text('This app requires you to understand and accept the risks to use it.'),
        findsOneWidget,
      );
      expect(find.text('OK'), findsOneWidget);
    });

    testWidgets('WillPopScope prevents back button dismissal', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: DisclaimerPage(
            onAgree: () {},
          ),
        ),
      );

      // Verify WillPopScope is present
      expect(find.byType(WillPopScope), findsOneWidget);

      // Get the WillPopScope widget
      final willPopScope = tester.widget<WillPopScope>(
        find.byType(WillPopScope),
      );

      // Verify onWillPop returns false
      final result = await willPopScope.onWillPop!();
      expect(result, isFalse);
    });

    testWidgets('body text is scrollable', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: DisclaimerPage(
            onAgree: () {},
          ),
        ),
      );

      // Verify SingleChildScrollView is present
      expect(find.byType(SingleChildScrollView), findsOneWidget);
    });
  });
}
