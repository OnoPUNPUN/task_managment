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

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 72,
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              month,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: txtColor.withOpacity(selected ? 1.0 : 0.6),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              day,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: txtColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              weekday,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: txtColor.withOpacity(selected ? 1.0 : 0.6),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
