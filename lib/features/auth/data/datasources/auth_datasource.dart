import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';
import 'package:team_management_app/features/auth/data/models/auth_models.dart';

part 'auth_datasource.g.dart';

@RestApi()
@injectable
abstract class AuthDatasource {
  @factoryMethod
  factory AuthDatasource(Dio dio) = _AuthDatasource;

  @POST('/auth/register')
  Future<RegisterResponse> register(@Body() RegisterRequest request);

  @POST('/auth/login')
  Future<LoginResponse> login(@Body() LoginRequest request);

  @GET('/api/home')
  Future<HomeResponse> getHome();
}
