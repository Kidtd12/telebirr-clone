import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:telebirr_clone_flutter/core/constants/app_routes.dart';
import 'package:telebirr_clone_flutter/core/theme/app_theme.dart';
import 'package:telebirr_clone_flutter/screens/dashboard/dashboard_screen.dart';
import 'package:telebirr_clone_flutter/screens/login/login_screen.dart';
import 'package:telebirr_clone_flutter/screens/otp/otp_screen.dart';
import 'package:telebirr_clone_flutter/screens/profile/profile_screen.dart';
import 'package:telebirr_clone_flutter/screens/qr_payment/qr_payment_screen.dart';
import 'package:telebirr_clone_flutter/screens/receive_money/receive_money_screen.dart';
import 'package:telebirr_clone_flutter/screens/register/register_screen.dart';
import 'package:telebirr_clone_flutter/screens/send_money/send_money_screen.dart';
import 'package:telebirr_clone_flutter/screens/splash/splash_screen.dart';
import 'package:telebirr_clone_flutter/screens/transactions/transactions_screen.dart';
import 'package:telebirr_clone_flutter/services/local_storage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocalStorage.init();
  runApp(const ProviderScope(child: App()));
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      initialRoute: AppRoutes.splash,
      routes: {
        AppRoutes.splash: (_) => const SplashScreen(),
        AppRoutes.login: (_) => const LoginScreen(),
        AppRoutes.register: (_) => const RegisterScreen(),
        AppRoutes.otp: (_) => const OtpScreen(),
        AppRoutes.dashboard: (_) => const DashboardScreen(),
        AppRoutes.sendMoney: (_) => const SendMoneyScreen(),
        AppRoutes.receiveMoney: (_) => const ReceiveMoneyScreen(),
        AppRoutes.qrPayment: (_) => const QrPaymentScreen(),
        AppRoutes.transactions: (_) => const TransactionsScreen(),
        AppRoutes.profile: (_) => const ProfileScreen(),
      },
    );
  }
}

