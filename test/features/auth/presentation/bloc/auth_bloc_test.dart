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
