// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dio/dio.dart' as _i361;
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as _i558;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

import 'core/network/api_client.dart' as _i871;
import 'core/network/api_interceptor.dart' as _i729;
import 'core/storage/secure_storage.dart' as _i682;
import 'features/auth/data/datasources/auth_datasource.dart' as _i986;
import 'features/auth/data/repositories/auth_repository_impl.dart' as _i111;
import 'features/auth/domain/repositories/auth_repository.dart' as _i1015;
import 'features/auth/presentation/bloc/auth_bloc.dart' as _i363;
import 'features/home/presentation/bloc/home_bloc.dart' as _i123;
import 'routing/app_router.dart' as _i325;

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final storageModule = _$StorageModule();
    final networkModule = _$NetworkModule();
    gh.lazySingleton<_i558.FlutterSecureStorage>(
        () => storageModule.secureStorage);
    gh.singleton<_i682.TokenStorage>(
        () => _i682.TokenStorage(gh<_i558.FlutterSecureStorage>()));
    gh.lazySingleton<_i729.AuthInterceptor>(
        () => _i729.AuthInterceptor(gh<_i682.TokenStorage>()));
    gh.lazySingleton<_i361.Dio>(
        () => networkModule.provideDio(gh<_i729.AuthInterceptor>()));
    gh.factory<_i986.AuthDatasource>(
        () => _i986.AuthDatasource(gh<_i361.Dio>()));
    gh.factory<_i1015.AuthRepository>(
        () => _i111.AuthRepositoryImpl(gh<_i986.AuthDatasource>()));
    gh.lazySingleton<_i363.AuthBloc>(() => _i363.AuthBloc(
          gh<_i1015.AuthRepository>(),
          gh<_i682.TokenStorage>(),
        ));
    gh.lazySingleton<_i325.AppRouter>(
        () => _i325.AppRouter(gh<_i363.AuthBloc>()));
    gh.factory<_i123.HomeBloc>(
        () => _i123.HomeBloc(gh<_i1015.AuthRepository>()));
    return this;
  }
}

class _$StorageModule extends _i871.StorageModule {}

class _$NetworkModule extends _i871.NetworkModule {}
