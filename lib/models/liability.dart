class Liability {
  final int? id;
  final String name;
  final double value;
  final String createdAt; // Stored as ISO 8601 string

  Liability({
    this.id,
    required this.name,
    required this.value,
    required this.createdAt,
  });

  // Convert to Map for SQLite
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'value': value,
      'createdAt': createdAt,
    };
  }

  // Convert from Map to Liability
  factory Liability.fromMap(Map<String, dynamic> map) {
    return Liability(
      id: map['id'],
      name: map['name'],
      value: map['value'],
      createdAt: map['createdAt'],
    );
  }
}
