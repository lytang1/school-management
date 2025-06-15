class Expense {
  final int? id;
  final String description;
  final double amount;
  final String createdAt; // Stored as ISO 8601 string

  Expense({
    this.id,
    required this.description,
    required this.amount,
    required this.createdAt,
  });

  // Convert to Map for SQLite
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'description': description,
      'amount': amount,
      'createdAt': createdAt,
    };
  }

  // Convert from Map to Expense
  factory Expense.fromMap(Map<String, dynamic> map) {
    return Expense(
      id: map['id'],
      description: map['description'],
      amount: map['amount'],
      createdAt: map['createdAt'],
    );
  }
}
