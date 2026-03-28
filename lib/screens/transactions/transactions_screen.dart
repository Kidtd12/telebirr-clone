import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:telebirr_clone_flutter/providers/wallet_provider.dart';
import 'package:telebirr_clone_flutter/widgets/transaction_tile.dart';

class TransactionsScreen extends ConsumerStatefulWidget {
  const TransactionsScreen({super.key});

  @override
  ConsumerState<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends ConsumerState<TransactionsScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(walletProvider.notifier).refresh());
  }

  @override
  Widget build(BuildContext context) {
    final wallet = ref.watch(walletProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Transactions')),
      body: RefreshIndicator(
        onRefresh: () => ref.read(walletProvider.notifier).refresh(),
        child: ListView(
          padding: const EdgeInsets.all(18),
          children: [
            if (wallet.error != null)
              Text(wallet.error!, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.red)),
            if (wallet.transactions.isEmpty && !wallet.isLoading)
              const Padding(
                padding: EdgeInsets.only(top: 30),
                child: Center(child: Text('No transactions yet.')),
              ),
            ...wallet.transactions.map((t) => TransactionTile(tx: t)),
          ],
        ),
      ),
    );
  }
}

