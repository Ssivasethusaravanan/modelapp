import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:team_management_app/features/auth/data/models/auth_models.dart';
import 'package:team_management_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:team_management_app/features/home/presentation/bloc/home_bloc.dart';
import 'package:team_management_app/features/home/presentation/pages/home_page.dart';
import 'package:team_management_app/injection.dart';

class MockHomeBloc extends MockBloc<HomeEvent, HomeState> implements HomeBloc {}
class MockAuthBloc extends MockBloc<AuthEvent, AuthState> implements AuthBloc {}

void main() {
  late MockHomeBloc mockHomeBloc;
  late MockAuthBloc mockAuthBloc;

  setUp(() async {
    mockHomeBloc = MockHomeBloc();
    mockAuthBloc = MockAuthBloc();
    
    await getIt.reset();
    getIt.registerFactory<HomeBloc>(() => mockHomeBloc);
    getIt.registerSingleton<AuthBloc>(mockAuthBloc);
  });

  Widget createWidgetUnderTest() {
    return MaterialApp(
      home: MultiBlocProvider(
        providers: [
          BlocProvider<HomeBloc>.value(value: mockHomeBloc),
          BlocProvider<AuthBloc>.value(value: mockAuthBloc),
        ],
        child: const Scaffold(body: HomeView()),
      ),
    );
  }

  group('HomeView', () {
    const tUserData = UserData(
      id: '1',
      email: 'test@example.com',
      name: 'Test User',
      createdAt: '2023-01-01',
      lastLogin: '2023-01-02',
    );
    final tHomeData = HomeResponse(user: tUserData, message: 'Welcome back');

    testWidgets('shows loading indicator when state is HomeLoading', (WidgetTester tester) async {
      when(() => mockHomeBloc.state).thenReturn(HomeLoading());
      await tester.pumpWidget(createWidgetUnderTest());
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('shows error message and retry button when state is HomeError', (WidgetTester tester) async {
      when(() => mockHomeBloc.state).thenReturn(HomeError('Error loading data'));
      await tester.pumpWidget(createWidgetUnderTest());
      
      expect(find.text('Error loading data'), findsOneWidget);
      expect(find.text('RETRY'), findsOneWidget);

      await tester.tap(find.text('RETRY'));
      verify(() => mockHomeBloc.add(GetHomeDataRequested())).called(1);
    });

    testWidgets('renders user data when state is HomeLoaded', (WidgetTester tester) async {
      when(() => mockHomeBloc.state).thenReturn(HomeLoaded(tHomeData));
      
      // Set a small screen size to test mobile layout
      tester.view.physicalSize = const Size(400, 800);
      tester.view.devicePixelRatio = 1.0;

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      expect(find.text('Welcome back'), findsOneWidget);
      expect(find.text('Test User'), findsOneWidget);
      expect(find.text('test@example.com'), findsOneWidget);
      
      // Logout button interaction
      await tester.tap(find.byIcon(Icons.logout));
      verify(() => mockAuthBloc.add(LogoutRequested())).called(1);
      
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });
    });

    testWidgets('renders sidebar when on desktop', (WidgetTester tester) async {
      when(() => mockHomeBloc.state).thenReturn(HomeLoaded(tHomeData));
      
      // Set a large screen size to test desktop layout
      tester.view.physicalSize = const Size(1200, 800);
      tester.view.devicePixelRatio = 1.0;

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      expect(find.text('Dashboard'), findsOneWidget);
      expect(find.text('Team Members'), findsOneWidget);
      expect(find.text('Logout'), findsOneWidget);
      
      await tester.tap(find.text('Logout'));
      verify(() => mockAuthBloc.add(LogoutRequested())).called(1);

      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });
    });
  });
}
