import 'package:flutter/material.dart';
import 'reservationPage.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String selectedCity = "All";

  final List<Map<String, String>> _seminars = const [
    {
      "price": "1500dt / jour",
      "surface": "300 m²",
      "imagePath": "assets/semina1.jpg",
      "description":
          "Situé à Sousse, salle moderne idéale pour conférences et séminaires.",
      "city": "Sousse",
    },
    {
      "price": "1200dt / jour",
      "surface": "250 m²",
      "imagePath": "assets/semina2.jpg",
      "description":
          "Situé à Monastir, espace équipé pour réunions professionnelles.",
      "city": "Monastir",
    },
    {
      "price": "1800dt / jour",
      "surface": "400 m²",
      "imagePath": "assets/semina3.jpg",
      "description": "Situé à Mahdia, grande salle premium pour événements.",
      "city": "Mahdia",
    },
    {
      "price": "800dt / jour",
      "surface": "200 m²",
      "imagePath": "assets/semina4.jpg",
      "description": "Situé à Tunis, salle accessible et économique.",
      "city": "Tunis",
    },
  ];

  final List<String> _cities = const [
    "Sousse",
    "Monastir",
    "Mahdia",
    "Tunis",
    "All",
  ];

  @override
  Widget build(BuildContext context) {
    final filteredSeminars =
        _seminars.where((seminar) {
          return selectedCity == "All" || seminar["city"] == selectedCity;
        }).toList();

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.purple, Colors.purpleAccent],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    "Location Salles Séminaires",
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

            SizedBox(
              height: 50,
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                scrollDirection: Axis.horizontal,
                itemCount: _cities.length,
                itemBuilder: (context, index) {
                  final city = _cities[index];
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(city),
                      selected: selectedCity == city,
                      selectedColor: Colors.purple,
                      backgroundColor: Colors.purple.shade200,
                      labelStyle: TextStyle(
                        color:
                            selectedCity == city ? Colors.white : Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                      onSelected: (_) {
                        setState(() {
                          selectedCity = city;
                        });
                      },
                    ),
                  );
                },
              ),
            ),

            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 8),
                itemCount: filteredSeminars.length,
                itemBuilder: (context, index) {
                  final seminar = filteredSeminars[index];
                  return SeminarCard(
                    price: seminar["price"]!,
                    surface: seminar["surface"]!,
                    imagePath: seminar["imagePath"]!,
                    description: seminar["description"]!,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SeminarCard extends StatelessWidget {
  final String price;
  final String surface;
  final String imagePath;
  final String description;

  const SeminarCard({
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
      elevation: 5,
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
                  const SizedBox(height: 10),

                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purple.shade100,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const ReservationPage(),
                          ),
                        );
                      },
                      child: const Text(
                        "Réserver",
                        style: TextStyle(color: Colors.black),
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
