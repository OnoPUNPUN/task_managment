import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:popover/popover.dart';
import 'package:task_managment/features/todo/domain/entities/todo.dart';
import 'package:task_managment/features/todo/presentation/providers/todo_provider.dart';

class TodoCard extends StatelessWidget {
  final Todo todo;
  final VoidCallback onToggle;

  const TodoCard({super.key, required this.todo, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    final completed = todo.completed;
    final theme = Theme.of(context);
    final textColor = theme.textTheme.bodyLarge?.color ?? Colors.black87;
    final mutedColor =
        theme.textTheme.bodyMedium?.color?.withOpacity(0.6) ?? Colors.grey.shade500;

    String statusText = completed ? 'Done' : 'To-do';
    Color statusBg = completed
        ? const Color(0xFFEBE5FF)
        : const Color(0xFFE6F2FF);
    Color statusTextCol = completed
        ? const Color(0xFF6E3BFF)
        : const Color(0xFF0085FF);

    if (!completed && todo.id % 2 == 0) {
      statusText = 'In Progress';
      statusBg = const Color(0xFFFFEFEB);
      statusTextCol = const Color(0xFFFF7D53);
    }

    final iconBgColor = const Color(0xFFFFE4F2);
    final iconColor = const Color(0xFFFF4694);

    IconData categoryIcon = Iconsax.briefcase;
    if (todo.id % 3 == 0) categoryIcon = Iconsax.user;
    if (todo.id % 3 == 1) categoryIcon = Iconsax.book;

    return GestureDetector(
      onLongPress: () {
        showPopover(
          context: context,
          bodyBuilder: (context) => _TodoMenuItems(todo: todo),
          direction: PopoverDirection.bottom,
          width: 150,
          height: 120,
          arrowHeight: 15,
          arrowWidth: 30,
        );
      },
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(24),
        ),
        padding: const EdgeInsets.all(20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'ID: ${todo.id.toString().padLeft(2, '0')}',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: mutedColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    todo.todo,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: textColor,
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
                        '10:00 AM (10 minutes ago)',
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
      ),
    );
  }
}

class _TodoMenuItems extends StatelessWidget {
  final Todo todo;
  const _TodoMenuItems({required this.todo});

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        return Column(
          children: [
            InkWell(
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/add', arguments: todo);
              },
              child: Container(
                height: 50,
                alignment: Alignment.center,
                child: const Text('Edit', style: TextStyle(fontSize: 16)),
              ),
            ),
            const Divider(height: 1),
            InkWell(
              onTap: () {
                Navigator.pop(context);
                ref.read(todoListProvider.notifier).deleteTodo(todo.id);
              },
              child: Container(
                height: 50,
                alignment: Alignment.center,
                child: const Text(
                  'Delete',
                  style: TextStyle(fontSize: 16, color: Colors.red),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
