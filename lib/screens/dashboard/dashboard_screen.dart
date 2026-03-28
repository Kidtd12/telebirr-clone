import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:telebirr_clone_flutter/core/constants/app_routes.dart';
import 'package:telebirr_clone_flutter/core/constants/app_colors.dart';
import 'package:telebirr_clone_flutter/providers/auth_provider.dart';
import 'package:telebirr_clone_flutter/providers/wallet_provider.dart';
import 'package:telebirr_clone_flutter/widgets/action_button.dart';
import 'package:telebirr_clone_flutter/widgets/transaction_tile.dart';
import 'package:telebirr_clone_flutter/widgets/wallet_card.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  int _footerIndex = 0;
  bool _isBalanceVisible = true;

  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(walletProvider.notifier).refresh());
  }

  void _onFooterTap(int index) {
    setState(() => _footerIndex = index);
    switch (index) {
      case 0:
        break;
      case 1:
        Navigator.of(context).pushNamed(AppRoutes.sendMoney);
        break;
      case 2:
        Navigator.of(context).pushNamed(AppRoutes.qrPayment);
        break;
      case 3:
        Navigator.of(context).pushNamed(AppRoutes.profile);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authProvider);
    final wallet = ref.watch(walletProvider);

    if (!auth.isAuthenticated) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        Navigator.of(context).pushNamedAndRemoveUntil(AppRoutes.login, (_) => false);
      });
    }

    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: 260,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFFDBF4FF), Color(0xFFF5FAFF)],
              ),
            ),
          ),
          RefreshIndicator(
            onRefresh: () => ref.read(walletProvider.notifier).refresh(),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(18, 14, 18, 18),
              children: [
                SafeArea(
                  bottom: false,
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Good day',
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.muted),
                            ),
                            Text(
                              wallet.fullName.isEmpty ? 'K-birr User' : wallet.fullName,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
                            ),
                          ],
                        ),
                      ),
                      IconButton.filledTonal(
                        onPressed: () => Navigator.of(context).pushNamed(AppRoutes.profile),
                        icon: const Icon(Icons.person_outline_rounded),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                WalletCard(
                  fullName: wallet.fullName.isEmpty ? '—' : wallet.fullName,
                  walletNumber: wallet.walletNumber.isEmpty ? '—' : wallet.walletNumber,
                  balance: wallet.balance,
                  isBalanceVisible: _isBalanceVisible,
                  onToggleVisibility: () => setState(() => _isBalanceVisible = !_isBalanceVisible),
                ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    Expanded(
                      child: ActionButton(
                        icon: Icons.send_rounded,
                        label: 'Send\nMoney',
                        onTap: () => Navigator.of(context).pushNamed(AppRoutes.sendMoney),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ActionButton(
                        icon: Icons.download_rounded,
                        label: 'Receive\nMoney',
                        onTap: () => Navigator.of(context).pushNamed(AppRoutes.receiveMoney),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ActionButton(
                        icon: Icons.qr_code_scanner_rounded,
                        label: 'Scan\nQR',
                        onTap: () => Navigator.of(context).pushNamed(AppRoutes.qrPayment),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ActionButton(
                        icon: Icons.receipt_long_rounded,
                        label: 'All\nTxns',
                        onTap: () => Navigator.of(context).pushNamed(AppRoutes.transactions),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.fromLTRB(14, 14, 14, 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.88),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.primaryDark.withValues(alpha: 0.08)),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Recent Transactions',
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
                            ),
                          ),
                          if (wallet.isLoading)
                            const SizedBox(
                              height: 18,
                              width: 18,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      if (wallet.error != null)
                        Text(wallet.error!, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.red)),
                      if (wallet.transactions.isEmpty && !wallet.isLoading)
                        Padding(
                          padding: const EdgeInsets.only(top: 18, bottom: 16),
                          child: Text(
                            'No transactions yet.',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                      ...wallet.transactions.take(6).map((t) => TransactionTile(tx: t)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _footerIndex,
        onDestinationSelected: _onFooterTap,
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_rounded), label: 'HOME'),
          NavigationDestination(icon: Icon(Icons.payments_rounded), label: 'PAYMENT'),
          NavigationDestination(icon: Icon(Icons.apps_rounded), label: 'APPS'),
          NavigationDestination(icon: Icon(Icons.person_rounded), label: 'ACCOUNT'),
        ],
      ),
    );
  }
}

