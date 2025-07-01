// // class DBService {
// //   static final DBService _instance = DBService._();
// //   DBService._();
// //   factory DBService() => _instance;
// //   Future<Database> get db async { … }
// //   Future<void> init() async { … }
// //   Future<String> insertPatient(Map<String, dynamic> data) async { … }
// //   Future<List<Map<String, dynamic>>> getPatientRecords(String id) async { … }
// // }

// // lib/services/db_helper.dart

// import 'dart:io';
// import 'package:sqflite_common_ffi/sqflite_ffi.dart';
// import 'package:path/path.dart';
// import '../models/patient_record.dart';

// class DBHelper {
//   static late DatabaseFactory _factory;
//   static late Database _db;

//   /// Call this once at app startup
//   static Future<void> init() async {
//     // Initialize FFI implementation
//     sqfliteFfiInit();
//     _factory = databaseFactoryFfi;

//     // Store the DB file in your app’s working directory
//     final dbPath = join(Directory.current.path, 'clinic_app.db');

//     _db = await _factory.openDatabase(
//       dbPath,
//       options: OpenDatabaseOptions(
//         version: 1,
//         onCreate: (db, version) async {
//           // Create the `patients` table
//           await db.execute('''
//             CREATE TABLE patients (
//               id TEXT PRIMARY KEY,
//               date TEXT,
//               summary TEXT
//             )
//           ''');
//         },
//       ),
//     );
//   }

//   /// Insert or replace a patient record
//   static Future<void> insertPatientRecord(PatientRecord record) async {
//     await _db.insert(
//       'patients',
//       record.toMap(),
//       conflictAlgorithm: ConflictAlgorithm.replace,
//     );
//   }

//   /// Read back all records, newest first
//   static Future<List<Map<String, dynamic>>> getPatientRecords() async {
//     return await _db.query('patients', orderBy: 'date DESC');
//   }
// }

// lib/services/db_helper.dart

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/patient_record.dart';
import 'dart:io';                      // ← for Platform checks
import 'package:sqflite_common_ffi/sqflite_ffi.dart';  // ← desktop SQLite


class DBHelper {
  static Database? _db;

  // Internal getter that opens the DB (and creates it on first run)
  static Future<Database> _getDb() async {
    if (_db != null) return _db!;

    // ─── On desktop platforms, initialize & swap in the FFI implementation ───
    if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      sqfliteFfiInit();                  // initialize the ffi library
      databaseFactory = databaseFactoryFfi;  // route all opens through FFI
    }

    // Get the platform-specific databases directory
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, 'clinic_app.db');

    // Open (or create) the database
    _db = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE patients (
            id TEXT PRIMARY KEY,
            date TEXT,
            summary TEXT
          )
        ''');
      },
    );

    return _db!;
  }

  /// Call once at startup to ensure the DB is ready
  static Future<void> init() async {
    await _getDb();
  }

  /// Insert or replace a patient record
  static Future<void> insertPatientRecord(PatientRecord record) async {
    final db = await _getDb();
    await db.insert(
      'patients',
      record.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// Update an existing patient record
  static Future<void> updatePatientRecord(PatientRecord record) async {
    final db = await _getDb();
    await db.update(
      'patients',
      record.toMap(),
      where: 'id = ?',
      whereArgs: [record.id],
    );
  }

  /// Read back all records, newest first
  // static Future<List<Map<String, dynamic>>> getPatientRecords() async {
  //   final db = await _getDb();
  //   return await db.query('patients', orderBy: 'date DESC');
  // }
  /// Read back only the records matching [patientId], newest first
  static Future<List<Map<String, dynamic>>> getPatientRecords(
    String patientId,
  ) async {
    final db = await _getDb();
    return await db.query(
      'patients',
      where: 'id = ?',
      whereArgs: [patientId],
      orderBy: 'date DESC',
    );
  }
}
