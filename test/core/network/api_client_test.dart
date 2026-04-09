import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:team_management_app/core/network/api_client.dart';
import 'package:team_management_app/core/network/api_interceptor.dart';
import 'package:team_management_app/core/storage/secure_storage.dart';

class MockAuthInterceptor extends Mock implements AuthInterceptor {}
class MockTokenStorage extends Mock implements TokenStorage {}

void main() {
  group('Modules Coverage', () {
    test('StorageModule provides FlutterSecureStorage', () {
      final module = StorageModuleImpl(); // We'll need a way to instantiate it or just test the logic
      final storage = module.secureStorage;
      expect(storage, isA<FlutterSecureStorage>());
    });

    test('NetworkModule provides Dio with interceptors', () {
      final module = NetworkModuleImpl();
      final mockInterceptor = MockAuthInterceptor();
      final dio = module.provideDio(mockInterceptor);
      
      expect(dio.options.baseUrl, contains('workers.dev'));
      expect(dio.interceptors, contains(mockInterceptor));
      expect(dio.interceptors.any((i) => i is LogInterceptor), true);
    });
  });
}

// Concrete implementations of the abstract modules for testing purposes
class StorageModuleImpl extends StorageModule {}
class NetworkModuleImpl extends NetworkModule {}
