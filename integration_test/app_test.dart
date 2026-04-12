import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:team_management_app/main.dart' as app;

void main() {
  // Initialize the physical device / simulator testing framework
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('End-to-End Authentication Flow', () {
    testWidgets('verify login screen boots, handles text input, and shows error on failure',
        (tester) async {
      // 1. Start the actual Flutter application
      await app.main();

      // Wait for all the FadeIn / Slide animations to finish drawing
      await tester.pumpAndSettle();

      // 2. Verify we safely landed on the Login Page
      expect(find.text('Welcome Back'), findsOneWidget);

      // 3. Locate the TextFields on the screen
      final emailField = find.byType(TextField).first;
      final passwordField = find.byType(TextField).last;
      final loginButton = find.widgetWithText(ElevatedButton, 'LOGIN');

      // 4. Simulate the user typing on their physical keyboard
      await tester.enterText(emailField, 'hacker@email.com');
      await tester.enterText(passwordField, 'wrongpassword123');

      // Close the on-screen keyboard
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();

      // 5. Simulate the user physically tapping the LOGIN button
      await tester.tap(loginButton);
      
      // Force the test to wait while the BLoC makes the real HTTP request
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // 6. Verify that an Error SnackBar popped up from the backend rejection!
      expect(find.byType(SnackBar), findsOneWidget);
    });
  });
}
