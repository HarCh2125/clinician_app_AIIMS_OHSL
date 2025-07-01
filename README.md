<!-- # my_app

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference. -->
# ClinicApp

**ClinicApp** is a simple, user-friendly patient management application designed specifically for doctors. It runs on iOS, macOS, Windows, and (in a limited preview) web, letting you securely record, view, and update patient diagnoses with ease.

---

## Key Features

1. **Secure Login**

   * Access the app with your doctor credentials.
   * Initial demo credentials: **Username:** `doctor` | **Password:** `password`.

2. **New Patient Entry**

   * Tap **New Patient** to record a new patient.
   * Enter a unique **Patient ID** and the **Initial Diagnosis**.
   * The system will warn you if the ID already exists and let you override or view the existing record.

3. **Existing Patient Lookup**

   * Enter a **Patient ID** and tap **Load** to retrieve past records.
   * If no records exist, you’ll see a clear “No patient found with ID …” message.

4. **Add & Edit Records**

   <!-- * In an existing patient, tap **Add New Record** to append an additional diagnosis. -->
   * View any record’s details and tap the **Edit** icon to correct or update the diagnosis (all fields except ID).

5. **Export as SQL**

   * On a record’s detail page, tap the **download** icon to export all of that patient’s data as an `.sql` file.
   <!-- * The file is saved to your **Documents** folder (e.g. `patient_1234.sql`), ready for archiving or sharing. -->

6. **Intuitive Navigation**

   * A clear **Back** button resets you to the Patient Type selector.
   * If you attempt to leave a form with unsaved changes, you’ll be warned to prevent accidental data loss.

7. **Cross-Platform Support**

   * Works natively on **iPhone/iPad**, **Mac**, and **Windows** desktop (using Flutter’s desktop support).
   * A web preview is available (data persistence is disabled in web mode).

---

## Getting Started

### Installation (End Users)

1. **Mac & Windows**

   * Your IT department can distribute the **ClinicApp** installer or executable.
   * Launch the app from your Applications folder (macOS) or Start menu (Windows).

2. **iOS / iPadOS**

   * Download via TestFlight (or App Store when published).
   * Tap the ClinicApp icon on your device home screen.

### Logging In

1. On the login screen, enter your doctor credentials.
2. Tap **Log In**.
3. You’ll be presented with a choice: **New Patient** or **Existing Patient**.

---

## How to Use

### 1. New Patient Workflow

1. Select **New Patient**.
2. Enter a unique **Patient ID**.
3. Enter the **Initial Diagnosis** details.
4. Tap **Save & Continue**.
5. If the ID already exists, choose to **Override** the old record or **Open Existing**.

### 2. Existing Patient Workflow

1. Select **Existing Patient**.
2. Type the **Patient ID** and tap **Load**.
3. If a record exists, the relevant entry appears; otherwise you’ll see “No patient found with ID …”.
4. Tap the record to view full details.

### 3. Viewing & Editing Records

* On the **Record Details** screen you’ll see:
  • **Patient ID**
  • **Date/Time** of entry
  • **Summary** of diagnosis
* Tap the **Edit** icon to modify the summary.
* After editing, tap **Save** to update the entry.

### 4. Exporting Records

* From the **Record Details** page, tap the **download** icon.
* The app generates a `.sql` file with all entries for that patient and saves it to your Documents folder.
* A confirmation message shows you the file path.

---

## Troubleshooting

* **Can’t find a patient?**
  Ensure the Patient ID is typed exactly (case-sensitive).
* **Blank screen on web?**
  The demo web build skips database support. Use the desktop or mobile build for full functionality.
* **Error saving data?**
  Check that your device has write access to the local documents directory.

---

## Support

For questions or to report issues, please contact your IT department or email **[shreya.tiwari@ohsl.us](mailto:shreya.tiwari@ohsl.us)**.

---

<!-- *\*ClinicApp helps you focus on patient care by making record-keeping fast, reliable, and cross-platform.*\* -->
