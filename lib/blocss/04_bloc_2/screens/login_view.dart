import 'package:bloc_learning/blocss/04_bloc_2/screens/email_text_field.dart';
import 'package:bloc_learning/blocss/04_bloc_2/screens/login_button.dart';
import 'package:bloc_learning/blocss/04_bloc_2/screens/password_text_field.dart';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_hooks/flutter_hooks.dart';

class LoginScreen extends HookWidget {
  final OnLoginTapped onLoginTapped;

  const LoginScreen({
    required this.onLoginTapped,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          EmailTextField(emailController: emailController),
          PasswordTextField(passwordController: passwordController),
          LoginButton(
            emailController: emailController,
            passwordController: passwordController,
            onLoginTapped: onLoginTapped,
          ),
        ],
      ),
    );
  }
}
