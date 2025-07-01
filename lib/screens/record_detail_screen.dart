// // lib/screens/record_detail_screen.dart

// import 'package:flutter/material.dart';
// import '../models/patient_record.dart';

// class RecordDetailScreen extends StatelessWidget {
//   final PatientRecord record;

//   const RecordDetailScreen({super.key, required this.record});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Record Details')),
//       body: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               'Patient ID: ${record.id}',
//               style: Theme.of(context).textTheme.titleMedium,
//             ),
//             const SizedBox(height: 8),
//             Text(
//               'Date: ${record.date}',
//               style: Theme.of(context).textTheme.titleMedium,
//             ),
//             const SizedBox(height: 16),
//             Text('Summary:', style: Theme.of(context).textTheme.headlineMedium),
//             const SizedBox(height: 8),
//             Text(record.summary, style: Theme.of(context).textTheme.bodyMedium),
//           ],
//         ),
//       ),
//     );
//   }
// }

// lib/screens/record_detail_screen.dart

import 'package:flutter/material.dart';
import '../models/patient_record.dart';
import 'record_edit_screen.dart';
import '../services/sql_export_service.dart';

class RecordDetailScreen extends StatefulWidget {
  final PatientRecord record;
  const RecordDetailScreen({super.key, required this.record});

  @override
  State<RecordDetailScreen> createState() => _RecordDetailScreenState();
}

class _RecordDetailScreenState extends State<RecordDetailScreen> {
  late PatientRecord _record;

  @override
  void initState() {
    super.initState();
    _record = widget.record;
  }

  Future<void> _editRecord() async {
    // Navigate to edit, and await the updated record
    final updated = await Navigator.push<PatientRecord>(
      context,
      MaterialPageRoute(builder: (_) => RecordEditScreen(record: _record)),
    );
    if (updated != null) {
      setState(() => _record = updated);
    }
  }

    /// Exports the current patient’s SQL and shows a SnackBar with the path.
  Future<void> _exportSql() async {
    final filePath = await SqlExportService().exportPatientRecords(_record.id);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Exported SQL to $filePath')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Record Details'),
        actions: [
          IconButton(
        icon: const Icon(Icons.edit),
        onPressed: _editRecord,
      ),
      IconButton(
        icon: const Icon(Icons.download),
        tooltip: 'Export as SQL',
        onPressed: _exportSql,
      ),
    ],
    ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Patient ID: ${_record.id}',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Date: ${_record.date}',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            Text('Summary:', style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 8),
            Text(
              _record.summary,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
