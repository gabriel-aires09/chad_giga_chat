import 'package:chad_giga_chat/services/auth/auth_service.dart';
import 'package:chad_giga_chat/components/my_button.dart';
import 'package:chad_giga_chat/components/my_textfield.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _pwController = TextEditingController();

  // aperte para ir para página de registro
  final void Function()? onTap;

  LoginPage({super.key, required this.onTap});

  // Método login
  void login(BuildContext context) async {
    final authService = AuthService();

    // Realizar autenticação
    try {
      await authService.signInWithEmailPassword(
          _emailController.text, _pwController.text);
    }

    // Mostrar os erros de autenticação
    catch (e) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(e.toString()),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // logo
            Icon(Icons.message,
                size: 60, color: Theme.of(context).colorScheme.primary),

            const SizedBox(height: 50),
            // welcome back message
            Text("Welcome back, you've been missed!",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: 16,
                )),

            const SizedBox(height: 25),
            // email textfield
            MyTextfield(
              hintText: "Email",
              obscureText: false,
              controller: _emailController,
            ),

            const SizedBox(height: 10),
            // pw textfield
            MyTextfield(
              hintText: "Password",
              obscureText: true,
              controller: _pwController,
            ),

            const SizedBox(height: 25),

            // login button
            MyButton(
              text: 'Login', 
              onTap: () => login(context)),

            const SizedBox(height: 10),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Não é um membro?",
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.primary),
                ),
                GestureDetector(
                  onTap: onTap,
                  child: const Text("Register Now",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      )),
                ),
              ],
            )

            // register now
          ],
        ));
  }
}
