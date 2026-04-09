import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:team_management_app/features/auth/data/models/auth_models.dart';
import 'package:team_management_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:team_management_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:team_management_app/core/storage/secure_storage.dart';

class MockAuthRepository extends Mock implements AuthRepository {}
class MockTokenStorage extends Mock implements TokenStorage {}

void main() {
  late AuthBloc authBloc;
  late MockAuthRepository mockAuthRepository;
  late MockTokenStorage mockTokenStorage;

  final tUser = UserData(id: '1', email: 'a@b.com', name: 'User');

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    mockTokenStorage = MockTokenStorage();
    authBloc = AuthBloc(mockAuthRepository, mockTokenStorage);
    registerFallbackValue(tUser);
  });

  tearDown(() {
    authBloc.close();
  });

  group('AuthBloc', () {
    test('initial state should be AuthInitial', () {
      expect(authBloc.state, AuthInitial());
    });

    test('AuthError props should contain message', () {
      final state = AuthError('test error');
      expect(state.props, ['test error']);
    });

    blocTest<AuthBloc, AuthState>(
      'should emit [AuthLoading, AuthAuthenticated] when login is successful',
      build: () {
        when(() => mockAuthRepository.login(
              email: any(named: 'email'),
              password: any(named: 'password'),
            )).thenAnswer((_) async => Right(LoginResponse(
              message: 'Success',
              token: 'test_token',
              user: tUser,
            )));
        when(() => mockTokenStorage.saveToken(any())).thenAnswer((_) async => {});
        return authBloc;
      },
      act: (bloc) => bloc.add(LoginRequested('a@b.com', 'password')),
      expect: () => [
        AuthLoading(),
        AuthAuthenticated(tUser),
      ],
      verify: (_) {
        verify(() => mockTokenStorage.saveToken('test_token')).called(1);
      },
    );

    blocTest<AuthBloc, AuthState>(
      'should emit [AuthLoading, AuthError] when login fails',
      build: () {
        when(() => mockAuthRepository.login(
              email: any(named: 'email'),
              password: any(named: 'password'),
            )).thenAnswer((_) async => const Left('Invalid credentials'));
        return authBloc;
      },
      act: (bloc) => bloc.add(LoginRequested('a@b.com', 'password')),
      expect: () => [
        AuthLoading(),
        AuthError('Invalid credentials'),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'should emit [AuthLoading] and then add LoginRequested when register is successful',
      build: () {
        when(() => mockAuthRepository.register(
              email: any(named: 'email'),
              password: any(named: 'password'),
              name: any(named: 'name'),
            )).thenAnswer((_) async => const Right(RegisterResponse(
              message: 'Success',
              userId: '1',
            )));
        
        // Return dummy success for login which is called after register
        when(() => mockAuthRepository.login(
              email: any(named: 'email'),
              password: any(named: 'password'),
            )).thenAnswer((_) async => Right(LoginResponse(
              message: 'Success',
              token: 'test_token',
              user: tUser,
            )));
        when(() => mockTokenStorage.saveToken(any())).thenAnswer((_) async => {});
        
        return authBloc;
      },
      act: (bloc) => bloc.add(RegisterRequested('a@b.com', 'password', 'User')),
      expect: () => [
        AuthLoading(),
        AuthAuthenticated(tUser),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'should emit [AuthLoading, AuthError] when register fails',
      build: () {
        when(() => mockAuthRepository.register(
              email: any(named: 'email'),
              password: any(named: 'password'),
              name: any(named: 'name'),
            )).thenAnswer((_) async => const Left('User already exists'));
        return authBloc;
      },
      act: (bloc) => bloc.add(RegisterRequested('a@b.com', 'password', 'User')),
      expect: () => [
        AuthLoading(),
        AuthError('User already exists'),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'should emit AuthUnauthenticated when LogoutRequested is added',
      build: () {
        when(() => mockTokenStorage.clearAll()).thenAnswer((_) async => {});
        return authBloc;
      },
      act: (bloc) => bloc.add(LogoutRequested()),
      expect: () => [
        AuthUnauthenticated(),
      ],
      verify: (_) {
        verify(() => mockTokenStorage.clearAll()).called(1);
      },
    );
  });
}
