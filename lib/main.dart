import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

bool vesselDetailsEntered = false;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OneKai Fishery App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.teal,
        scaffoldBackgroundColor: Colors.teal[900],
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: Colors.white),
        ),
      ),
      home: const LandingPage(),
    );
  }
}

// ---------------- LANDING PAGE ----------------
class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Welcome to\nOneKai Fishery Data Reporting App',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 26, color: Colors.white),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal[700],
                foregroundColor: Colors.black, // <- text color
              ),
              child: const Text("Enter"),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const HomePage()),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}

// ---------------- HOME PAGE ----------------
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Main Menu")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal[700],
                foregroundColor: Colors.black,
              ),
              child: const Text("Enter Vessel Details"),
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const VesselFormPage()),
                );
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal[700],
                foregroundColor: Colors.black,
              ),
              child: const Text("Enter Catch Report"),
              onPressed: () {
                if (!vesselDetailsEntered) {
                  showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      backgroundColor: Colors.teal[800],
                      title: const Text("Warning", style: TextStyle(color: Colors.white)),
                      content: const Text(
                        "Warning - please fill in vessel details",
                        style: TextStyle(color: Colors.white),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text("OK"),
                        )
                      ],
                    ),
                  );
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const CatchReportPage()),
                  );
                }
              },
            )
          ],
        ),
      ),
    );
  }
}

// ---------------- VESSEL FORM ----------------
class VesselFormPage extends StatefulWidget {
  const VesselFormPage({super.key});

  @override
  State<VesselFormPage> createState() => _VesselFormPageState();
}

class _VesselFormPageState extends State<VesselFormPage> {
  final _formKey = GlobalKey<FormState>();
  String? vesselSize;
  String? area;

  InputDecoration fieldDecoration(String label) {
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: Colors.white,
      labelStyle: const TextStyle(color: Colors.black),
      border: const OutlineInputBorder(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Vessel Details")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: fieldDecoration("First Name"),
                validator: (value) =>
                (value == null || value.isEmpty) ? "Required" : null,
                style: const TextStyle(color: Colors.black),
              ),
              const SizedBox(height: 10),
              TextFormField(
                decoration: fieldDecoration("Surname"),
                validator: (value) =>
                (value == null || value.isEmpty) ? "Required" : null,
                style: const TextStyle(color: Colors.black),
              ),
              const SizedBox(height: 10),
              TextFormField(
                decoration: fieldDecoration("Vessel Name"),
                validator: (value) =>
                (value == null || value.isEmpty) ? "Required" : null,
                style: const TextStyle(color: Colors.black),
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                decoration: fieldDecoration("Vessel Size"),
                value: vesselSize,
                items: const [
                  DropdownMenuItem(value: "4-10 ft", child: Text("4-10 ft")),
                  DropdownMenuItem(value: "10-16 ft", child: Text("10-16 ft")),
                  DropdownMenuItem(value: "16+ ft", child: Text("16+ ft")),
                ],
                onChanged: (val) => setState(() => vesselSize = val),
                validator: (val) => val == null ? "Required" : null,
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                decoration: fieldDecoration("Area"),
                value: area,
                items: const [
                  DropdownMenuItem(value: "England", child: Text("England")),
                  DropdownMenuItem(value: "Wales", child: Text("Wales")),
                  DropdownMenuItem(value: "Scotland", child: Text("Scotland")),
                ],
                onChanged: (val) => setState(() => area = val),
                validator: (val) => val == null ? "Required" : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal[700],
                  foregroundColor: Colors.black,
                ),
                child: const Text("Save"),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    vesselDetailsEntered = true;
                    Navigator.pop(context);
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------- CATCH REPORT ----------------
class CatchEntry {
  String? species;
  TextEditingController weightController = TextEditingController();
}

class CatchReportPage extends StatefulWidget {
  const CatchReportPage({super.key});

  @override
  State<CatchReportPage> createState() => _CatchReportPageState();
}

class _CatchReportPageState extends State<CatchReportPage> {
  final latController = TextEditingController();
  final lonController = TextEditingController();
  final dateController = TextEditingController();
  List<CatchEntry> entries = [CatchEntry()];

  void addEntry() {
    setState(() {
      entries.add(CatchEntry());
    });
  }

  InputDecoration fieldDecoration(String label) {
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: Colors.white,
      labelStyle: const TextStyle(color: Colors.black),
      border: const OutlineInputBorder(),
    );
  }

  Future<void> pickDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      dateController.text =
      "${pickedDate.day.toString().padLeft(2, '0')}/"
          "${pickedDate.month.toString().padLeft(2, '0')}/"
          "${pickedDate.year}";
    }
  }

  bool isValidWeight(String value) {
    return double.tryParse(value) != null;
  }

  void submit() {
    bool hasValidEntry = entries.any((e) =>
    e.species != null &&
        e.weightController.text.isNotEmpty &&
        isValidWeight(e.weightController.text));

    if (!hasValidEntry) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          backgroundColor: Colors.teal[800],
          title: const Text("Error", style: TextStyle(color: Colors.white)),
          content: const Text(
            "Enter at least one species with valid weight.",
            style: TextStyle(color: Colors.white),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("OK"),
            )
          ],
        ),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Report submitted ✔")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Catch Report")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            TextField(
              controller: latController,
              decoration: fieldDecoration("Latitude (e.g., 56°27'48.9\"N)"),
              style: const TextStyle(color: Colors.black),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: lonController,
              decoration: fieldDecoration("Longitude (e.g., 5°19'31.7\"E)"),
              style: const TextStyle(color: Colors.black),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: dateController,
              decoration: fieldDecoration("Date"),
              readOnly: true,
              onTap: pickDate,
              style: const TextStyle(color: Colors.black),
            ),
            const SizedBox(height: 20),
            const Text("Catch Entries", style: TextStyle(fontSize: 18, color: Colors.white)),
            const SizedBox(height: 10),
            ...entries.map((entry) {
              return Column(
                children: [
                  DropdownButtonFormField<String>(
                    decoration: fieldDecoration("Species"),
                    items: const [
                      DropdownMenuItem(value: "Tope", child: Text("Tope")),
                      DropdownMenuItem(value: "Mackerel", child: Text("Mackerel")),
                      DropdownMenuItem(value: "Bass", child: Text("Bass")),
                      DropdownMenuItem(value: "Pollack", child: Text("Pollack")),
                    ],
                    onChanged: (val) => entry.species = val,
                  ),
                  const SizedBox(height: 5),
                  TextField(
                    controller: entry.weightController,
                    keyboardType: TextInputType.number,
                    decoration: fieldDecoration("Weight (kg, whole or decimal)"),
                    style: const TextStyle(color: Colors.black),
                  ),
                  const SizedBox(height: 10),
                ],
              );
            }),
            ElevatedButton(
              onPressed: addEntry,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal[700],
                foregroundColor: Colors.black,
              ),
              child: const Text("Add More"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: submit,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal[700],
                foregroundColor: Colors.black,
              ),
              child: const Text("Submit Report"),
            ),
          ],
        ),
      ),
    );
  }
}