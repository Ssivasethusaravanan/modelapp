import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:team_management_app/features/auth/data/models/auth_models.dart';
import 'package:team_management_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:team_management_app/core/storage/secure_storage.dart';

// --- Events ---
abstract class AuthEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoginRequested extends AuthEvent {
  LoginRequested(this.email, this.password);
  final String email;
  final String password;
  @override
  List<Object?> get props => [email, password];
}

class RegisterRequested extends AuthEvent {
  RegisterRequested(this.email, this.password, this.name);
  final String email;
  final String password;
  final String name;
  @override
  List<Object?> get props => [email, password, name];
}

class LogoutRequested extends AuthEvent {}

// --- States ---
abstract class AuthState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}
class AuthLoading extends AuthState {}
class AuthAuthenticated extends AuthState {
  AuthAuthenticated(this.user);
  final UserData user;
  @override
  List<Object?> get props => [user];
}
class AuthUnauthenticated extends AuthState {}
class AuthError extends AuthState {
  AuthError(this.message);
  final String message;
  @override
  List<Object?> get props => [message];
}

// --- BLoC ---
@lazySingleton
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(this._repository, this._storage) : super(AuthInitial()) {
    on<LoginRequested>(_onLogin);
    on<RegisterRequested>(_onRegister);
    on<LogoutRequested>(_onLogout);
  }

  final AuthRepository _repository;
  final TokenStorage _storage;

  Future<void> _onLogin(LoginRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final result = await _repository.login(email: event.email, password: event.password);
    await result.fold(
      (error) async => emit(AuthError(error)),
      (response) async {
        await _storage.saveToken(response.token);
        emit(AuthAuthenticated(response.user));
      },
    );
  }

  Future<void> _onRegister(RegisterRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final result = await _repository.register(
      email: event.email,
      password: event.password,
      name: event.name,
    );
    await result.fold(
      (error) async => emit(AuthError(error)),
      (response) async => add(LoginRequested(event.email, event.password)),
    );
  }

  Future<void> _onLogout(LogoutRequested event, Emitter<AuthState> emit) async {
    await _storage.clearAll();
    emit(AuthUnauthenticated());
  }
}
