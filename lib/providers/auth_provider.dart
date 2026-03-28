import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:telebirr_clone_flutter/models/user_model.dart';
import 'package:telebirr_clone_flutter/models/wallet_model.dart';
import 'package:telebirr_clone_flutter/services/auth_service.dart';
import 'package:telebirr_clone_flutter/services/local_storage.dart';

class AuthState {
  final bool isLoading;
  final String? error;
  final String? token;
  final UserModel? user;
  final WalletModel? wallet;
  final String? pendingPhoneNumber;

  const AuthState({
    required this.isLoading,
    this.error,
    this.token,
    this.user,
    this.wallet,
    this.pendingPhoneNumber,
  });

  bool get isAuthenticated => token != null && token!.isNotEmpty;

  AuthState copyWith({
    bool? isLoading,
    String? error,
    String? token,
    UserModel? user,
    WalletModel? wallet,
    String? pendingPhoneNumber,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      token: token ?? this.token,
      user: user ?? this.user,
      wallet: wallet ?? this.wallet,
      pendingPhoneNumber: pendingPhoneNumber ?? this.pendingPhoneNumber,
    );
  }
}

final authServiceProvider = Provider<AuthService>((ref) => AuthService());

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(ref.read(authServiceProvider));
});

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthService _auth;

  AuthNotifier(this._auth) : super(const AuthState(isLoading: false)) {
    _hydrate();
  }

  Future<void> _hydrate() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final token = LocalStorage.token;
      final pendingPhone = LocalStorage.pendingPhone;
      state = state.copyWith(
        isLoading: false,
        token: token,
        pendingPhoneNumber: pendingPhone,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<String?> register(String phone, String fullName, String pin) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final devOtp = await _auth.register(phoneNumber: phone, fullName: fullName, pin: pin);
      state = state.copyWith(isLoading: false, pendingPhoneNumber: phone);
      return devOtp;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      rethrow;
    }
  }

  Future<String?> requestOtp(String phone) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final devOtp = await _auth.requestOtp(phoneNumber: phone);
      state = state.copyWith(isLoading: false, pendingPhoneNumber: phone);
      return devOtp;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      rethrow;
    }
  }

  Future<void> verifyOtp(String phone, String code) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await _auth.verifyOtp(phoneNumber: phone, code: code);
      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      rethrow;
    }
  }

  Future<void> login(String phone, String pin) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final res = await _auth.login(phoneNumber: phone, pin: pin);
      state = state.copyWith(
        isLoading: false,
        token: res.token,
        user: res.user,
        wallet: res.wallet,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      rethrow;
    }
  }

  Future<void> logout() async {
    state = state.copyWith(isLoading: true, error: null);
    await _auth.logout();
    state = const AuthState(isLoading: false);
  }
}

