import 'package:flutter/material.dart';
import '../services/patient_service.dart';
import '../models/patient_record.dart';

/// A screen for entering the detailed HISTORY section of the proforma.
class NewPatientHistoryScreen extends StatefulWidget {
  final String patientId; 
  const NewPatientHistoryScreen({super.key, required this.patientId});
//   const NewPatientHistoryScreen({super.key});

  @override
  State<NewPatientHistoryScreen> createState() => _NewPatientHistoryScreenState();
}

class _NewPatientHistoryScreenState extends State<NewPatientHistoryScreen> {
  final List<String> yesNoOptions = ['Yes', 'No'];
  final List<String> durationUnits = ['Hours', 'Days', 'Weeks', 'Months', 'Years'];

  // Field definitions by category
  final List<String> presentingComplaints = [
    'Headache', 'Nausea', 'Vomiting', 'Fits (Focal/GTC/Absence)',
    'Visual disturbance', 'Diplopia', 'Deviation of eyes',
    'Hearing difficulty', 'Swallowing difficulty',
    'Deviation of angle of mouth', 'Upper limb weakness',
    'Lower limb weakness', 'One side weakness (R/L)',
    'Quadriplegia', 'Sensory disturbance', 'Imbalance (cerebellar)',
    'Personality changes', 'Backache', 'Urinary incontinence',
    'Constipation',
  ];
  final List<String> pastHistory = [
    'Diabetes', 'Hypertension', 'Cardiovascular diseases', 'Others',
  ];
  final List<String> personalHistory = [
    'Sleep abnormality', 'Appetite changes', 'Smoking',
    'Chewing', 'Alcohol',
  ];
  final List<String> socioeconomic = [
    'Socioeconomic status (High/Medium/Low)',
    'Job (Self/Govt/Pvt)',
    'Treatment cost (Self/Reimbursable/MSSO)',
  ];

  // State storage
  final Map<String, String> ynAnswers = {};
  final Map<String, String> durationAnswers = {};
  final Map<String, String> unitAnswers = {};
  final Map<String, TextEditingController> commentControllers = {};

  @override
  void dispose() {
    for (final controller in commentControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  /// Builds a single field entry in three lines: label, inputs, comment.
  Widget buildField(String label) {
    final controller =
        commentControllers.putIfAbsent(label, () => TextEditingController());

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Field name
          Text(label, style: Theme.of(context).textTheme.bodyLarge),
          const SizedBox(height: 8),

          // Row of Y/N, Duration, Unit
          Row(
            children: [
              // Yes/No dropdown
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: ynAnswers[label],
                  decoration: const InputDecoration(labelText: 'Y/N'),
                  items: yesNoOptions
                      .map((yn) => DropdownMenuItem(value: yn, child: Text(yn)))
                      .toList(),
                  onChanged: (v) => setState(() => ynAnswers[label] = v!),
                ),
              ),
              const SizedBox(width: 16),

              // Duration input
              SizedBox(
                width: 80,
                child: TextFormField(
                  initialValue: durationAnswers[label],
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Duration'),
                  onChanged: (v) => durationAnswers[label] = v,
                ),
              ),
              const SizedBox(width: 16),

              // Unit dropdown
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: unitAnswers[label],
                  decoration: const InputDecoration(labelText: 'Unit'),
                  items: durationUnits
                      .map((u) => DropdownMenuItem(value: u, child: Text(u)))
                      .toList(),
                  onChanged: (v) => setState(() => unitAnswers[label] = v!),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Comment field
          TextFormField(
            controller: controller,
            decoration: const InputDecoration(labelText: 'Comment'),
          ),
        ],
      ),
    );
  }

  /// Builds a section with a title and multiple fields.
  Widget buildSection(String title, List<String> fields) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 16),
        ...fields.map(buildField),
      ],
    );
  }

  Future<void> _onNext() async{
    // TODO: collect and persist history data, then navigate on
    Navigator.pop(context);
    // Start assembling history JSON
    final fullHistory = <String, dynamic>{};
    for(final key in ynAnswers.keys) {
      fullHistory[key] = {
        'yn': ynAnswers[key],
        'duration': durationAnswers[key],
        'unit': unitAnswers[key],
        'comment': commentControllers[key]!.text,
      };
    }

    // Persist into SQLite
    final service = PatientService();
    final existing = await service.getRecords(widget.patientId);
    if(existing.isEmpty) {
      // probably a new patient
      await service.createPatient(widget.patientId, '', history: fullHistory);
    }
    else{
      // Update the first match
      final rec = existing.first;
      final updated = PatientRecord(
        id: rec.id,
        date: rec.date,
        summary: rec.summary,
        history: fullHistory,
      );
      await service.updatePatient(updated);
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HISTORY'),
        leading: BackButton(onPressed: () => Navigator.pop(context)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            buildSection('PRESENTING COMPLAINT', presentingComplaints),
            const SizedBox(height: 24),
            buildSection('PAST HISTORY', pastHistory),
            const SizedBox(height: 24),
            buildSection('PERSONAL HISTORY', personalHistory),
            const SizedBox(height: 24),
            buildSection('SOCIOECONOMIC', socioeconomic),
            const SizedBox(height: 32),
            ElevatedButton(onPressed: _onNext, child: const Text('Next')),
          ],
        ),
      ),
    );
  }
}
