import 'package:birthday_app/app_routes.dart';
import 'package:birthday_app/screens/auth.dart';
import 'package:birthday_app/screens/members.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  await dotenv.load();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Birthday Reminder',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      routes: {
        AppRoutes.authenticationScreen: (ctx) => const AuthScreen(),
        AppRoutes.membersScreen: (ctx) => const MembersScreen(),
      },
      home: const AuthScreen(),
    );
  }
}
