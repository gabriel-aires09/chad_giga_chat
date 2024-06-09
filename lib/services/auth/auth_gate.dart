import 'package:chad_giga_chat/services/auth/login_or_register.dart';
import 'package:chad_giga_chat/pages/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            // Verificar se o usuário está logado
            if (snapshot.hasData) {
              return HomePage();
            }
            // Caso não esteja logado, voltar para página de login_registro
            else {
              return const LoginOrRegister();
            }
          },
        ),
    );
  }
}
