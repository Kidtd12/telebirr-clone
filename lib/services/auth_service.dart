import 'package:dio/dio.dart';

import 'package:telebirr_clone_flutter/core/constants/api_constants.dart';
import 'package:telebirr_clone_flutter/models/user_model.dart';
import 'package:telebirr_clone_flutter/models/wallet_model.dart';
import 'package:telebirr_clone_flutter/services/api_service.dart';
import 'package:telebirr_clone_flutter/services/local_storage.dart';

class AuthService {
  final Dio _dio = ApiService.dio;

  Future<String?> register({
    required String phoneNumber,
    required String fullName,
    required String pin,
  }) async {
    final res = await _dio.post(ApiConstants.register, data: {
      'phoneNumber': phoneNumber,
      'fullName': fullName,
      'pin': pin,
    });

    await LocalStorage.setPendingPhone(phoneNumber);
    return (res.data is Map) ? (res.data['devOtpCode']?.toString()) : null;
  }

  Future<String?> requestOtp({required String phoneNumber}) async {
    final res = await _dio.post(ApiConstants.requestOtp, data: {
      'phoneNumber': phoneNumber,
    });
    return (res.data is Map) ? (res.data['devOtpCode']?.toString()) : null;
  }

  Future<void> verifyOtp({required String phoneNumber, required String code}) async {
    await _dio.post(ApiConstants.verifyOtp, data: {
      'phoneNumber': phoneNumber,
      'code': code,
    });
  }

  Future<({String token, UserModel user, WalletModel wallet})> login({
    required String phoneNumber,
    required String pin,
  }) async {
    final res = await _dio.post(ApiConstants.login, data: {
      'phoneNumber': phoneNumber,
      'pin': pin,
    });
    final data = (res.data as Map).cast<String, dynamic>();
    final token = data['accessToken']?.toString() ?? '';
    final user = UserModel.fromJson((data['user'] as Map).cast<String, dynamic>());
    final wallet = WalletModel.fromJson((data['wallet'] as Map).cast<String, dynamic>());

    await LocalStorage.setToken(token);
    return (token: token, user: user, wallet: wallet);
  }

  Future<void> logout() async {
    await LocalStorage.clear();
  }
}

