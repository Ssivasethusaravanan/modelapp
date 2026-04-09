import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:team_management_app/core/network/api_interceptor.dart';
import 'package:team_management_app/core/storage/secure_storage.dart';

class MockTokenStorage extends Mock implements TokenStorage {}
class MockRequestInterceptorHandler extends Mock implements RequestInterceptorHandler {}
class MockErrorInterceptorHandler extends Mock implements ErrorInterceptorHandler {}

void main() {
  late AuthInterceptor interceptor;
  late MockTokenStorage mockTokenStorage;
  late MockRequestInterceptorHandler mockRequestHandler;
  late MockErrorInterceptorHandler mockErrorHandler;

  setUp(() {
    mockTokenStorage = MockTokenStorage();
    interceptor = AuthInterceptor(mockTokenStorage);
    mockRequestHandler = MockRequestInterceptorHandler();
    mockErrorHandler = MockErrorInterceptorHandler();
  });

  group('AuthInterceptor', () {
    test('onRequest should add Authorization header when token is available', () async {
      const tToken = 'test_token';
      when(() => mockTokenStorage.getToken()).thenAnswer((_) async => tToken);
      
      final options = RequestOptions(path: '/test', headers: {});
      
      await interceptor.onRequest(options, mockRequestHandler);

      expect(options.headers['Authorization'], 'Bearer $tToken');
      expect(options.headers['Content-Type'], 'application/json');
      verify(() => mockRequestHandler.next(options)).called(1);
    });

    test('onRequest should not add Authorization header when token is null', () async {
      when(() => mockTokenStorage.getToken()).thenAnswer((_) async => null);
      
      final options = RequestOptions(path: '/test', headers: {});
      
      await interceptor.onRequest(options, mockRequestHandler);

      expect(options.headers.containsKey('Authorization'), false);
      expect(options.headers['Content-Type'], 'application/json');
      verify(() => mockRequestHandler.next(options)).called(1);
    });

    test('onError should clear token and call next when status code is 401', () async {
      when(() => mockTokenStorage.clearAll()).thenAnswer((_) async => {});
      
      final err = DioException(
        requestOptions: RequestOptions(path: '/test'),
        response: Response(
          requestOptions: RequestOptions(path: '/test'),
          statusCode: 401,
        ),
      );

      await interceptor.onError(err, mockErrorHandler);

      verify(() => mockTokenStorage.clearAll()).called(1);
      verify(() => mockErrorHandler.next(err)).called(1);
    });

    test('onError should only call next when status code is not 401', () async {
      final err = DioException(
        requestOptions: RequestOptions(path: '/test'),
        response: Response(
          requestOptions: RequestOptions(path: '/test'),
          statusCode: 500,
        ),
      );

      await interceptor.onError(err, mockErrorHandler);

      verifyNever(() => mockTokenStorage.clearAll());
      verify(() => mockErrorHandler.next(err)).called(1);
    });
  });
}
