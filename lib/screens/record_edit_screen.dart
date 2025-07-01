// lib/screens/record_edit_screen.dart

import 'package:flutter/material.dart';
import '../models/patient_record.dart';
import '../services/patient_service.dart';

class RecordEditScreen extends StatefulWidget {
  final PatientRecord record;
  const RecordEditScreen({super.key, required this.record});

  @override
  State<RecordEditScreen> createState() => _RecordEditScreenState();
}

class _RecordEditScreenState extends State<RecordEditScreen> {
  late TextEditingController _summaryController;

  @override
  void initState() {
    super.initState();
    _summaryController = TextEditingController(text: widget.record.summary);
  }

  @override
  void dispose() {
    _summaryController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final newSummary = _summaryController.text.trim();
    if (newSummary.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Summary cannot be empty')));
      return;
    }

    // Build an updated record (same ID, same date, new summary)
    final updated = PatientRecord(
      id: widget.record.id,
      date: widget.record.date,
      summary: newSummary,
    );

    // Persist the change
    await PatientService().updatePatient(updated);

    // Return it to the detail screen
    Navigator.pop(context, updated);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Record')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Show the ID (read-only)
            Text(
              'Patient ID: ${widget.record.id}',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),

            // Editable summary field
            TextField(
              controller: _summaryController,
              decoration: const InputDecoration(
                labelText: 'Summary',
                border: OutlineInputBorder(),
              ),
              maxLines: 5,
            ),
            const SizedBox(height: 20),

            // Save button
            ElevatedButton(onPressed: _save, child: const Text('Save')),
          ],
        ),
      ),
    );
  }
}
