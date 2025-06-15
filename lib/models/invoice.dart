class Invoice {
  int? id;
  int studentId;
  String createdAt;

  Invoice({
    this.id,
    required this.studentId,
    required this.createdAt,
  });

  // Convert to Map for SQLite
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'studentId': studentId,
      'createdAt': createdAt,
    };
  }

  // Convert from Map to Invoice
  factory Invoice.fromMap(Map<String, dynamic> map) {
    return Invoice(
      id: map['id'],
      studentId: map['studentId'],
      createdAt: map['createdAt'],
    );
  }
}
