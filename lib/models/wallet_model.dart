class WalletModel {
  final String id;
  final String walletNumber;
  final double balance;

  const WalletModel({
    required this.id,
    required this.walletNumber,
    required this.balance,
  });

  factory WalletModel.fromJson(Map<String, dynamic> json) {
    final bal = json['balance'];
    return WalletModel(
      id: (json['id'] ?? '').toString(),
      walletNumber: (json['walletNumber'] ?? '').toString(),
      balance: bal is num ? bal.toDouble() : double.tryParse(bal.toString()) ?? 0,
    );
  }
}

