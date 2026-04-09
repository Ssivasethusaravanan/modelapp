import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:team_management_app/core/storage/secure_storage.dart';

class MockFlutterSecureStorage extends Mock implements FlutterSecureStorage {}

void main() {
  late TokenStorage tokenStorage;
  late MockFlutterSecureStorage mockSecureStorage;

  setUp(() {
    mockSecureStorage = MockFlutterSecureStorage();
    tokenStorage = TokenStorage(mockSecureStorage);
  });

  group('TokenStorage', () {
    const tToken = 'test_token';
    const tTokenKey = 'auth_token';

    test('saveToken should call write on secure storage', () async {
      when(() => mockSecureStorage.write(
            key: any(named: 'key'),
            value: any(named: 'value'),
            aOptions: any(named: 'aOptions'),
            iOptions: any(named: 'iOptions'),
          )).thenAnswer((_) async => {});

      await tokenStorage.saveToken(tToken);

      verify(() => mockSecureStorage.write(
            key: tTokenKey,
            value: tToken,
            aOptions: any(named: 'aOptions'),
            iOptions: any(named: 'iOptions'),
          )).called(1);
    });

    test('getToken should call read on secure storage', () async {
      when(() => mockSecureStorage.read(
            key: any(named: 'key'),
            aOptions: any(named: 'aOptions'),
            iOptions: any(named: 'iOptions'),
          )).thenAnswer((_) async => tToken);

      final result = await tokenStorage.getToken();

      expect(result, tToken);
      verify(() => mockSecureStorage.read(
            key: tTokenKey,
            aOptions: any(named: 'aOptions'),
            iOptions: any(named: 'iOptions'),
          )).called(1);
    });

    test('clearAll should call deleteAll on secure storage', () async {
      when(() => mockSecureStorage.deleteAll(
            aOptions: any(named: 'aOptions'),
            iOptions: any(named: 'iOptions'),
          )).thenAnswer((_) async => {});

      await tokenStorage.clearAll();

      verify(() => mockSecureStorage.deleteAll(
            aOptions: any(named: 'aOptions'),
            iOptions: any(named: 'iOptions'),
          )).called(1);
    });
  });
}
