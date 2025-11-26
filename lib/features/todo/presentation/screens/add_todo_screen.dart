import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_managment/features/todo/domain/constants/todo_categories.dart';
import 'package:task_managment/features/todo/domain/entities/todo.dart';
import 'package:task_managment/features/todo/presentation/providers/todo_provider.dart';
import 'package:task_managment/widgets/app_bottom_button.dart';
import 'package:task_managment/widgets/custom_snackbar.dart';

class AddTodoScreen extends ConsumerStatefulWidget {
  final Todo? todo;
  const AddTodoScreen({super.key, this.todo});

  @override
  ConsumerState<AddTodoScreen> createState() => _AddTodoScreenState();
}

class _AddTodoScreenState extends ConsumerState<AddTodoScreen> {
  final _ctrl = TextEditingController();
  bool _loading = false;
  String _selectedCategory = todoCategories.first.name;

  @override
  void initState() {
    super.initState();
    if (widget.todo != null) {
      _ctrl.text = widget.todo!.todo;
      _selectedCategory = ref
          .read(todoServiceProvider)
          .deriveCategoryFromTodo(widget.todo!);
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_ctrl.text.trim().isEmpty) return;

    setState(() => _loading = true);

    try {
      if (widget.todo != null) {
        await ref
            .read(todoListProvider.notifier)
            .updateTodo(widget.todo!.id, _ctrl.text.trim(), _selectedCategory);

        if (mounted) {
          Navigator.pop(context);
          CustomSnackbar.show(context, 'Task updated successfully!');
        }
      } else {
        await ref
            .read(todoListProvider.notifier)
            .addTodo(_ctrl.text.trim(), status: _selectedCategory);
        if (mounted) {
          Navigator.pop(context);
          CustomSnackbar.show(context, 'Task added successfully!');
        }
      }
    } catch (e) {
      if (mounted) {
        CustomSnackbar.show(context, 'Error: $e');
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _showCategoryPicker() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Select Category',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ...todoCategories.map(
              (cat) => ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: cat.background,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(cat.icon, color: cat.color),
                ),
                title: Text(cat.name),
                onTap: () {
                  setState(() => _selectedCategory = cat.name);
                  Navigator.pop(ctx);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentCat = categoryByName(_selectedCategory);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final gradientColors = isDark
        ? const [Color(0xFF0F1115), Color(0xFF1C1F26)]
        : const [Color(0xFFF3F8FF), Color(0xFFFFFBF3)];
    final primaryTextColor = theme.textTheme.bodyLarge?.color ?? Colors.black87;
    final secondaryTextColor =
        theme.textTheme.bodyMedium?.color?.withOpacity(0.7) ??
            Colors.grey.shade500;
    final cardColor = theme.cardColor;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradientColors,
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 12,
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: Icon(
                          Icons.arrow_back,
                          color: theme.iconTheme.color,
                        ),
                      ),
                    ),
                    Text(
                      widget.todo != null ? 'Edit Task' : 'Add Task',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: primaryTextColor,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: cardColor,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(isDark ? 0.2 : 0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Task Group',
                              style: TextStyle(
                                fontSize: 13,
                                color: secondaryTextColor,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 12),
                            GestureDetector(
                              onTap: _showCategoryPicker,
                              child: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: currentCat.background,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Icon(
                                      currentCat.icon,
                                      color: currentCat.color,
                                      size: 20,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Text(
                                    currentCat.name,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: primaryTextColor,
                                    ),
                                  ),
                                  const Spacer(),
                                  Icon(
                                    Icons.keyboard_arrow_down,
                                    color: secondaryTextColor,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: cardColor,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(isDark ? 0.2 : 0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Description',
                              style: TextStyle(
                                fontSize: 13,
                                color: secondaryTextColor,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 12),
                            TextField(
                              controller: _ctrl,
                              maxLines: 6,
                              style: TextStyle(
                                fontSize: 16,
                                color: primaryTextColor,
                                height: 1.5,
                              ),
                              decoration: InputDecoration.collapsed(
                                hintText:
                                    'This application is designed for super shops...',
                                hintStyle: TextStyle(
                                  color: secondaryTextColor,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              AppBottomButton(
                text: _loading
                    ? (widget.todo != null ? 'Saving...' : 'Adding...')
                    : (widget.todo != null ? 'Save' : 'Add'),
                onPressed: _loading ? () {} : _submit,
                hasArrow: false,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
