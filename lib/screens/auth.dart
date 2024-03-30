import 'package:birthday_app/api_urls.dart';
import 'package:birthday_app/app_routes.dart';
import 'package:birthday_app/components/snackbar.dart';
import 'package:birthday_app/http_client.dart';
import 'package:birthday_app/providers/loading_state_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';

import 'package:http/http.dart';

class AuthScreen extends ConsumerStatefulWidget {
  const AuthScreen({super.key});

  @override
  ConsumerState<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthScreen> {
  static const minPasswordLength = 8;
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

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

    final context = _formKey.currentContext!;

    try {
      ref.read(loadingStateProvider.notifier).setLoading(true);

      final response = await HttpClient.post(ApiUrls.login, {
        'email': _emailController.text,
        'password': _passwordController.text,
      });

      if (response.statusCode == 200) {
        final token = jsonDecode(response.body)['token'];
        const storage = FlutterSecureStorage();

        await storage.write(key: 'auth_token', value: token);
        if (context.mounted) Navigator.of(context).pushReplacementNamed(AppRoutes.membersScreen);
      } else {
        if (context.mounted) showSnackbar(context, 'Email ou senha inválidos');
      }
    } on ClientException {
      if (context.mounted) {
        showSnackbar(
          context,
          'Não foi possível conectar com o servidor. Você está realmente conectado com a internet?',
          durationSeconds: 6,
        );
      }
    } catch (e) {
      debugPrint('error: $e');
    } finally {
      ref.read(loadingStateProvider.notifier).setLoading(false);
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
                          Consumer(builder: (ctx, ref, child) {
                            final isLoading = ref.watch(loadingStateProvider);
                            return isLoading
                                ? const CircularProgressIndicator()
                                : ElevatedButton(
                                    onPressed: handleSubmitLoginForm,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                                    ),
                                    child: const Text('Entrar'),
                                  );
                          }),
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
