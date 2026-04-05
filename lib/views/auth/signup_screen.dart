import 'package:flutter/material.dart';

import '../../widgets/app_text_field.dart';
import '../main_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

    //final _formKey = GlobalKey<FormState>();
  @override
  State<SignupScreen> createState() => _SignupScreenState();}

  class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign Up')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key:_formKey,
            child: ListView(
            children: [
              const AppTextField(label: 'Name'),
              const SizedBox(height: 14),
              //const AppTextField(label: 'Email'),
              AppTextField(
             label: 'Email',
               validator: (value) {
             if (value == null || value.isEmpty) {
                 return "Email is required";
                            }

                      if (!value.toLowerCase().endsWith('@aastu.edu.et')) {
                                  return "Only @AASTU.edu.et emails allowed";
                                                               }

                                 return null;
                                    },
                                         ),
              const SizedBox(height: 14),
              const AppTextField(label: 'Password', obscureText: true),
              const SizedBox(height: 14),
              const AppTextField(label: 'Confirm Password', obscureText: true),
              const SizedBox(height: 22),
              FilledButton(onPressed: () {
                         if (_formKey.currentState!.validate()) {
                            Navigator.pushAndRemoveUntil(
                                      context,
                                   MaterialPageRoute(builder: (_) => const MainScreen()),
                                      (route) => false,
    );
  }
},
                //onPressed: () {
                 // Navigator.pushAndRemoveUntil(
                   // context,
                   // MaterialPageRoute(builder: (_) => const MainScreen()),
                    //(route) => false,
                 // );
                //},
                child: const Text('Sign Up'),
              ),
            ],
          ),
        ),
      ),
    ));
  }
}
