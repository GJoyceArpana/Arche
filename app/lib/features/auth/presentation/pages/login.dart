import 'package:app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:app/features/auth/presentation/bloc/auth_event.dart';
import 'package:app/features/auth/presentation/bloc/auth_state.dart';
import 'package:app/features/auth/presentation/widgets/auth_button.dart';
import 'package:app/features/auth/presentation/widgets/auth_input_field.dart';
import 'package:app/features/auth/presentation/widgets/auth_pasword_field.dart';
import 'package:app/features/auth/presentation/widgets/login_prompt.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'signup.dart'; // Navigate to sign up screen

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool showPassword = false;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _login() {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter email and password')),
      );
      return;
    }

    // For now just log them; later add real auth.
    print('Email: $email - Password: $password');
  }

  void _onLogin() {
    BlocProvider.of<AuthBloc>(context).add(
      LoginEvent(
        email: _emailController.text,
        password: _passwordController.text,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: const LinearGradient(
                          colors: [Color(0xFF6A5AE0), Color(0xFF9C4BFF)],
                        ),
                      ),
                      child: const Icon(
                        Icons.auto_graph,
                        size: 40,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      "Welcome Back",
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      "Sign in to continue your learning journey",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.black54),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              // EMAIL
              _label("Email Address"),
              AuthInputField(
                hint: "you@example.com",
                icon: Icons.email,
                controller: _emailController,
              ),
              const SizedBox(height: 18),

              // PASSWORD
              _label("Password"),
              AuthPaswordField(
                hint: "Create a strong password",
                controller: _passwordController,
                isVisible: showPassword,
                onToggle: () => setState(() => showPassword = !showPassword),
              ),

              const SizedBox(height: 22),

             BlocConsumer<AuthBloc, AuthState>(
                builder: (context, state){
                  if(state is AuthLoading){
                    return Center(child: CircularProgressIndicator(),);
                  }
                  return AuthButton(text: "Login", onPressed: _onLogin);
                },
                listener: (context, state) {
                  if (state is AuthSuccess) {
                    
                    Navigator.pushNamed(context, '/dashboard');
                  } else if (state is AuthFailure) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(state.error)),
                    );
                  }
                },
              ),

              const SizedBox(height: 5),

              LoginPrompt(
                text: "Don't have an account? Create account",
                onTap: () {},
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // LABEL WIDGET
  Widget _label(String text) {
    return Text(
      text,
      style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
    );
  }

  // “Create account” text link -> SignUp
  Widget _buildRegisterButton() {
    return Center(
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const SignUpScreen()),
          );
        },
        child: const Text(
          "Don't have an account? Create account",
          style: TextStyle(color: Colors.grey),
        ),
      ),
    );
  }
}
