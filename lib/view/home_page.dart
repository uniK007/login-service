import 'package:login_service/bloc/authentication_bloc.dart';
import 'package:login_service/view/auth_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatelessWidget {
  final String? userEmail;
  const HomePage({super.key, this.userEmail = ''});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthenticationBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthLogoutState) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => const AuthPage(isLoginPage: true),
            ),
          );
        }
      },
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Welcome Captain!!\n$userEmail',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  context.read<AuthenticationBloc>().add(AuthLogOutEvent());
                },
                child: const Text('Sign Out'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
