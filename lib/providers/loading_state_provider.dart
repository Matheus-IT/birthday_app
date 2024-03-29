import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoadingStateNotifier extends StateNotifier<bool> {
  LoadingStateNotifier() : super(false);

  void toggleLoading() {
    state = !state;
  }

  void setLoading(bool value) {
    state = value;
  }
}

final loadingStateProvider = StateNotifierProvider<LoadingStateNotifier, bool>((ref) => LoadingStateNotifier());
