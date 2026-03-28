import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:telebirr_clone_flutter/core/constants/app_colors.dart';
import 'package:telebirr_clone_flutter/core/utils/formatters.dart';
import 'package:telebirr_clone_flutter/providers/wallet_provider.dart';

enum _TransferStatusKind { success, error }

class SendMoneyScreen extends ConsumerStatefulWidget {
  const SendMoneyScreen({super.key});

  @override
  ConsumerState<SendMoneyScreen> createState() => _SendMoneyScreenState();
}

class _SendMoneyScreenState extends ConsumerState<SendMoneyScreen> {
  final _phone = TextEditingController();
  final _amount = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String? _statusMessage;
  _TransferStatusKind? _statusKind;

  @override
  void dispose() {
    _phone.dispose();
    _amount.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final amount = double.tryParse(_amount.text.trim()) ?? 0;

    setState(() {
      _statusMessage = null;
      _statusKind = null;
    });

    try {
      await ref.read(walletProvider.notifier).sendMoney(_phone.text.trim(), amount);
      if (!mounted) return;
      setState(() {
        _statusKind = _TransferStatusKind.success;
        _statusMessage = 'Transfer completed successfully.';
      });
      _phone.clear();
      _amount.clear();
    } catch (e) {
      if (!mounted) return;
      final msg = e.toString().replaceFirst('Exception: ', '').trim();
      setState(() {
        _statusKind = _TransferStatusKind.error;
        _statusMessage = msg;
      });
    }
  }

  void _fillAmount(double value) {
    _amount.text = value.toStringAsFixed(0);
  }

  @override
  Widget build(BuildContext context) {
    final wallet = ref.watch(walletProvider);
    final showStatus = _statusMessage != null && _statusKind != null;
    final isSuccess = _statusKind == _TransferStatusKind.success;

    return Scaffold(
      appBar: AppBar(title: const Text('Send Money')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(18),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _phone,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(labelText: 'Receiver phone number'),
                  validator: (v) {
                    final value = (v ?? '').trim();
                    if (value.isEmpty) return 'Enter receiver phone';
                    if (value.length < 10) return 'Phone number looks too short';
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _amount,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(
                    labelText: 'Amount',
                    helperText: 'Available: ${Formatters.money(wallet.balance)}',
                  ),
                  validator: (v) {
                    final amount = double.tryParse((v ?? '').trim()) ?? 0;
                    if (amount <= 0) return 'Enter valid amount';
                    if (amount > wallet.balance) return 'Amount exceeds available balance';
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    ActionChip(label: const Text('ETB 1,000'), onPressed: () => _fillAmount(1000)),
                    ActionChip(label: const Text('ETB 5,000'), onPressed: () => _fillAmount(5000)),
                    ActionChip(label: const Text('ETB 10,000'), onPressed: () => _fillAmount(10000)),
                    ActionChip(label: const Text('ETB 25,000'), onPressed: () => _fillAmount(25000)),
                  ],
                ),
                const SizedBox(height: 12),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 220),
                  child: !showStatus
                      ? const SizedBox.shrink()
                      : Container(
                          width: double.infinity,
                          key: ValueKey<String>(_statusMessage!),
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: isSuccess
                                ? AppColors.success.withValues(alpha: 0.12)
                                : AppColors.danger.withValues(alpha: 0.10),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: isSuccess
                                  ? AppColors.success.withValues(alpha: 0.40)
                                  : AppColors.danger.withValues(alpha: 0.35),
                            ),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                isSuccess ? Icons.check_circle_rounded : Icons.error_rounded,
                                color: isSuccess ? AppColors.success : AppColors.danger,
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  _statusMessage!,
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                        color: isSuccess ? const Color(0xFF075E43) : const Color(0xFF8B1F1F),
                                        fontWeight: FontWeight.w600,
                                      ),
                                ),
                              ),
                            ],
                          ),
                        ),
                ),
                const SizedBox(height: 18),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: FilledButton(
                    onPressed: wallet.isLoading ? null : _send,
                    child: Text(wallet.isLoading ? 'Sending...' : 'Send'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

