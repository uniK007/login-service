import 'package:login_service/bloc/authentication_bloc.dart';
import 'package:login_service/services/auth_service.dart';
import 'package:login_service/view/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthPage extends StatefulWidget {
  final bool isLoginPage;
  const AuthPage({super.key, this.isLoginPage = false});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  late bool isLoginPage;

  @override
  void initState() {
    super.initState();
    isLoginPage = widget.isLoginPage;
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _toggleAuthMode() {
    setState(() {
      isLoginPage = !isLoginPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthenticationBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthSuccessState) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("App Login Successful"),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => HomePage(userEmail: state.user.email),
            ),
          );
        }
        if (state is AuthFailureState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/three-tomoe.png',
                fit: BoxFit.cover,
                cacheHeight: 64,
                cacheWidth: 64,
              ),
              const SizedBox(height: 40),
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  context.read<AuthenticationBloc>().add(
                        AuthenticateEvent(
                          email: _emailController.text,
                          password: _passwordController.text,
                          userType: isLoginPage
                              ? UserType.existing
                              : UserType.newUser,
                        ),
                      );
                },
                child: Text(isLoginPage ? 'Login' : 'Sign Up'),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    isLoginPage
                        ? "Doesn't have an account yet?"
                        : "Already have an account!!",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextButton(
                    onPressed: _toggleAuthMode,
                    child: Text(
                      isLoginPage ? 'SignUp' : 'Login',
                      style: const TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
