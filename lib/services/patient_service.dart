import '../models/patient_record.dart';
import 'db_service.dart';

class PatientService {
  /// Create a new patient “record” in SQLite
  // Future<String> createPatient(String patientId, String summary) async {
  Future<String> createPatient(String patientId, String summary,
     {Map<String, dynamic>? history}) async {
    final record = PatientRecord(
      id: patientId,
      date: DateTime.now(),
      summary: summary,
      history: history,
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
