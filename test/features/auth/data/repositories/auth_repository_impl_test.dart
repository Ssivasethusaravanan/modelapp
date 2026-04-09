import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:team_management_app/features/auth/data/datasources/auth_datasource.dart';
import 'package:team_management_app/features/auth/data/models/auth_models.dart';
import 'package:team_management_app/features/auth/data/repositories/auth_repository_impl.dart';

class MockAuthDatasource extends Mock implements AuthDatasource {}

void main() {
  setUpAll(() {
    registerFallbackValue(
      const RegisterRequest(email: '', password: '', name: ''),
    );
    registerFallbackValue(const LoginRequest(email: '', password: ''));
  });

  late AuthRepositoryImpl repository;
  late MockAuthDatasource mockDatasource;

  setUp(() {
    mockDatasource = MockAuthDatasource();
    repository = AuthRepositoryImpl(mockDatasource);
  });

  group('register', () {
    const tEmail = 'test@example.com';
    const tPassword = 'password123';
    const tName = 'Test User';
    const tRegisterRequest = RegisterRequest(
      email: tEmail,
      password: tPassword,
      name: tName,
    );
    const tRegisterResponse = RegisterResponse(message: 'Success', userId: '1');

    test('should return Right(RegisterResponse) when datasource success', () async {
      when(() => mockDatasource.register(any()))
          .thenAnswer((_) async => tRegisterResponse);

      final result = await repository.register(
        email: tEmail,
        password: tPassword,
        name: tName,
      );

      expect(result, const Right<String, RegisterResponse>(tRegisterResponse));
      verify(() => mockDatasource.register(tRegisterRequest)).called(1);
    });

    test('should return Left(message) when datasource throws DioException', () async {
      when(() => mockDatasource.register(any())).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: ''),
          response: Response(
            requestOptions: RequestOptions(path: ''),
            data: {'message': 'Error message'},
            statusCode: 400,
          ),
        ),
      );

      final result = await repository.register(
        email: tEmail,
        password: tPassword,
        name: tName,
      );

      expect(result, const Left<String, RegisterResponse>('Error message'));
    });
  });

  group('login', () {
    const tEmail = 'test@example.com';
    const tPassword = 'password123';
    const tLoginRequest = LoginRequest(email: tEmail, password: tPassword);
    const tUserData = UserData(id: '1', email: tEmail, name: 'Test User');
    const tLoginResponse = LoginResponse(
      message: 'Success',
      token: 'token',
      user: tUserData,
    );

    test('should return Right(LoginResponse) when datasource success', () async {
      when(() => mockDatasource.login(any()))
          .thenAnswer((_) async => tLoginResponse);

      final result = await repository.login(email: tEmail, password: tPassword);

      expect(result, const Right<String, LoginResponse>(tLoginResponse));
      verify(() => mockDatasource.login(tLoginRequest)).called(1);
    });
  });

  group('getUserHome', () {
    const tUserData = UserData(id: '1', email: 'test@example.com', name: 'Test User');
    const tHomeResponse = HomeResponse(user: tUserData, message: 'Welcome');

    test('should return Right(UserData) when datasource success', () async {
      when(() => mockDatasource.getHome()).thenAnswer((_) async => tHomeResponse);

      final result = await repository.getUserHome();

      expect(result, const Right<String, UserData>(tUserData));
      verify(() => mockDatasource.getHome()).called(1);
    });
  });
}
