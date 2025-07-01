// // lib/screens/existing_patient_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import '../services/patient_service.dart';
import '../models/patient_record.dart';
import 'record_detail_screen.dart';

class ExistingPatientScreen extends StatefulWidget {
  const ExistingPatientScreen({super.key});

  @override
  State<ExistingPatientScreen> createState() => _ExistingPatientScreenState();
}

class _ExistingPatientScreenState extends State<ExistingPatientScreen> {
  final _searchId = TextEditingController();
  List<PatientRecord> _records = [];
  bool _hasSearched = false;

  @override
  void dispose() {
    _searchId.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    final service = PatientService();
    final recs = await service.getRecords(_searchId.text.trim());
    setState(() {
      _records = recs;
      _hasSearched = true;
    });

  }

  @override
  Widget build(BuildContext context) {
        // Determine what to show in the records area
      Widget recordsArea;
      if (!_hasSearched) {
        // Before tapping "Load"
        recordsArea = const Center(
          child: Text('Please enter the Patient ID.'),
        );
      } else if (_records.isEmpty) {
        // After tapping Load, but nothing found
        recordsArea = Center(
          child: Text(
            'No patient found with ID "${_searchId.text.trim()}".',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        );
      } else {
        // We have matching records
        recordsArea = ListView.builder(
          itemCount: _records.length,
          itemBuilder: (context, i) {
            final r = _records[i];
            return ListTile(
              title: Text(r.summary),
              subtitle: Text(r.date.toString()),
              onTap: () {
                if (!mounted) return;
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => RecordDetailScreen(record: r),
                  ),
                );
              },
            );
          },
        );
      }
    return Scaffold(
      // appBar: AppBar(title: const Text('Existing Patient')),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // go back to the “new or existing” choice screen
            context.read<AppState>().selectNewPatient(null);
          },
        ),
        title: const Text('Existing Patient'),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchId,
                    decoration: const InputDecoration(
                      labelText: 'Patient ID',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                // Expanded(
                //   child: recordsArea,
                // ),
                const SizedBox(width: 8),
                ElevatedButton(onPressed: _load, child: const Text('Load')),
              ],
            ),
            const SizedBox(height: 16),
            // Expanded(
            //   child: !_hasSearched
            //       // 1. Before you’ve ever tapped Load:
            //       ? const Center(child: Text('Please enter the Patient ID.'))
            //       // 2. After Load, if no matching rows:
            //       : (_records.isEmpty
            //           ? Center(
            //               child: Text(
            //                 'No patient found with ID “${_searchId.text.trim()}”.',
            //                 style: Theme.of(context).textTheme.bodyMedium,
            //               ),
            //             )
            //           // ③ Otherwise show the list:
            //           : ListView.builder(
            //               itemCount: _records.length,
            //               itemBuilder: (context, i) {
            //                 final r = _records[i];
            //                 return ListTile(
            //                   title: Text(r.summary),
            //                   subtitle: Text(r.date.toString()),
            //                   onTap: () {
            //                     // Safety check in case the widget got disposed
            //                     if (!mounted) return;
            //                     Navigator.of(context).push(
            //                       MaterialPageRoute(
            //                         builder: (_) => RecordDetailScreen(record: r),
            //                       ),
            //                     );
            //                   },
            //                 );
            //               },
            //             ),
            //             ),
            // ),
            Expanded(
              child: recordsArea,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.read<AppState>().selectNewPatient(true),
              child: const Text('Add New Record'),
            ),
          ],
        ),
      ),
    );
  }
}
