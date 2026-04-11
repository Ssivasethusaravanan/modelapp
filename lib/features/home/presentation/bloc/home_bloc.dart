import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:team_management_app/features/auth/data/models/auth_models.dart';
import 'package:team_management_app/features/auth/domain/repositories/auth_repository.dart';

// --- Events ---
abstract class HomeEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class GetHomeDataRequested extends HomeEvent {}

// --- States ---
abstract class HomeState extends Equatable {
  @override
  List<Object?> get props => [];
}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  HomeLoaded(this.homeData);
  final HomeResponse homeData;
  @override
  List<Object?> get props => [homeData];
}

class HomeError extends HomeState {
  HomeError(this.message);
  final String message;
  @override
  List<Object?> get props => [message];
}

// --- BLoC ---
@injectable
class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc(this._repository) : super(HomeInitial()) {
    on<GetHomeDataRequested>(_onGetHomeData);
  }

  final AuthRepository _repository;

  Future<void> _onGetHomeData(
      GetHomeDataRequested event, Emitter<HomeState> emit) async {
    emit(HomeLoading());
    final result = await _repository.getUserHome();
    result.fold(
      (error) => emit(HomeError(error)),
      (data) => emit(HomeLoaded(data)),
    );
  }
}
