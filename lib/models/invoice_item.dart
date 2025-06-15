class InvoiceItem {
  int? id;
  int invoiceId;
  String itemName;
  double amount;

  InvoiceItem({
    this.id,
    required this.invoiceId,
    required this.itemName,
    required this.amount,
  });

  // Convert to Map for SQLite
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'invoiceId': invoiceId,
      'itemName': itemName,
      'amount': amount,
    };
  }

  // Convert from Map to InvoiceItem
  factory InvoiceItem.fromMap(Map<String, dynamic> map) {
    return InvoiceItem(
      id: map['id'],
      invoiceId: map['invoiceId'],
      itemName: map['itemName'],
      amount: map['amount'],
    );
  }
}
