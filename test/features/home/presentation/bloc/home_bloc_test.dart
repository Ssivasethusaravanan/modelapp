import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:team_management_app/features/auth/data/models/auth_models.dart';
import 'package:team_management_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:team_management_app/features/home/presentation/bloc/home_bloc.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late HomeBloc homeBloc;
  late MockAuthRepository mockAuthRepository;

  const tUser = UserData(
    id: '1',
    email: 'test@test.com',
    name: 'Test User',
    createdAt: '2026-01-01',
    lastLogin: '2026-01-02',
  );

  final tHomeResponse = HomeResponse(
    message: 'Welcome back!',
    user: tUser,
  );

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    homeBloc = HomeBloc(mockAuthRepository);
  });

  tearDown(() {
    homeBloc.close();
  });

  group('HomeBloc', () {
    test('initial state should be HomeInitial', () {
      expect(homeBloc.state, HomeInitial());
    });

    blocTest<HomeBloc, HomeState>(
      'should emit [HomeLoading, HomeLoaded] when data is fetched successfully',
      build: () {
        when(() => mockAuthRepository.getUserHome())
            .thenAnswer((_) async => Right(tHomeResponse));
        return homeBloc;
      },
      act: (bloc) => bloc.add(GetHomeDataRequested()),
      expect: () => [
        HomeLoading(),
        HomeLoaded(tHomeResponse),
      ],
      verify: (_) {
        verify(() => mockAuthRepository.getUserHome()).called(1);
      },
    );

    blocTest<HomeBloc, HomeState>(
      'should emit [HomeLoading, HomeError] when fetching fails',
      build: () {
        when(() => mockAuthRepository.getUserHome())
            .thenAnswer((_) async => const Left('Server Error'));
        return homeBloc;
      },
      act: (bloc) => bloc.add(GetHomeDataRequested()),
      expect: () => [
        HomeLoading(),
        HomeError('Server Error'),
      ],
    );
  });
}
