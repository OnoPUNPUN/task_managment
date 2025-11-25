import 'package:flutter/material.dart';

class DateChip extends StatelessWidget {
  final String month;
  final String day;
  final String weekday;
  final bool selected;
  final VoidCallback onTap;

  const DateChip({
    super.key,
    required this.month,
    required this.day,
    required this.weekday,
    this.selected = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bg = selected ? const Color(0xFF6E3BFF) : Colors.white;
    final txtColor = selected ? Colors.white : Colors.black87;
    final shadow = selected
        ? [
            BoxShadow(
              color: const Color(0xFF6E3BFF).withOpacity(0.14),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ]
        : [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 6),
            ),
          ];

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 78,
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(14),
          boxShadow: shadow,
        ),
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              month,
              style: TextStyle(fontSize: 12, color: txtColor.withOpacity(0.9)),
            ),
            const SizedBox(height: 6),
            Text(
              day,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: txtColor,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              weekday,
              style: TextStyle(fontSize: 12, color: txtColor.withOpacity(0.85)),
            ),
          ],
        ),
      ),
    );
  }
}
