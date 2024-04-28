import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

@immutable
class AuthState {
  final bool isAuthenticated;
  const AuthState({required this.isAuthenticated});
}

class AuthStateNotifier extends AsyncNotifier<AuthState> {
  Future<AuthState> _fetchAuthState() async {
    const storage = FlutterSecureStorage();
    final token = await storage.read(key: 'auth_token');
    return AuthState(isAuthenticated: token != null);
  }

  @override
  Future<AuthState> build() async {
    return await _fetchAuthState();
  }

  Future<void> updateAuthStatus() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      return await _fetchAuthState();
    });
  }
}

final authStateProvider = AsyncNotifierProvider<AuthStateNotifier, AuthState>(() => AuthStateNotifier());
