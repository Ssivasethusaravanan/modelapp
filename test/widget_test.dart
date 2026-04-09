import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:team_management_app/app.dart';
import 'package:team_management_app/injection.dart';
import 'package:team_management_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:team_management_app/routing/app_router.dart';
import 'package:team_management_app/core/storage/secure_storage.dart';
import 'package:bloc_test/bloc_test.dart';

class MockAuthBloc extends MockBloc<AuthEvent, AuthState> implements AuthBloc {}
class MockAppRouter extends Mock implements AppRouter {}
class MockTokenStorage extends Mock implements TokenStorage {}

void main() {
  late MockAuthBloc mockAuthBloc;
  late MockAppRouter mockAppRouter;
  late MockTokenStorage mockTokenStorage;

  setUp(() {
    mockAuthBloc = MockAuthBloc();
    mockAppRouter = MockAppRouter();
    mockTokenStorage = MockTokenStorage();

    getIt.reset();
    getIt.registerFactory<AuthBloc>(() => mockAuthBloc);
    getIt.registerSingleton<AppRouter>(mockAppRouter);
    getIt.registerSingleton<TokenStorage>(mockTokenStorage);

    when(() => mockAuthBloc.state).thenReturn(AuthInitial());
    when(() => mockAuthBloc.stream).thenAnswer((_) => Stream<AuthState>.empty());
    when(() => mockTokenStorage.getToken()).thenAnswer((_) async => null);
  });

  testWidgets('App smoke test', (WidgetTester tester) async {
    // We need a router for the test
    final router = AppRouter(mockAuthBloc);
    getIt.unregister<AppRouter>();
    getIt.registerSingleton<AppRouter>(router);

    await tester.pumpWidget(const MainApp());
    
    // Check if the app renders (e.g., finding the MaterialApp or a specific route widget)
    expect(find.byType(MainApp), findsOneWidget);
  });
}
