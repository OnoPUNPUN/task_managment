import 'package:flutter/material.dart';
import '../models/todo.dart';

class TodoCard extends StatelessWidget {
  final Todo todo;
  final VoidCallback onToggle;
  final VoidCallback onDelete;

  const TodoCard({
    super.key,
    required this.todo,
    required this.onToggle,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final completed = todo.completed;
    return Material(
      borderRadius: BorderRadius.circular(14),
      elevation: 2,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
        ),
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            // left column (ID + title + time)
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'ID: ${todo.id.toString().padLeft(2, '0')}',
                    style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    todo.todo,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      decoration: completed ? TextDecoration.lineThrough : null,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(
                        Icons.access_time,
                        size: 14,
                        color: Color(0xFF8E8EAF),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '07:00 PM',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.purple[300],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // right column (status chip + delete)
            Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF0F6),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.all(8),
                  child: Icon(
                    Icons.work_outline,
                    color: const Color(0xFFEE6FA1),
                  ),
                ),
                const SizedBox(height: 12),
                GestureDetector(
                  onTap: onToggle,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: completed
                          ? const Color(0xFFE9F6FF)
                          : const Color(0xFFF3E9FF),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      completed ? 'Done' : 'To-do',
                      style: TextStyle(
                        color: completed ? Colors.blue : Colors.deepPurple,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                IconButton(
                  onPressed: onDelete,
                  icon: const Icon(
                    Icons.delete_outline,
                    color: Colors.redAccent,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
