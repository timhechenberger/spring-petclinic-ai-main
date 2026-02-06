import 'package:flutter/material.dart';

class AnimalTimelinePage extends StatelessWidget {
  final Map<String, dynamic> animal;

  const AnimalTimelinePage({super.key, required this.animal});

  static const greyBox = Color(0xFFD9D9D9);
  static const greenLight = Color(0xFF5ECF6B);
  static const bg = Color(0xFFF6EEF4);

  static const titleStyle = TextStyle(
    fontSize: 42,
    fontWeight: FontWeight.w800,
    color: Color(0xFF3E7C46),
    height: 1.1,
  );

  @override
  Widget build(BuildContext context) {
    final timeline = (animal["timeline"] as List?) ?? const [];
    final name = (animal["name"] as String?) ?? "Tier";

    return Container(
      color: bg,
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 22),
      child: Column(
        children: [
          // Back (weil es ein Modal ist)
          Row(
            children: [
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back),
              ),
            ],
          ),

          const SizedBox(height: 6),
          Align(
            alignment: Alignment.centerLeft,
            child: Text("Meine Tiere", style: titleStyle.copyWith(fontSize: 38)),
          ),
          const SizedBox(height: 14),

          SizedBox(
            width: double.infinity,
            height: 46,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: greenLight,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: Text(
                "Timeline von $name",
                style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
              ),
            ),
          ),

          const SizedBox(height: 14),

          Expanded(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: greyBox,
                borderRadius: BorderRadius.circular(14),
              ),
              child: timeline.isEmpty
                  ? const Center(
                child: Text(
                  "Keine Einträge vorhanden",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              )
                  : ListView.separated(
                itemCount: timeline.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  final entry = timeline[index] as Map<String, dynamic>;
                  return Container(
                    height: 52,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFCFCFCF),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "${entry["date"]}   ${entry["title"]}",
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
