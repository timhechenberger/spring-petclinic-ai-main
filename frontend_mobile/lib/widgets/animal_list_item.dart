import 'package:flutter/material.dart';

class AnimalListItem extends StatelessWidget {
  final Map<String, dynamic> animal;
  final VoidCallback onTap;

  const AnimalListItem({
    super.key,
    required this.animal,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        height: 50,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: const Color(0xFFCFCFCF),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                "Tier: ${animal["type"]} - (${animal["name"]}) | Status",
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(width: 10),
            const Icon(Icons.sentiment_satisfied_alt, size: 20),
          ],
        ),
      ),
    );
  }
}
