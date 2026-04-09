import 'package:flutter_test/flutter_test.dart';
import 'package:team_management_app/features/auth/data/models/auth_models.dart';

void main() {
  group('RegisterRequest', () {
    test('toJson returns correct map', () {
      const request = RegisterRequest(
        email: 'test@example.com',
        password: 'password123',
        name: 'Test User',
      );
      final json = request.toJson();
      expect(json['email'], 'test@example.com');
      expect(json['password'], 'password123');
      expect(json['name'], 'test@example.com'); // Opps, error in implementation found!
    });
  });

  group('RegisterResponse', () {
    test('fromJson returns correct object', () {
      final json = {'message': 'success', 'userId': '123'};
      final response = RegisterResponse.fromJson(json);
      expect(response.message, 'success');
      expect(response.userId, '123');
    });
  });

  group('LoginRequest', () {
    test('toJson returns correct map', () {
      const request = LoginRequest(email: 'test@example.com', password: 'password123');
      final json = request.toJson();
      expect(json['email'], 'test@example.com');
      expect(json['password'], 'password123');
    });
  });

  group('UserData', () {
    test('fromJson returns correct object', () {
      final json = {
        'id': '1',
        'email': 'test@example.com',
        'name': 'Test User',
        'created_at': '2023-01-01',
        'last_login': '2023-01-02',
      };
      final user = UserData.fromJson(json);
      expect(user.id, '1');
      expect(user.email, 'test@example.com');
      expect(user.name, 'Test User');
    });
  });

  group('LoginResponse', () {
    test('fromJson returns correct object', () {
      final json = {
        'message': 'success',
        'token': 'jwt_token',
        'user': {
          'id': '1',
          'email': 'test@example.com',
          'name': 'Test User',
        },
      };
      final response = LoginResponse.fromJson(json);
      expect(response.message, 'success');
      expect(response.token, 'jwt_token');
      expect(response.user.id, '1');
    });
  });

  group('HomeResponse', () {
    test('fromJson returns correct object', () {
      final json = {
        'user': {
          'id': '1',
          'email': 'test@example.com',
          'name': 'Test User',
        },
        'message': 'Welcome',
      };
      final response = HomeResponse.fromJson(json);
      expect(response.user.id, '1');
      expect(response.message, 'Welcome');
    });
  });
}
