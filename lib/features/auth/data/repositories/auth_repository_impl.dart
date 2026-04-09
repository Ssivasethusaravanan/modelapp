import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:team_management_app/features/auth/data/models/auth_models.dart';
import 'package:team_management_app/features/auth/data/datasources/auth_datasource.dart';
import 'package:team_management_app/features/auth/domain/repositories/auth_repository.dart';

@Injectable(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this._datasource);
  final AuthDatasource _datasource;

  @override
  Future<Either<String, RegisterResponse>> register({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      final response = await _datasource.register(
        RegisterRequest(email: email, password: password, name: name),
      );
      return Right(response);
    } on DioException catch (e) {
      return Left(e.response?.data?['message'] as String? ?? 'Registration failed');
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, LoginResponse>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _datasource.login(
        LoginRequest(email: email, password: password),
      );
      return Right(response);
    } on DioException catch (e) {
      return Left(e.response?.data?['message'] as String? ?? 'Login failed');
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, HomeResponse>> getUserHome() async {
    try {
      final response = await _datasource.getHome();
      return Right(response);
    } on DioException catch (e) {
      return Left(e.response?.data?['message'] as String? ?? 'Failed to fetch details');
    } catch (e) {
      return Left(e.toString());
    }
  }
}
