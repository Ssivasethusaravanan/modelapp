import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:team_management_app/core/storage/secure_storage.dart';
import 'package:team_management_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:team_management_app/features/auth/presentation/pages/login_page.dart';
import 'package:team_management_app/features/home/presentation/bloc/home_bloc.dart';
import 'package:team_management_app/features/home/presentation/pages/home_page.dart';
import 'package:team_management_app/injection.dart';
import 'package:team_management_app/routing/app_router.dart';
import 'package:bloc_test/bloc_test.dart';

class MockAuthBloc extends MockBloc<AuthEvent, AuthState> implements AuthBloc {}
class MockHomeBloc extends MockBloc<HomeEvent, HomeState> implements HomeBloc {}
class MockTokenStorage extends Mock implements TokenStorage {}

void main() {
  late AppRouter appRouter;
  late MockAuthBloc mockAuthBloc;
  late MockHomeBloc mockHomeBloc;
  late MockTokenStorage mockTokenStorage;

  setUp(() async {
    mockAuthBloc = MockAuthBloc();
    mockHomeBloc = MockHomeBloc();
    mockTokenStorage = MockTokenStorage();
    
    await getIt.reset();
    getIt.registerSingleton<TokenStorage>(mockTokenStorage);
    getIt.registerLazySingleton<HomeBloc>(() => mockHomeBloc);
    
    // Default mock behavior for AuthBloc
    when(() => mockAuthBloc.stream).thenAnswer((_) => const Stream.empty());
    when(() => mockAuthBloc.state).thenReturn(AuthInitial());

    // Default mock behavior for HomeBloc
    when(() => mockHomeBloc.stream).thenAnswer((_) => const Stream.empty());
    when(() => mockHomeBloc.state).thenReturn(HomeInitial());
    
    appRouter = AppRouter(mockAuthBloc);
  });

  Widget createWidgetUnderTest() {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>.value(value: mockAuthBloc),
        BlocProvider<HomeBloc>.value(value: mockHomeBloc),
      ],
      child: MaterialApp.router(
        routerConfig: appRouter.router,
      ),
    );
  }

  group('AppRouter Redirect Tests', () {
    testWidgets('should redirect to /login when not logged in', (WidgetTester tester) async {
      when(() => mockTokenStorage.getToken()).thenAnswer((_) async => null);
      
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      expect(find.byType(LoginPage), findsOneWidget);
    });

    testWidgets('should redirect to / when logged in', (WidgetTester tester) async {
      when(() => mockTokenStorage.getToken()).thenAnswer((_) async => 'valid_token');
      
      await tester.pumpWidget(createWidgetUnderTest());
      // pumpAndSettle might timeout because of loading spinner in HomePage/LoginPage
      await tester.pump(const Duration(seconds: 1));
      await tester.pump(const Duration(seconds: 1));

      expect(find.byType(HomePage), findsOneWidget);
    });
  });

  group('GoRouterRefreshStream', () {
    test('should notify listeners when stream emits', () async {
      final controller = StreamController<dynamic>();
      final refreshStream = GoRouterRefreshStream(controller.stream);
      bool notified = false;
      
      refreshStream.addListener(() {
        notified = true;
      });

      controller.add('event');
      await Future<void>.delayed(Duration.zero);
      
      expect(notified, true);
      refreshStream.dispose();
      await controller.close();
    });

    test('dispose should cancel subscription', () async {
      final controller = StreamController<dynamic>();
      final refreshStream = GoRouterRefreshStream(controller.stream);
      
      refreshStream.dispose();
      
      expect(controller.hasListener, false);
      await controller.close();
    });
  });
}
