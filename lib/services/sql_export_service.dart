// lib/services/sql_export_service.dart

import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';
import '../models/patient_record.dart';
import 'patient_service.dart';

class SqlExportService {
  /// Exports all records for [patientId] into an .sql file
  /// Returns the full file path.
  Future<String> exportPatientRecords(String patientId) async {
    // 1. Fetch records
    final service = PatientService();
    final List<PatientRecord> records = await service.getRecords(patientId);

    // 2. Build SQL dump
    final buffer = StringBuffer()
      // ..writeln(
      //   'CREATE TABLE IF NOT EXISTS patients ('
      //   'id TEXT PRIMARY KEY, '
      //   'date TEXT, '
      //   'summary TEXT'
      //   ');'
      // );
      ..writeln(
        'CREATE TABLE IF NOT EXISTS patients ('
        'id TEXT PRIMARY KEY, date TEXT, summary TEXT, history TEXT'
        ');'
      );
    for (final r in records) {
      final date   = r.date.toIso8601String();
      // Escape single quotes in summary
      final summary = r.summary.replaceAll("'", "''");
      final hist = r.history.isNotEmpty ? jsonEncode(r.history).replaceAll("'", "'") : '';
      buffer.writeln(
        "INSERT OR REPLACE INTO patients (id, date, summary, history) "
        "VALUES ('${r.id}', '$date', '$summary');"
      );
    }

    // 3. Write to file in Documents directory
    final docsDir = await getApplicationDocumentsDirectory();
    final filePath = '${docsDir.path}/patient_$patientId.sql';
    final file = File(filePath);
    await file.writeAsString(buffer.toString());

    return filePath;
  }
}
