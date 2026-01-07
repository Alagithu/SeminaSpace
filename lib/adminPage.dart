import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/login.dart';
import 'package:intl/intl.dart';
import 'manageSalle.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Gestion des Réservations",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.orange, Colors.purpleAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: "Déconnexion",
            onPressed: () => _showLogoutDialog(context),
          ),
        ],
      ),
      backgroundColor: Colors.purple.shade50,
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream:
                    FirebaseFirestore.instance
                        .collection('reservations')
                        .orderBy('createdAt', descending: true)
                        .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(color: Colors.purple),
                    );
                  }

                  if (snapshot.hasError) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.error_outline,
                            size: 64,
                            color: Colors.red,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            "Erreur : ${snapshot.error}",
                            style: const TextStyle(color: Colors.red),
                          ),
                        ],
                      ),
                    );
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.calendar_today_outlined,
                            size: 64,
                            color: Colors.purple.shade300,
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            "Aucune réservation à afficher",
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      var doc = snapshot.data!.docs[index];
                      var data = doc.data() as Map<String, dynamic>;

                      String name = data['name'] ?? 'Inconnu';
                      String roomName = data['roomName'] ?? 'Salle non définie';
                      String email = data['email'] ?? 'Pas d\'email';
                      String phone = data['phone'] ?? 'Pas de téléphone';
                      int participants = data['participants'] ?? 0;
                      String startTime = data['startTime'] ?? '--:--';
                      String endTime = data['endTime'] ?? '--:--';
                      String status = data['status'] ?? 'En attente';
                      String dateStr = _formatDate(data['date']);
                      bool isConfirmed = status == 'Confirmée';

                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        elevation: 4,
                        margin: const EdgeInsets.only(bottom: 15),
                        child: ExpansionTile(
                          leading: CircleAvatar(
                            backgroundColor:
                                isConfirmed ? Colors.green : Colors.orange,
                            child: Icon(
                              isConfirmed ? Icons.check : Icons.hourglass_empty,
                              color: Colors.white,
                            ),
                          ),
                          title: Text(
                            name,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                roomName,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.purple,
                                ),
                              ),
                              Text("$dateStr | $startTime - $endTime"),
                            ],
                          ),

                          trailing: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color:
                                  isConfirmed
                                      ? Colors.green.shade50
                                      : Colors.orange.shade50,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color:
                                    isConfirmed ? Colors.green : Colors.orange,
                                width: 1.5,
                              ),
                            ),
                            child: Text(
                              status,
                              style: TextStyle(
                                color:
                                    isConfirmed ? Colors.green : Colors.orange,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildInfoRow(
                                    Icons.meeting_room,
                                    "Salle",
                                    roomName,
                                  ),
                                  const SizedBox(height: 8),
                                  _buildInfoRow(Icons.email, "Email", email),
                                  const SizedBox(height: 8),
                                  _buildInfoRow(
                                    Icons.phone,
                                    "Téléphone",
                                    phone,
                                  ),
                                  const SizedBox(height: 8),
                                  _buildInfoRow(
                                    Icons.people,
                                    "Participants",
                                    participants.toString(),
                                  ),
                                  const SizedBox(height: 8),
                                  _buildInfoRow(
                                    Icons.calendar_today,
                                    "Date",
                                    dateStr,
                                  ),
                                  const SizedBox(height: 8),
                                  _buildInfoRow(
                                    Icons.access_time,
                                    "Horaire",
                                    "$startTime - $endTime",
                                  ),
                                  const Divider(height: 24),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      TextButton.icon(
                                        onPressed:
                                            () => _confirmDelete(
                                              context,
                                              doc.id,
                                              name,
                                            ),
                                        icon: const Icon(
                                          Icons.delete,
                                          color: Colors.red,
                                        ),
                                        label: const Text(
                                          "Supprimer",
                                          style: TextStyle(color: Colors.red),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      ElevatedButton.icon(
                                        onPressed:
                                            () => _toggleStatus(doc.id, status),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              isConfirmed
                                                  ? Colors.grey
                                                  : Colors.green,
                                          foregroundColor: Colors.white,
                                          elevation: 2,
                                        ),
                                        icon: Icon(
                                          isConfirmed
                                              ? Icons.undo
                                              : Icons.done_all,
                                        ),
                                        label: Text(
                                          isConfirmed ? "Annuler" : "Confirmer",
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ManageSallesPage(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.meeting_room),
                  label: const Text(
                    "Gestion des Salles",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 4,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(dynamic dateData) {
    try {
      if (dateData == null) return "Date non définie";

      DateTime dateTime;

      if (dateData is Timestamp) {
        dateTime = dateData.toDate();
      } else if (dateData is String) {
        dateTime = DateTime.parse(dateData);
      } else if (dateData is DateTime) {
        dateTime = dateData;
      } else {
        return "Format invalide";
      }

      return DateFormat('dd/MM/yyyy').format(dateTime);
    } catch (e) {
      debugPrint("Erreur formatage date : $e");
      return "Erreur de date";
    }
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.purple),
        const SizedBox(width: 8),
        Text(
          "$label : ",
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        Expanded(child: Text(value, style: const TextStyle(fontSize: 14))),
      ],
    );
  }

  Future<void> _showLogoutDialog(BuildContext context) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text("Déconnexion"),
            content: const Text("Voulez-vous vraiment vous déconnecter ?"),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text("Annuler"),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  foregroundColor: Colors.white,
                ),
                child: const Text("Déconnexion"),
              ),
            ],
          ),
    );

    if (confirm == true) {
      await _logout(context);
    }
  }

  Future<void> _confirmDelete(
    BuildContext context,
    String docId,
    String name,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text("Confirmer la suppression"),
            content: Text(
              "Voulez-vous vraiment supprimer la réservation de $name ?",
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text("Annuler"),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
                child: const Text("Supprimer"),
              ),
            ],
          ),
    );

    if (confirmed == true) {
      await _deleteReservation(docId);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Réservation de $name supprimée"),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      }
    }
  }

  Future<void> _toggleStatus(String docId, String currentStatus) async {
    try {
      String nextStatus =
          (currentStatus == 'En attente') ? 'Confirmée' : 'En attente';

      await FirebaseFirestore.instance
          .collection('reservations')
          .doc(docId)
          .update({'status': nextStatus});

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Statut changé en : $nextStatus"),
            backgroundColor: Colors.purple,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      debugPrint("Erreur lors du changement de statut : $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Erreur lors du changement de statut"),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();

    if (context.mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => Login()),
        (route) => false,
      );
    }
  }

  Future<void> _deleteReservation(String docId) async {
    try {
      await FirebaseFirestore.instance
          .collection('reservations')
          .doc(docId)
          .delete();
    } catch (e) {
      debugPrint("Erreur lors de la suppression : $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Erreur lors de la suppression"),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
