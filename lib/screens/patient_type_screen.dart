import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';

class PatientTypeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Is this a new patient?',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            SizedBox(height: 20),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ElevatedButton(
                  onPressed: () =>
                      context.read<AppState>().selectNewPatient(true),
                  child: Text('New Patient'),
                ),
                SizedBox(width: 20),
                ElevatedButton(
                  onPressed: () =>
                      context.read<AppState>().selectNewPatient(false),
                  child: Text('Existing Patient'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
