import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'package:telebirr_clone_flutter/core/utils/formatters.dart';

class WalletCard extends StatelessWidget {
  final String fullName;
  final String walletNumber;
  final double balance;
  final bool isBalanceVisible;
  final VoidCallback onToggleVisibility;

  const WalletCard({
    super.key,
    required this.fullName,
    required this.walletNumber,
    required this.balance,
    required this.isBalanceVisible,
    required this.onToggleVisibility,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          colors: [Color(0xFF0CA3A3), Color(0xFF0B5DA4)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0B4F81).withValues(alpha: 0.32),
            blurRadius: 24,
            offset: const Offset(0, 14),
          )
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.14),
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(color: Colors.white.withValues(alpha: 0.20)),
                  ),
                  child: Text(
                    'PRIMARY WALLET',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: Colors.white,
                          letterSpacing: 0.7,
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: onToggleVisibility,
                  splashRadius: 20,
                  icon: Icon(
                    isBalanceVisible ? Icons.visibility_off_rounded : Icons.visibility_rounded,
                    color: Colors.white.withValues(alpha: 0.95),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              'Available Balance',
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: Colors.white.withValues(alpha: 0.88),
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              isBalanceVisible ? Formatters.money(balance) : 'ETB ••••••••',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                  ),
            ),
            const SizedBox(height: 4),
            Text(
              isBalanceVisible ? '≈ ${Formatters.moneyUsd(balance)}' : '≈ USD •••••',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.white.withValues(alpha: 0.86),
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: Text(
                    fullName,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Colors.white.withValues(alpha: 0.94),
                          fontWeight: FontWeight.w700,
                        ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.14),
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(color: Colors.white.withValues(alpha: 0.20)),
                  ),
                  child: Text(
                    walletNumber,
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: Colors.white,
                          letterSpacing: 0.3,
                        ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    )
        .animate()
        .fadeIn(duration: 250.ms)
        .slideY(begin: 0.08, end: 0, duration: 250.ms, curve: Curves.easeOut);
  }
}

