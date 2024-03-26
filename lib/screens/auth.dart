import 'package:birthday_app/api_urls.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key, required this.title});

  final String title;

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  static const minPasswordLength = 8;
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoadingAuthentication = false;

  String? emailValidator(String? enteredEmail) {
    if (enteredEmail == null || enteredEmail.trim().isEmpty || !enteredEmail.contains('@')) {
      return 'Por favor, digite um endereço de email válido';
    }
    return null;
  }

  String? passwordValidator(String? enteredPassword) {
    if (enteredPassword == null || enteredPassword.trim().length < minPasswordLength) {
      return 'Senhas devem ter pelo menos $minPasswordLength caracteres';
    }
    return null;
  }

  void handleSubmitLoginForm() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    print('Email ${_emailController.text}');
    print('Password ${_passwordController.text}');

    final response = await http.post(
      ApiUrls.login,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': _emailController.text,
        'password': _passwordController.text,
      }),
    );

    if (response.statusCode == 200) {
      // If the server returns a 200 OK response, parse the JSON.
      print(jsonDecode(response.body)['token']);
    } else {
      // If the server did not return a 200 OK response, throw an exception.
      print('Failed to login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.only(
                  bottom: 20,
                ),
                width: 120,
                child: const CircleAvatar(
                  radius: 80,
                  backgroundImage: AssetImage('assets/images/app_logo.png'),
                ),
              ),
              Card(
                margin: const EdgeInsets.all(20),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextFormField(
                            decoration: const InputDecoration(
                              labelText: 'Email',
                            ),
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
                            autocorrect: false,
                            textCapitalization: TextCapitalization.none,
                            validator: emailValidator,
                            controller: _emailController,
                          ),
                          TextFormField(
                            decoration: const InputDecoration(
                              labelText: 'Senha',
                            ),
                            obscureText: true,
                            validator: passwordValidator,
                            controller: _passwordController,
                          ),
                          const SizedBox(height: 12),
                          if (_isLoadingAuthentication) const CircularProgressIndicator(),
                          if (!_isLoadingAuthentication)
                            ElevatedButton(
                              onPressed: handleSubmitLoginForm,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                              ),
                              child: const Text('Entrar'),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
