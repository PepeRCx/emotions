import 'package:emotions/pages/auth/delete_account.dart';
import 'package:emotions/pages/home.dart';
import 'package:emotions/pages/auth/login.dart';
import 'package:emotions/pages/partner_setup.dart';
import 'package:emotions/pages/auth/password_change.dart';
import 'package:emotions/pages/auth/signup.dart';
import 'package:emotions/pages/auth/username_change.dart';
import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:emotions/firebase_options.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const ProviderScope(child: MainApp()));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'AmaticSC',
        textTheme: const TextTheme(
          bodyLarge: TextStyle(fontSize: 20),
        )
        ),
      home: const LoginPage(),
      routes: {
        '/signup': (context) => const SignupPage(),
        '/home': (context) => const HomePage(),
        '/login': (context) => const LoginPage(),
        '/partner_setup': (context) => const PartnerSetupPage(),
        '/password_change': (context) => const PasswordChangePage(),
        '/username_change': (context) => const UsernameChangePage(),
        '/delete_account': (context) => DeleteAccount(),
      },
    );
  }
}
