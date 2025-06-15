class SchoolClass {
  final int? id;
  final String studyYear;
  final String className;
  final double fee;

  SchoolClass({
    this.id,
    required this.studyYear,
    required this.className,
    required this.fee,
  });

  // Convert to Map for SQLite
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'studyYear': studyYear,
      'className': className,
      'fee': fee,
    };
  }

  // Convert from Map to SchoolClass
  factory SchoolClass.fromMap(Map<String, dynamic> map) {
    return SchoolClass(
      id: map['id'],
      studyYear: map['studyYear'],
      className: map['className'],
      fee: map['fee'],
    );
  }
}
