import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import '../models/todo.dart';

class TodoCard extends StatelessWidget {
  final Todo todo;
  final VoidCallback onToggle;
  // Delete callback removed as per design requirement

  const TodoCard({super.key, required this.todo, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    final completed = todo.completed;

    // Determine status text and color based on completion
    // In a real app, this might come from the model, but for now we infer:
    // If completed -> "Done" (Purple bg, White text) or similar
    // If not completed -> "To-do" (Blue bg, Blue text) or "In Progress" (Orange bg, Orange text)
    // The design shows different statuses. I'll map them based on ID for variety or just use logic.

    String statusText = completed ? 'Done' : 'To-do';
    Color statusBg = completed
        ? const Color(0xFFEBE5FF)
        : const Color(0xFFE6F2FF);
    Color statusTextCol = completed
        ? const Color(0xFF6E3BFF)
        : const Color(0xFF0085FF);

    // Hardcoding some variation for "In Progress" based on ID for demo purposes to match design variety
    if (!completed && todo.id % 2 == 0) {
      statusText = 'In Progress';
      statusBg = const Color(0xFFFFEFEB);
      statusTextCol = const Color(0xFFFF7D53);
    }

    // Icon box color
    final iconBgColor = const Color(0xFFFFE4F2);
    final iconColor = const Color(0xFFFF4694);

    // Icon based on ID for variety
    IconData categoryIcon = Iconsax.briefcase;
    if (todo.id % 3 == 0) categoryIcon = Iconsax.user;
    if (todo.id % 3 == 1) categoryIcon = Iconsax.book;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      padding: const EdgeInsets.all(20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left Column
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'ID: ${todo.id.toString().padLeft(2, '0')}',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[500],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  todo.todo,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                    height: 1.3,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Icon(
                      Iconsax.clock,
                      size: 16,
                      color: const Color(0xFF6E3BFF).withOpacity(0.6),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '10:00 AM (10 minutes ago)', // Placeholder time as requested to match design style or dynamic
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF6E3BFF).withOpacity(0.6),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(width: 16),

          // Right Column
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: iconBgColor,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(categoryIcon, color: iconColor, size: 24),
              ),
              const SizedBox(height: 24),
              GestureDetector(
                onTap: onToggle,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: statusBg,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    statusText,
                    style: TextStyle(
                      color: statusTextCol,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
