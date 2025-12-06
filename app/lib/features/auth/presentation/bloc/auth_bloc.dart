import 'package:app/features/auth/domain/usecases/login_use_cases.dart';
import 'package:app/features/auth/domain/usecases/register_use_cases.dart';
import 'package:app/features/auth/presentation/bloc/auth_event.dart';
import 'package:app/features/auth/presentation/bloc/auth_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final RegisterUseCase registerUseCase;
  final LoginUseCase loginUseCase;
  final _storage = FlutterSecureStorage();

  AuthBloc({required this.registerUseCase, required this.loginUseCase})
    : super(AuthInitial()) {
    on<RegisterEvent>(_onRegister);
    on<LoginEvent>(_onLogin);
  }

  Future<void> _onRegister(RegisterEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final user = await registerUseCase.call(
        event.fullname,
        event.email,
        event.password,
      );
      // Optionally store token if backend returns one
      if (user.token.isNotEmpty) {
        await _storage.write(key: 'token', value: user.token);
      }
      await _storage.write(key: 'userId', value: user.id);
      emit(AuthSuccess(message: "Registration Successful"));
    } catch (e) {
      print("Registration Error Log: $e");
      emit(AuthFailure(error: e.toString()));
    }
  }

  Future<void> _onLogin(LoginEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final user = await loginUseCase.call(event.email, event.password);
      await _storage.write(key: 'token', value: user.token);
      await _storage.write(key: 'userId', value: user.id);
      print('UserID: ${user.id}');
      print('token: ${user.token}');
      emit(AuthSuccess(message: "Login Successful"));
    } catch (e) {
      print("Login Error Log: $e");
      emit(AuthFailure(error: e.toString()));
    }
  }
}
