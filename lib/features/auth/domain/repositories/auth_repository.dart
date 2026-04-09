import 'package:dartz/dartz.dart';
import 'package:team_management_app/features/auth/data/models/auth_models.dart';

abstract class AuthRepository {
  Future<Either<String, RegisterResponse>> register({
    required String email,
    required String password,
    required String name,
  });

  Future<Either<String, LoginResponse>> login({
    required String email,
    required String password,
  });

  Future<Either<String, HomeResponse>> getUserHome();
}
