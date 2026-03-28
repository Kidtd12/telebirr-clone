class TransactionModel {
  final String id;
  final String direction; // Sent/Received
  final String counterpartyPhoneNumber;
  final double amount;
  final String status;
  final DateTime createdAt;

  const TransactionModel({
    required this.id,
    required this.direction,
    required this.counterpartyPhoneNumber,
    required this.amount,
    required this.status,
    required this.createdAt,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    final amount = json['amount'];
    return TransactionModel(
      id: (json['id'] ?? '').toString(),
      direction: (json['direction'] ?? '').toString(),
      counterpartyPhoneNumber: (json['counterpartyPhoneNumber'] ?? '').toString(),
      amount: amount is num ? amount.toDouble() : double.tryParse(amount.toString()) ?? 0,
      status: (json['status'] ?? '').toString(),
      createdAt: DateTime.tryParse((json['createdAt'] ?? '').toString()) ?? DateTime.now(),
    );
  }
}

