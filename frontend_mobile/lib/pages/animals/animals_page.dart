import 'package:flutter/material.dart';

import 'add_animal_page.dart';
import 'animal_timeline_page.dart';
import '../../widgets/animal_list_item.dart';

class AnimalsPage extends StatefulWidget {
  const AnimalsPage({super.key});

  @override
  State<AnimalsPage> createState() => _AnimalsPageState();
}

class _AnimalsPageState extends State<AnimalsPage> {
  // MOCK-DATEN
  List<Map<String, dynamic>> animals = [
    {
      "id": 1,
      "name": "Bello",
      "type": "Hund",
      "status": "OK",
      "birthdate": "2020-03-18",
      "timeline": [
        {"date": "18.03.2020 14:30", "title": "Kastration"},
        {"date": "10.06.2021 09:00", "title": "Impfung"},
      ],
    },
    {
      "id": 2,
      "name": "Mimi",
      "type": "Katze",
      "status": "Check",
      "birthdate": "2019-11-02",
      "timeline": [
        {"date": "12.01.2020 10:15", "title": "Impfung"},
      ],
    },
  ];

  static const green = Color(0xFF3E7C46);
  static const greyBox = Color(0xFFD9D9D9);
  static const bg = Color(0xFFF6EEF4);

  // Typo wie Figma (größer, fetter)
  static const titleStyle = TextStyle(
    fontSize: 44,
    fontWeight: FontWeight.w800,
    color: green,
    height: 1.1,
  );

  Future<void> _openAddAnimal() async {
    final newAnimal = await showModalBottomSheet<Map<String, dynamic>>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: bg,
      builder: (_) => const AddAnimalPage(),
    );

    if (newAnimal != null) {
      setState(() {
        animals.add(newAnimal);
      });
    }
  }

  Future<void> _openTimeline(Map<String, dynamic> animal) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: bg,
      builder: (_) => AnimalTimelinePage(animal: animal),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: bg,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 56),
            const Text("Meine Tiere", style: titleStyle),
            const SizedBox(height: 18),

            // Grauer Scroll-Container
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: greyBox,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: animals.isEmpty
                    ? const Center(
                  child: Text(
                    "Keine Tiere vorhanden",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                )
                    : ListView.separated(
                  itemCount: animals.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    return AnimalListItem(
                      animal: animals[index],
                      onTap: () => _openTimeline(animals[index]),
                    );
                  },
                ),
              ),
            ),

            const SizedBox(height: 18),

            Center(
              child: SizedBox(
                width: 260,
                height: 44,
                child: ElevatedButton(
                  onPressed: _openAddAnimal,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: green,
                    foregroundColor: Colors.white,
                    elevation: 4,
                    shadowColor: Colors.black54,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  child: const Text(
                    "Tier hinzufügen",
                    style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
