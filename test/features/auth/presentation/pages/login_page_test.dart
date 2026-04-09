import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:team_management_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:team_management_app/features/auth/presentation/pages/login_page.dart';
import 'package:team_management_app/features/auth/data/models/auth_models.dart';
import 'package:team_management_app/injection.dart';
import 'package:glassmorphism/glassmorphism.dart';

class MockAuthBloc extends MockBloc<AuthEvent, AuthState> implements AuthBloc {}
class MockGoRouter extends Mock implements GoRouter {}

void main() {
  late MockAuthBloc mockAuthBloc;
  late MockGoRouter mockGoRouter;

  setUpAll(() {
    // Basic injectable setup if needed, but we often mock getIt in widget tests
    // For simplicity, we'll try to override the BlocProvider in the widget if possible, 
    // but LoginPage uses getIt<AuthBloc>() inside build.
  });

  setUp(() {
    mockAuthBloc = MockAuthBloc();
    mockGoRouter = MockGoRouter();
    // Register the mock with getIt
    getIt.reset();
    getIt.registerFactory<AuthBloc>(() => mockAuthBloc);
  });

  Widget createWidgetUnderTest() {
    return MaterialApp(
      home: BlocProvider<AuthBloc>(
        create: (context) => mockAuthBloc,
        child: InheritedProvider<GoRouter>.value(
          value: mockGoRouter,
          child: const LoginPage(),
        ),
      ),
    );
  }

  testWidgets('renders email and password text fields', (WidgetTester tester) async {
    when(() => mockAuthBloc.state).thenReturn(AuthInitial());
    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pumpAndSettle();

    expect(find.byType(TextField), findsNWidgets(2));
    expect(find.text('Email Address'), findsOneWidget);
    expect(find.text('Password'), findsOneWidget);
  });

  testWidgets('shows loading indicator when state is AuthLoading', (WidgetTester tester) async {
    when(() => mockAuthBloc.state).thenReturn(AuthLoading());
    await tester.pumpWidget(createWidgetUnderTest());
    // Use a fixed duration pump instead of pumpAndSettle to avoid timeout from infinite spinner
    await tester.pump(const Duration(seconds: 1));
    
    // We expect a CircularProgressIndicator instead of the LOGIN text in the button
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    
    // Wait for animations to finish before disposal
    await tester.pump(const Duration(seconds: 1));
  });

  testWidgets('emits LoginRequested when login button is pressed', (WidgetTester tester) async {
    when(() => mockAuthBloc.state).thenReturn(AuthInitial());
    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField).at(0), 'test@example.com');
    await tester.enterText(find.byType(TextField).at(1), 'password123');
    
    final loginButton = find.text('LOGIN');
    await tester.ensureVisible(loginButton);
    await tester.tap(loginButton);
    await tester.pump();

    verify(() => mockAuthBloc.add(LoginRequested('test@example.com', 'password123'))).called(1);
  });

  testWidgets('shows snackbar when state is AuthError', (WidgetTester tester) async {
    final listenStates = [AuthInitial(), AuthError('Invalid credentials')];
    whenListen(mockAuthBloc, Stream.fromIterable(listenStates));
    when(() => mockAuthBloc.state).thenReturn(AuthError('Invalid credentials'));

    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pump(); // Trigger listener
    await tester.pump(); // Show snackbar

    expect(find.byType(SnackBar), findsOneWidget);
    expect(find.text('Invalid credentials'), findsOneWidget);

    // Wait for snackbar and animations to finish
    await tester.pumpAndSettle();
  });
}
