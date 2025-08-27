// // class PatientRecord {
// //   final String id;
// //   final DateTime date;
// //   final String summary;
// //   // add other fields like name, age, diagnosis if you want

// //   PatientRecord({required this.id, required this.date, required this.summary});
// // }

// // lib/models/patient_record.dart

// class PatientRecord {
//   final String id;
//   final DateTime date;
//   final String summary;

//   PatientRecord({required this.id, required this.date, required this.summary});

//   /// Convert a DB row into a PatientRecord
//   factory PatientRecord.fromMap(Map<String, dynamic> map) {
//     return PatientRecord(
//       id: map['id'] as String,
//       date: DateTime.parse(map['date'] as String),
//       summary: map['summary'] as String,
//     );
//   }

//   /// Convert a PatientRecord into a Map for the DB
//   Map<String, dynamic> toMap() {
//     return {'id': id, 'date': date.toIso8601String(), 'summary': summary};
//   }
// }
import 'dart:convert';

class PatientRecord {
  final String id;
  final DateTime date;
  final String summary;
  final Map<String, dynamic> history;     // ← new field

  PatientRecord({
    required this.id,
    required this.date,
    required this.summary,
    Map<String, dynamic>? history,
  }) : history = history ?? {};

  factory PatientRecord.fromMap(Map<String, dynamic> m) {
    return PatientRecord(
      id: m['id'] as String,
      date: DateTime.parse(m['date'] as String),
      summary: m['summary'] as String,
      history: m['history'] != null
        ? jsonDecode(m['history'] as String)
        : {},
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'summary': summary,
      'history': jsonEncode(history),  // ← persist JSON
    };
  }
}
