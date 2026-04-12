import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:team_management_app/main.dart' as app;
import 'package:team_management_app/app.dart';
import 'package:team_management_app/core/bloc/app_bloc_observer.dart';
import 'package:team_management_app/injection.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  group('Widget Integration Test Flow (Headless)', () {
    testWidgets('verify login screen handles input without physical emulator', (tester) async {
      // 1. Manually boot up dependencies without the Native OS hooks
      configureDependencies();
      Bloc.observer = AppBlocObserver();

      // 2. Pump the root widget into RAM (Virtual Screen)
      await tester.pumpWidget(const MainApp());
      await tester.pumpAndSettle();

      // 3. Verify Login Screen loaded
      expect(find.text('Welcome Back'), findsOneWidget);

      // 4. Locate fields
      final emailField = find.byType(TextField).first;
      final passwordField = find.byType(TextField).last;
      final loginButton = find.widgetWithText(ElevatedButton, 'LOGIN');

      // 5. Enter text
      await tester.enterText(emailField, 'hacker@email.com');
      await tester.enterText(passwordField, 'wrongpassword123');
      await tester.pumpAndSettle();

      // 6. Tap login
      await tester.tap(loginButton);
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // 7. Verify error snackbar appears
      expect(find.byType(SnackBar), findsOneWidget);
    });
  });
}
