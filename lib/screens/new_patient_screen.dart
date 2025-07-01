// // import 'package:flutter/material.dart';
// // import 'package:provider/provider.dart';
// // import '../providers/app_state.dart';
// // import '../services/patient_service.dart';

// // class NewPatientScreen extends StatefulWidget {
// //   @override
// //   _NewPatientScreenState createState() => _NewPatientScreenState();
// // }

// // class _NewPatientScreenState extends State<NewPatientScreen> {
// //   final _summary = TextEditingController();

// //   @override
// //   void dispose() {
// //     _summary.dispose();
// //     super.dispose();
// //   }

// //   void _save() async {
// //     final service = PatientService();
// //     final id = await service.createPatient(_summary.text);
// //     context.read<AppState>().setCurrentPatient(id);
// //     //context.read<AppState>().selectNewPatient(null);
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(title: Text('New Patient')),
// //       body: Padding(
// //         padding: EdgeInsets.all(16),
// //         child: Column(
// //           children: [
// //             TextField(
// //               controller: _summary,
// //               decoration: InputDecoration(labelText: 'Initial Diagnosis'),
// //               maxLines: 5,
// //             ),
// //             SizedBox(height: 20),
// //             ElevatedButton(onPressed: _save, child: Text('Save & Continue')),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }
// // lib/screens/new_patient_screen.dart

// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../providers/app_state.dart';
// import '../services/patient_service.dart';

// class NewPatientScreen extends StatefulWidget {
//   const NewPatientScreen({super.key});

//   @override
//   State<NewPatientScreen> createState() => _NewPatientScreenState();
// }

// class _NewPatientScreenState extends State<NewPatientScreen> {
//   // ➊ two controllers: one for the patient ID, one for the diagnosis
//   final _patientIdController = TextEditingController();
//   final _summaryController = TextEditingController();

//   @override
//   void dispose() {
//     _patientIdController.dispose();
//     _summaryController.dispose();
//     super.dispose();
//   }

//   void _save() async {
//     // ➊ read text fields
//     final pid = _patientIdController.text.trim();
//     final diag = _summaryController.text.trim();

//     // ➋ validate synchronously
//     if (pid.isEmpty || diag.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('Please enter both Patient ID and Diagnosis'),
//         ),
//       );
//       return;
//     }

//     // ➌ capture AppState _before_ the async gap
//     final appState = context.read<AppState>();

//     // ➍ perform your database write
//     final service = PatientService();
//     final id = await service.createPatient(pid, diag);

//     // ➎ now use the saved appState (no more context here)
//     appState.setCurrentPatient(id);
//     appState.selectNewPatient(null);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('New Patient')),
//       body: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           children: [
//             // ➋ new Patient ID field
//             TextField(
//               controller: _patientIdController,
//               decoration: const InputDecoration(
//                 labelText: 'Patient ID',
//                 border: OutlineInputBorder(),
//               ),
//             ),
//             const SizedBox(height: 16),

//             // your existing diagnosis field
//             TextField(
//               controller: _summaryController,
//               decoration: const InputDecoration(
//                 labelText: 'Initial Diagnosis',
//                 border: OutlineInputBorder(),
//               ),
//               maxLines: 5,
//             ),
//             const SizedBox(height: 20),

//             ElevatedButton(
//               onPressed: _save,
//               child: const Text('Save & Continue'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// lib/screens/new_patient_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import '../services/patient_service.dart';
import '../models/patient_record.dart';
import 'record_detail_screen.dart'; // ← new import

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

  // Future<void> _save() async {
  //   final pid = _patientIdController.text.trim();
  //   final diag = _summaryController.text.trim();

  //   // ➊ Basic validation
  //   if (pid.isEmpty || diag.isEmpty) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(
  //         content: Text('Please enter both Patient ID and Diagnosis'),
  //       ),
  //     );
  //     return;
  //   }

  //   final service = PatientService();
  //   // ➋ Check for existing records with this ID
  //   final existing = await service.getRecords(pid);
  //   if (existing.isNotEmpty) {
  //     // ➌ Ask the user what to do
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

  //     if (override == true) {
  //       // ➍ Override: update the most recent record
  //       final updated = PatientRecord(
  //         id: pid,
  //         date: DateTime.now(),
  //         summary: diag,
  //       );
  //       await service.updatePatient(updated);
  //       // ➎ Open its detail page
  //       Navigator.push(
  //         context,
  //         MaterialPageRoute(
  //           builder: (_) => RecordDetailScreen(record: updated),
  //         ),
  //       );
  //     } else if (override == false) {
  //       // ➏ Open the existing detail page (for the first record)
  //       Navigator.push(
  //         context,
  //         MaterialPageRoute(
  //           builder: (_) => RecordDetailScreen(record: existing.first),
  //         ),
  //       );
  //     }
  //     return; // done handling duplicate
  //   }

  //   // ➐ No duplicate: create a brand-new record as before
  //   final id = await service.createPatient(pid, diag);
  //   context.read<AppState>().setCurrentPatient(id);
  //   context.read<AppState>().selectNewPatient(null);
  // }

  Future<void> _save() async {
    // final pid = _patientIdController.text.trim();
    // final diag = _summaryController.text.trim();

    // ➀ Capture context up-front so we never use `context` after an await
    // final currentContext = context;
    final pid = _patientIdController.text.trim();
    final diag = _summaryController.text.trim();
    // ➊ Basic validation (no async yet)
    if (pid.isEmpty || diag.isEmpty) {
      // You can still use `context` here
      final messenger = ScaffoldMessenger.of(context);
      messenger.showSnackBar(
        const SnackBar(
          content: Text('Please enter both Patient ID and Diagnosis'),
        ),
      );
      return;
    }

    // ➋ Capture AppState before any async gap
    final appState = context.read<AppState>();
    final service = PatientService();

    // ➌ Now do your async database lookup
    final existing = await service.getRecords(pid);

    if (existing.isNotEmpty) {
      // // ➍ Show the dialog *synchronously* using context
      // final override = await showDialog<bool>(
      //   context: context,
      // ➍ Show the dialog using our captured context
      final override = await showDialog<bool>(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Duplicate Patient ID'),
          content: const Text('A patient with this ID already exists.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Open Existing'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Override'),
            ),
          ],
        ),
      );

      // ➎ Guard against the widget having been disposed
      if (!mounted) return;

      if (override == true) {
        // ➏ Override: update the record
        final updated = PatientRecord(
          id: pid,
          date: DateTime.now(),
          summary: diag,
        );
        await service.updatePatient(updated);

        if (!mounted) return;
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => RecordDetailScreen(record: updated),
          ),
        );
      } else if (override == false) {
        if (!mounted) return;
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => RecordDetailScreen(record: existing.first),
          ),
        );
      }
      return;
    }

    // ➐ No duplicate: create a brand-new record
    final id = await service.createPatient(pid, diag);

    // ➑ Guard before using context again
    if (!mounted) return;

    appState.setCurrentPatient(id);
    appState.selectNewPatient(null);
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
            ElevatedButton(
              onPressed: _save,
              child: const Text('Save & Continue'),
            ),
          ],
        ),
      ),
    );
  }
}
