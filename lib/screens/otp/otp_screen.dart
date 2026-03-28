import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:telebirr_clone_flutter/core/constants/app_routes.dart';
import 'package:telebirr_clone_flutter/providers/auth_provider.dart';

class OtpScreen extends ConsumerStatefulWidget {
  const OtpScreen({super.key});

  @override
  ConsumerState<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends ConsumerState<OtpScreen> {
  final _code = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _code.dispose();
    super.dispose();
  }

  Future<void> _verify(String phone) async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    try {
      await ref.read(authProvider.notifier).verifyOtp(phone, _code.text.trim());
      if (!mounted) return;
      Navigator.of(context).pushNamedAndRemoveUntil(AppRoutes.login, (_) => false);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Phone verified. Login now.')));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  Future<void> _resend(String phone) async {
    try {
      final devOtp = await ref.read(authProvider.notifier).requestOtp(phone);
      if (!mounted) return;
      if (devOtp != null && devOtp.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('DEV OTP: $devOtp')));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('OTP sent.')));
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  @override
  Widget build(BuildContext context) {
    final args = (ModalRoute.of(context)?.settings.arguments as Map?)?.cast<String, dynamic>() ?? {};
    final phone = (args['phone'] ?? '').toString();
    final devOtp = args['devOtp']?.toString();
    final auth = ref.watch(authProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('OTP Verification')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'We sent a code to $phone',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                ),
                if (devOtp != null && devOtp.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text('DEV OTP: $devOtp', style: Theme.of(context).textTheme.bodyMedium),
                ],
                const SizedBox(height: 16),
                TextFormField(
                  controller: _code,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'OTP code'),
                  validator: (v) => (v == null || v.trim().length < 4) ? 'Enter the OTP' : null,
                ),
                const SizedBox(height: 18),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: FilledButton(
                    onPressed: auth.isLoading ? null : () => _verify(phone),
                    child: Text(auth.isLoading ? 'Verifying...' : 'Verify'),
                  ),
                ),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: auth.isLoading ? null : () => _resend(phone),
                  child: const Text('Resend code'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

