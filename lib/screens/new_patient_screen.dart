// lib/screens/new_patient_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import '../services/patient_service.dart';
import '../models/patient_record.dart';
import 'record_detail_screen.dart';
import 'new_patient_history_screen.dart';

class NewPatientScreen extends StatefulWidget {
  const NewPatientScreen({super.key});
  @override
  State<NewPatientScreen> createState() => _NewPatientScreenState();
}

class _NewPatientScreenState extends State<NewPatientScreen> {
  final _patientIdController = TextEditingController();
  final _summaryController = TextEditingController();

  @override
  void dispose() {
    _patientIdController.dispose();
    _summaryController.dispose();
    super.dispose();
  }

  // Future<String?> _save() async {
  //   final pid = _patientIdController.text.trim();
  //   final diag = _summaryController.text.trim();
  //   // ➊ Basic validation (no async yet)
  //   if (pid.isEmpty || diag.isEmpty) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(content: Text('Please enter both Patient ID and Diagnosis')),
  //     );
  //     return null;
  //     // You can still use `context` here
  //     final messenger = ScaffoldMessenger.of(context);
  //     messenger.showSnackBar(
  //       const SnackBar(
  //         content: Text('Please enter both Patient ID and Diagnosis'),
  //       ),
  //     );
  //     return;
  //   }

  //   // ➋ Capture AppState before any async gap
  //   final appState = context.read<AppState>();
  //   final service = PatientService();

  //   // ➌ Now do your async database lookup
  //   final existing = await service.getRecords(pid);

  //   if (existing.isNotEmpty) {
  //     final override = await showDialog<bool>(
  //       context: context,
  //       builder: (_) => AlertDialog(
  //         title: const Text('Duplicate Patient ID'),
  //         content: const Text('A patient with this ID already exists.'),
  //         actions: [
  //           TextButton(
  //             onPressed: () => Navigator.of(context).pop(false),
  //             child: const Text('Open Existing'),
  //           ),
  //           TextButton(
  //             onPressed: () => Navigator.of(context).pop(true),
  //             child: const Text('Override'),
  //           ),
  //         ],
  //       ),
  //     );

  //     // ➎ Guard against the widget having been disposed
  //     if (!mounted) return;

  //     if (override == true) {
  //       // ➏ Override: update the record
  //       final updated = PatientRecord(
  //         id: pid,
  //         date: DateTime.now(),
  //         summary: diag,
  //       );
  //       await service.updatePatient(updated);

  //       if (!mounted) return;
  //       Navigator.push(
  //         context,
  //         MaterialPageRoute(
  //           builder: (_) => NewPatientHistoryScreen(patientId: pid),
  //         ),
  //       );
  //     } else if (override == false) {
  //       if (!mounted) return;
  //       Navigator.push(
  //         context,
  //         MaterialPageRoute(
  //           builder: (_) => NewPatientHistoryScreen(patientId: pid),
  //         ),
  //       );
  //     }
  //     return;
  //   }

  //   // ➐ No duplicate: create a brand-new record
  //   final id = await service.createPatient(pid, diag);

  //   // ➑ Guard before using context again
  //   if (!mounted) return;

  //   appState.setCurrentPatient(id);
  //   appState.selectNewPatient(null);
  // }

  Future<String?> _save() async {
  final pid  = _patientIdController.text.trim();
  final diag = _summaryController.text.trim();

  if (pid.isEmpty || diag.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Please enter both Patient ID and Diagnosis')),
    );
    return null; // ← return null on validation failure
  }

  final appState = context.read<AppState>();
  final service  = PatientService();

  final existing = await service.getRecords(pid);
  if (existing.isNotEmpty) {
    final override = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Duplicate Patient ID'),
        content: const Text('A patient with this ID already exists.'),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text('Open Existing')),
          TextButton(onPressed: () => Navigator.of(context).pop(true),  child: const Text('Override')),
        ],
      ),
    );

    if (!mounted) return null;
    // ── DUPLICATE PATHS ──
    if (override == true) {
      // override: update
      final updated = PatientRecord(id: pid, date: DateTime.now(), summary: diag);
      await service.updatePatient(updated);
      return pid;           // ← return pid, *no* navigation here
    } else if (override == false) {
      // open existing
      return pid;           // ← return pid, *no* navigation here
    }
    return null;
  }

  // ── NO DUPLICATE ──
  final id = await service.createPatient(pid, diag);
  if (!mounted) return null;
  appState.setCurrentPatient(id);
  appState.selectNewPatient(null);

  return id;  // ← return the newly created ID
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: const Text('New Patient')),
      appBar: AppBar(
        // ① leading back‐arrow button
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // reset to the patient‐type selector
            context.read<AppState>().selectNewPatient(null);
          },
        ),
        title: const Text('New Patient'),
        // disable the default back behavior since we’re handling it ourselves
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _patientIdController,
              decoration: const InputDecoration(
                labelText: 'Patient ID',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _summaryController,
              decoration: const InputDecoration(
                labelText: 'Initial Diagnosis',
                border: OutlineInputBorder(),
              ),
              maxLines: 5,
            ),
            const SizedBox(height: 20),
            // ElevatedButton(
            //   onPressed: () {
            //     // 1️⃣ first save the patient ID & initial diagnosis
            //     _save();

            //     // 2️⃣ then navigate into the HISTORY form
            //     Navigator.of(context).push(
            //       MaterialPageRoute(
            //         builder: (_) => NewPatientHistoryScreen(
            //           patientId: pid,
            //         ),
            //       ),
            //     );
            //   },
            //   child: const Text('Next'),
            // ),
            ElevatedButton(
              onPressed: () async {
                // Call _save() and await the returned ID
                final pid = await _save();
                if (pid == null || !mounted) return;

                // Now navigate, passing that ID
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => NewPatientHistoryScreen(patientId: pid),
                  ),
                );
              },
              child: const Text('Next'),
            ),
          ],
        ),
      ),
    );
  }
}
