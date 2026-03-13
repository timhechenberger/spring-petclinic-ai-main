import 'package:flutter/material.dart';

import 'add_animal_page.dart';
import 'animal_timeline_page.dart';
import '../../widgets/animal_list_item.dart';
import '../../services/owner_service.dart';
import '../../services/pet_service.dart';
import '../../services/owner_service.dart';
import '../../services/owner_session.dart';

class AnimalsPage extends StatefulWidget {
  const AnimalsPage({super.key});

  @override
  State<AnimalsPage> createState() => _AnimalsPageState();
}

class _AnimalsPageState extends State<AnimalsPage> {
  List<Map<String, dynamic>> animals = [];
  bool isLoading = true;
  String? errorMessage;

  static const green = Color(0xFF3E7C46);
  static const greyBox = Color(0xFFD9D9D9);
  static const bg = Color(0xFFF6EEF4);

  static const titleStyle = TextStyle(
    fontSize: 44,
    fontWeight: FontWeight.w800,
    color: green,
    height: 1.1,
  );

  @override
  void initState() {
    super.initState();
    OwnerSession.currentOwnerId.addListener(_handleOwnerChanged);
    _loadAnimals();
  }

  @override
  void dispose() {
    OwnerSession.currentOwnerId.removeListener(_handleOwnerChanged);
    super.dispose();
  }

  void _handleOwnerChanged() {
    _loadAnimals();
  }

  Future<void> _loadAnimals() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final loadedAnimals = await OwnerService.getPetsOfOwner(OwnerSession.ownerId);

      if (!mounted) return;

      setState(() {
        animals = loadedAnimals;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  Future<void> _openAddAnimal() async {
    final created = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: bg,
      builder: (_) => const AddAnimalPage(),
    );

    if (created == true) {
      await _loadAnimals();
    }
  }

  Future<void> _openTimeline(Map<String, dynamic> animal) async {
    final petId = animal['id'];

    if (petId == null) return;

    try {
      final fullAnimal = await PetService.getPetById(petId as int);
      final timeline = await PetService.getPetTimeline(petId);

      final animalWithTimeline = {
        ...fullAnimal,
        'timeline': timeline,
      };

      if (!mounted) return;

      await showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        useSafeArea: true,
        backgroundColor: bg,
        builder: (_) => AnimalTimelinePage(animal: animalWithTimeline),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Timeline konnte nicht geladen werden: $e'),
        ),
      );
    }
  }

  Widget _buildContent() {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Fehler beim Laden der Tiere',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text(
                errorMessage!,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 13),
              ),
              const SizedBox(height: 14),
              ElevatedButton(
                onPressed: _loadAnimals,
                style: ElevatedButton.styleFrom(
                  backgroundColor: green,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Erneut versuchen'),
              ),
            ],
          ),
        ),
      );
    }

    if (animals.isEmpty) {
      return const Center(
        child: Text(
          'Keine Tiere vorhanden',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadAnimals,
      child: ListView.separated(
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: animals.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          return AnimalListItem(
            animal: animals[index],
            onTap: () => _openTimeline(animals[index]),
          );
        },
      ),
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
            const Text('Meine Tiere', style: titleStyle),
            const SizedBox(height: 18),

            Expanded(
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: greyBox,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: _buildContent(),
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
                    'Tier hinzufügen',
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