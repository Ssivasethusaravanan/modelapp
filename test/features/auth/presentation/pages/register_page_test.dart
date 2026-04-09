import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:team_management_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:team_management_app/features/auth/presentation/pages/register_page.dart';
import 'package:team_management_app/injection.dart';

class MockAuthBloc extends MockBloc<AuthEvent, AuthState> implements AuthBloc {}

void main() {
  late MockAuthBloc mockAuthBloc;

  setUp(() {
    mockAuthBloc = MockAuthBloc();
    getIt.reset();
    getIt.registerFactory<AuthBloc>(() => mockAuthBloc);
  });

  Widget createWidgetUnderTest() {
    return const MaterialApp(
      home: RegisterPage(),
    );
  }

  testWidgets('renders name, email and password text fields', (WidgetTester tester) async {
    when(() => mockAuthBloc.state).thenReturn(AuthInitial());
    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pumpAndSettle();

    expect(find.byType(TextField), findsNWidgets(3));
    expect(find.text('Full Name'), findsOneWidget);
    expect(find.text('Email Address'), findsOneWidget);
    expect(find.text('Password'), findsOneWidget);
  });

  testWidgets('emits RegisterRequested when sign up button is pressed', (WidgetTester tester) async {
    when(() => mockAuthBloc.state).thenReturn(AuthInitial());
    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField).at(0), 'Test User');
    await tester.enterText(find.byType(TextField).at(1), 'test@example.com');
    await tester.enterText(find.byType(TextField).at(2), 'password123');
    
    await tester.tap(find.text('SIGN UP'));
    await tester.pump();

    verify(() => mockAuthBloc.add(RegisterRequested('test@example.com', 'password123', 'Test User'))).called(1);
  });
}
