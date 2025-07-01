// class PatientRecord {
//   final String id;
//   final DateTime date;
//   final String summary;
//   // add other fields like name, age, diagnosis if you want

//   PatientRecord({required this.id, required this.date, required this.summary});
// }

// lib/models/patient_record.dart

class PatientRecord {
  final String id;
  final DateTime date;
  final String summary;

  PatientRecord({required this.id, required this.date, required this.summary});

  /// Convert a DB row into a PatientRecord
  factory PatientRecord.fromMap(Map<String, dynamic> map) {
    return PatientRecord(
      id: map['id'] as String,
      date: DateTime.parse(map['date'] as String),
      summary: map['summary'] as String,
    );
  }

  /// Convert a PatientRecord into a Map for the DB
  Map<String, dynamic> toMap() {
    return {'id': id, 'date': date.toIso8601String(), 'summary': summary};
  }
}
