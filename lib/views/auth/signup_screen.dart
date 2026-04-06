import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../routes/app_router.dart';
import '../../widgets/app_text_field.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign Up')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: ListView(
            children: [
              const AppTextField(label: 'Name'),
              const SizedBox(height: 14),
              const AppTextField(label: 'Email'),
              const SizedBox(height: 14),
              const AppTextField(label: 'Password', obscureText: true),
              const SizedBox(height: 14),
              const AppTextField(label: 'Confirm Password', obscureText: true),
              const SizedBox(height: 22),
              FilledButton(
                onPressed: () {
                  context.go(AppRoutes.home);
                },
                child: const Text('Sign Up'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
