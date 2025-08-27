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

    // Open (or create / migrate) the database
   _db = await openDatabase(
     path,
     version: 2,  // ← bump from 1 to 2
     onCreate: (db, version) async {
       // brand-new install: include history column
       await db.execute('''
         CREATE TABLE patients (
           id TEXT PRIMARY KEY,
           date TEXT,
           summary TEXT,
           history TEXT     -- store your JSON here
         )
       ''');
     },
     onUpgrade: (db, oldV, newV) async {
       if (oldV < 2) {
         // existing installs: add the new column
         await db.execute('''
           ALTER TABLE patients
           ADD COLUMN history TEXT
         ''');
       }
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
