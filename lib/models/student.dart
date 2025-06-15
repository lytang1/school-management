class Student {
  final int? id;
  final String name;
  final String dob;
  final String gender;
  final int? classId;

  Student({
    this.id,
    required this.name,
    required this.dob,
    required this.gender,
    this.classId,
  });

  // Convert to Map for SQLite
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'dob': dob,
      'gender': gender,
      'classId': classId ?? 0,
    };
  }

  // Convert from Map to Student
  factory Student.fromMap(Map<String, dynamic> map) {
    return Student(
      id: map['id'],
      name: map['name'],
      dob: map['dob'],
      gender: map['gender'],
      classId: map['classId'] ?? '',
    );
  }
}
