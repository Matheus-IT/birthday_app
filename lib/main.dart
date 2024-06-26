import 'package:birthday_app/app_routes.dart';
import 'package:birthday_app/providers/auth_state_provider.dart';
import 'package:birthday_app/screens/auth.dart';
import 'package:birthday_app/screens/members.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  await dotenv.load();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);

    return MaterialApp(
      title: 'Birthday Reminder',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      routes: {
        AppRoutes.authenticationScreen: (ctx) => const AuthScreen(),
        AppRoutes.membersScreen: (ctx) => const MembersScreen(),
      },
      home: authState.when(
        data: (authState) {
          return authState.isAuthenticated ? const MembersScreen() : const AuthScreen();
        },
        loading: () {
          return const CircularProgressIndicator();
        },
        error: (error, stackTrace) {
          return Text('Error: $error');
        },
      ),
    );
  }
}
