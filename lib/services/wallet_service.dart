import 'package:dio/dio.dart';

import 'package:telebirr_clone_flutter/core/constants/api_constants.dart';
import 'package:telebirr_clone_flutter/models/transaction_model.dart';
import 'package:telebirr_clone_flutter/services/api_service.dart';

class WalletService {
  final Dio _dio = ApiService.dio;

  Future<Map<String, dynamic>> getBalance() async {
    final res = await _dio.get(ApiConstants.balance);
    return (res.data as Map).cast<String, dynamic>();
  }

  Future<List<TransactionModel>> getTransactions() async {
    final res = await _dio.get(ApiConstants.transactions);
    final list = (res.data as List).cast<dynamic>();
    return list
        .map((e) => TransactionModel.fromJson((e as Map).cast<String, dynamic>()))
        .toList();
  }

  Future<String> sendMoney({
    required String receiverPhoneNumber,
    required double amount,
  }) async {
    final res = await _dio.post(ApiConstants.sendMoney, data: {
      'receiverPhoneNumber': receiverPhoneNumber,
      'amount': amount,
    });
    final data = (res.data as Map).cast<String, dynamic>();
    return data['reference']?.toString() ?? '';
  }
}

