class ApiConstants {
  // Update this to your machine IP when testing on a physical device.
  // Example: http://192.168.1.10:5162
  static const baseUrl = 'http://localhost:5162';

  static const register = '/api/auth/register';
  static const requestOtp = '/api/auth/request-otp';
  static const verifyOtp = '/api/auth/verify-otp';
  static const login = '/api/auth/login';

  static const sendMoney = '/api/wallet/send';
  static const balance = '/api/wallet/balance';
  static const transactions = '/api/wallet/transactions';
}

