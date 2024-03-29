import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthState {
  final bool isAuthenticated;
  AuthState({required this.isAuthenticated});
}

class AuthStateNotifier extends StateNotifier<AuthState> {
  AuthStateNotifier() : super(AuthState(isAuthenticated: false));

  Future<void> checkAuthStatus() async {
    const storage = FlutterSecureStorage();
    final token = await storage.read(key: 'auth_token');
    state = AuthState(isAuthenticated: token != null);
  }
}

final authStateNotifier = StateNotifierProvider<AuthStateNotifier, AuthState>((ref) => AuthStateNotifier());
