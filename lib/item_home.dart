import 'package:flutter/material.dart';
import 'reservationPage.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple.shade50,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Colors.purple, Colors.purpleAccent],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    "Bienvenue sur SeminaSpace",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  Icon(Icons.notifications, color: Colors.white),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              child: SizedBox(
                height: 50,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: const [
                    _FilterChip(label: "Sousse"),
                    _FilterChip(label: "Monastir"),
                    _FilterChip(label: "Mahdia"),
                    _FilterChip(label: "Tunis"),
                    _FilterChip(label: "All"),
                  ],
                ),
              ),
            ),

            Expanded(
              child: ListView(
                padding: const EdgeInsets.only(bottom: 16),
                children: const [
                  SeminaItem(
                    price: "1500dt par jour",
                    surface: "300 m²",
                    imagePath: "assets/semina1.jpg",
                    description:
                        "Situé à Sousse, à moins de 700 mètres de la gare du Nord et à moins de 1 km de la gare de l'Est",
                  ),
                  SeminaItem(
                    price: "1200dt par jour",
                    surface: "250 m²",
                    imagePath: "assets/semina2.jpg",
                    description:
                        "Situé à Monastir, à moins de 700 mètres de la gare du Nord et à moins de 1 km de la gare de l'Est",
                  ),
                  SeminaItem(
                    price: "1800dt par jour",
                    surface: "400 m²",
                    imagePath: "assets/semina3.jpg",
                    description:
                        "Situé à Mahdia, à moins de 700 mètres de la gare du Nord et à moins de 1 km de la gare de l'Est",
                  ),
                  SeminaItem(
                    price: "800dt par jour",
                    surface: "200 m²",
                    imagePath: "assets/semina4.jpg",
                    description:
                        "Situé à Tunis, à moins de 700 mètres de la gare du Nord et à moins de 1 km de la gare de l'Est",
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  const _FilterChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      child: Chip(
        label: Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.purple.shade400,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      ),
    );
  }
}

class SeminaItem extends StatelessWidget {
  final String price;
  final String surface;
  final String imagePath;
  final String description;

  const SeminaItem({
    super.key,
    required this.price,
    required this.surface,
    required this.imagePath,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.horizontal(
              left: Radius.circular(16),
            ),
            child: Image.asset(
              imagePath,
              width: 120,
              height: 140,
              fit: BoxFit.cover,
            ),
          ),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    price,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.purple,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(surface, style: TextStyle(color: Colors.grey.shade600)),
                  const SizedBox(height: 8),
                  Text(
                    description,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),

                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ReservationPage(),
                          ),
                        );
                      },
                      child: const Text(
                        "Réserver",
                        style: TextStyle(color: Colors.purple),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
