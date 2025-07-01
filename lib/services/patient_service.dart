// import '../models/patient_record.dart';
// import '../services/db_service.dart';

// class PatientService {
//   final List<PatientRecord> _records = [];

//   Future<String> createPatient(String summary) async {
//     final id = DateTime.now().millisecondsSinceEpoch.toString();
//     final record = PatientRecord(
//       id: id,
//       date: DateTime.now(),
//       summary: summary,
//     );
//     _records.add(record);
//     return id;
//   }

//   Future<List<PatientRecord>> getRecords(String patientId) async {
//     // TODO: actually filter by patientId
//     return _records;
//   }
// }

// lib/services/patient_service.dart

import '../models/patient_record.dart';
import 'db_service.dart';

class PatientService {
  /// Create a new patient “record” in SQLite
  Future<String> createPatient(String patientId, String summary) async {
    final record = PatientRecord(
      id: patientId,
      date: DateTime.now(),
      summary: summary,
    );

    // Persist to DB
    await DBHelper.insertPatientRecord(record);
    return patientId;
  }

  /// Fetch only the records for the given [patientId].
  Future<List<PatientRecord>> getRecords(String patientId) async {
    final maps = await DBHelper.getPatientRecords(patientId);
    return maps.map((m) => PatientRecord.fromMap(m)).toList();
  }

  /// Update an existing patient record in SQLite
  Future<void> updatePatient(PatientRecord record) async {
    await DBHelper.updatePatientRecord(record);
  }
}
