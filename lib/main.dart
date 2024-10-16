import 'package:firebase_core/firebase_core.dart';
import 'package:login_service/bloc/authentication_bloc.dart';
import 'package:login_service/services/auth_service.dart';
import 'package:login_service/view/auth_page.dart';
import 'package:login_service/view/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        Provider<AuthService>(
          create: (context) => FirebaseAuthService(),
        ),
        BlocProvider(
          create: (context) => AuthenticationBloc(authService: context.read()),
        ),
      ],
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: MainPage(),
      ),
    );
  }
}

class MainPage extends StatelessWidget {
  const MainPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthenticationBloc, AuthState>(
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
        builder: (context, state) {
          if (state is AuthLoadingState) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is AuthSuccessState) {
            return const HomePage();
          }
          if (state is AuthLogoutState) {
            return const AuthPage();
          }
          return const AuthPage();
        },
      ),
    );
  }
}
