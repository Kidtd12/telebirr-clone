import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';

import 'package:telebirr_clone_flutter/models/transaction_model.dart';
import 'package:telebirr_clone_flutter/providers/auth_provider.dart';
import 'package:telebirr_clone_flutter/services/wallet_service.dart';

class WalletState {
  final bool isLoading;
  final String? error;
  final double balance;
  final String walletNumber;
  final String fullName;
  final List<TransactionModel> transactions;

  const WalletState({
    required this.isLoading,
    this.error,
    required this.balance,
    required this.walletNumber,
    required this.fullName,
    required this.transactions,
  });

  WalletState copyWith({
    bool? isLoading,
    String? error,
    double? balance,
    String? walletNumber,
    String? fullName,
    List<TransactionModel>? transactions,
  }) {
    return WalletState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      balance: balance ?? this.balance,
      walletNumber: walletNumber ?? this.walletNumber,
      fullName: fullName ?? this.fullName,
      transactions: transactions ?? this.transactions,
    );
  }
}

final walletServiceProvider = Provider<WalletService>((ref) => WalletService());

final walletProvider = StateNotifierProvider<WalletNotifier, WalletState>((ref) {
  return WalletNotifier(ref.read(walletServiceProvider), ref);
});

class WalletNotifier extends StateNotifier<WalletState> {
  final WalletService _wallet;
  final Ref _ref;

  WalletNotifier(this._wallet, this._ref)
      : super(const WalletState(
          isLoading: false,
          balance: 0,
          walletNumber: '',
          fullName: '',
          transactions: [],
        ));

  Future<void> refresh() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final bal = await _wallet.getBalance();
      final txs = await _wallet.getTransactions();
      final balance = (bal['balance'] as num).toDouble();
      state = state.copyWith(
        isLoading: false,
        balance: balance,
        walletNumber: (bal['walletNumber'] ?? '').toString(),
        fullName: (bal['fullName'] ?? '').toString(),
        transactions: txs,
      );
    } catch (e) {
      if (e is DioException) {
        final code = e.response?.statusCode;
        if (code == 401 || code == 403) {
          await _ref.read(authProvider.notifier).logout();
          state = state.copyWith(
            isLoading: false,
            error: 'Session expired. Please sign in again.',
            balance: 0,
            walletNumber: '',
            fullName: '',
            transactions: const [],
          );
          return;
        }
        final serverMessage = e.response?.data is Map ? (e.response?.data['message']?.toString()) : null;
        state = state.copyWith(
          isLoading: false,
          error: (serverMessage == null || serverMessage.isEmpty)
              ? 'Unable to load wallet data right now. Please try again.'
              : serverMessage,
        );
        return;
      }
      state = state.copyWith(isLoading: false, error: 'Unable to load wallet data right now.');
    }
  }

  Future<void> sendMoney(String receiverPhone, double amount) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await _wallet.sendMoney(receiverPhoneNumber: receiverPhone, amount: amount);
      await refresh();
    } catch (e) {
      if (e is DioException) {
        final code = e.response?.statusCode;
        if (code == 401 || code == 403) {
          await _ref.read(authProvider.notifier).logout();
          state = state.copyWith(isLoading: false, error: 'Session expired. Please sign in again.');
          throw Exception('Session expired. Please sign in again.');
        }

        final serverMessage = e.response?.data is Map ? (e.response?.data['message']?.toString()) : null;
        final message = (serverMessage == null || serverMessage.isEmpty)
            ? 'Transfer failed. Please check recipient and amount.'
            : serverMessage;
        state = state.copyWith(isLoading: false, error: message);
        throw Exception(message);
      }

      state = state.copyWith(isLoading: false, error: 'Transfer failed. Please try again.');
      throw Exception('Transfer failed. Please try again.');
    }
  }
}

