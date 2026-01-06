import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ReservationPage extends StatefulWidget {
  const ReservationPage({super.key});

  @override
  State<ReservationPage> createState() => _ReservationPageState();
}

class _ReservationPageState extends State<ReservationPage> {
  final _formKey = GlobalKey<FormState>();

  String? name;
  String? email;
  String? phone;
  DateTime? selectedDate;
  TimeOfDay? startTime;
  TimeOfDay? endTime;
  int? participants;

  // ================= DATE =================
  Future<void> _pickDate(BuildContext context) async {
    final date = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (date != null) {
      setState(() => selectedDate = date);
    }
  }

  // ================= TIME =================
  Future<void> _pickTime(BuildContext context, bool isStart) async {
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (time != null) {
      setState(() {
        isStart ? startTime = time : endTime = time;
      });
    }
  }

  // ================= FIREBASE =================
  Future<void> _saveReservationToFirebase() async {
    await FirebaseFirestore.instance.collection('reservations').add({
      'name': name,
      'email': email,
      'phone': phone,
      'date': Timestamp.fromDate(selectedDate!),
      'startTime': startTime!.format(context),
      'endTime': endTime!.format(context),
      'participants': participants,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  // ================= SUBMIT =================
  void _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    if (selectedDate == null || startTime == null || endTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Veuillez choisir la date et l'heure"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    _formKey.currentState!.save();

    try {
      await _saveReservationToFirebase();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Réservation enregistrée avec succès !"),
          backgroundColor: Colors.green,
        ),
      );

      _formKey.currentState!.reset();
      setState(() {
        selectedDate = null;
        startTime = null;
        endTime = null;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erreur : $e"), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Réserver une Salle"),
        backgroundColor: Colors.purple,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  labelText: "Nom et Prénom",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (v) => v!.isEmpty ? "Champ obligatoire" : null,
                onSaved: (v) => name = v,
              ),
              const SizedBox(height: 16),

              TextFormField(
                decoration: const InputDecoration(
                  labelText: "Email",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.email),
                ),
                validator: (v) => v!.isEmpty ? "Champ obligatoire" : null,
                onSaved: (v) => email = v,
              ),
              const SizedBox(height: 16),

              TextFormField(
                decoration: const InputDecoration(
                  labelText: "Téléphone",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.phone),
                ),
                validator: (v) => v!.isEmpty ? "Champ obligatoire" : null,
                onSaved: (v) => phone = v,
              ),
              const SizedBox(height: 16),

              ListTile(
                title: const Text("Date"),
                subtitle: Text(
                  selectedDate == null
                      ? "Choisir une date"
                      : selectedDate!.toLocal().toString().split(' ')[0],
                ),
                trailing: const Icon(Icons.calendar_today),
                onTap: () => _pickDate(context),
              ),

              ListTile(
                title: const Text("Heure début"),
                subtitle: Text(
                  startTime == null ? "Choisir" : startTime!.format(context),
                ),
                trailing: const Icon(Icons.access_time),
                onTap: () => _pickTime(context, true),
              ),

              ListTile(
                title: const Text("Heure fin"),
                subtitle: Text(
                  endTime == null ? "Choisir" : endTime!.format(context),
                ),
                trailing: const Icon(Icons.access_time),
                onTap: () => _pickTime(context, false),
              ),

              const SizedBox(height: 16),

              TextFormField(
                decoration: const InputDecoration(
                  labelText: "Participants",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.group),
                ),
                keyboardType: TextInputType.number,
                validator: (v) => v!.isEmpty ? "Champ obligatoire" : null,
                onSaved: (v) => participants = int.parse(v!),
              ),

              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text(
                    "Réserver",
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
