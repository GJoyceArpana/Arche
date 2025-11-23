import 'package:app/dashboard.dart';
import 'package:app/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:app/features/auth/data/repostories/auth_repository_impl.dart';
import 'package:app/features/auth/domain/repositories/auth_repository.dart';
import 'package:app/features/auth/domain/usecases/login_use_cases.dart';
import 'package:app/features/auth/domain/usecases/register_use_cases.dart';
import 'package:app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:app/features/auth/presentation/pages/login.dart';
import 'package:app/features/auth/presentation/pages/signup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'home_page.dart';

void main() {
  final authRepository = AuthRepositoryImpl(
    authRemoteDataSource: AuthRemoteDataSource(),
  );
  runApp(ArcheApp(authRepository: authRepository));
}

class ArcheApp extends StatelessWidget {
  final AuthRepositoryImpl authRepository;
  const ArcheApp({super.key, required this.authRepository});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => AuthBloc(
            registerUseCase: RegisterUseCase(repository: authRepository),
            loginUseCase: LoginUseCase(repository: authRepository),
          ),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: HomePage(),
        routes: {
          '/login': (_) => LoginPage(),
          '/register': (_) => SignUpScreen(),
          '/dashboard': (_) => DashboardScreen(),
        },
      ),
    );
  }
}
