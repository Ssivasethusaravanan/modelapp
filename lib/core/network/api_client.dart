import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:team_management_app/core/network/api_interceptor.dart';

@module
abstract class NetworkModule {
  @lazySingleton
  Dio provideDio(AuthInterceptor authInterceptor) {
    final dio = Dio(
      BaseOptions(
        baseUrl: 'https://teammanagementbackend.projectece5566.workers.dev',
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
      ),
    );
    dio.interceptors.addAll([
      authInterceptor,
      LogInterceptor(requestBody: true, responseBody: true),
    ]);
    return dio;
  }
}
