import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import '../providers/todo_provider.dart';
import '../widgets/custom_snackbar.dart';
import '../widgets/app_bottom_button.dart';
import '../models/todo.dart';

class AddTodoScreen extends ConsumerStatefulWidget {
  final Todo? todo;
  const AddTodoScreen({super.key, this.todo});

  @override
  ConsumerState<AddTodoScreen> createState() => _AddTodoScreenState();
}

class _AddTodoScreenState extends ConsumerState<AddTodoScreen> {
  final _ctrl = TextEditingController();
  bool _loading = false;
  String _selectedCategory = 'To-do';

  final List<Map<String, dynamic>> _categories = [
    {
      'name': 'To-do',
      'icon': Iconsax.clipboard_text,
      'color': const Color(0xFF0085FF),
      'bg': const Color(0xFFE6F2FF),
    },
    {
      'name': 'In Progress',
      'icon': Iconsax.clock,
      'color': const Color(0xFFFF7D53),
      'bg': const Color(0xFFFFEFEB),
    },
    {
      'name': 'Completed',
      'icon': Iconsax.tick_circle,
      'color': const Color(0xFF6E3BFF),
      'bg': const Color(0xFFEBE5FF),
    },
  ];

  @override
  void initState() {
    super.initState();
    if (widget.todo != null) {
      _ctrl.text = widget.todo!.todo;
      if (widget.todo!.completed) {
        _selectedCategory = 'Completed';
      } else {
        if (widget.todo!.id % 2 == 0) {
          _selectedCategory = 'In Progress';
        } else {
          _selectedCategory = 'To-do';
        }
      }
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
        await ref.read(todoListProvider.notifier).addTodo(_ctrl.text.trim());
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
            ..._categories.map(
              (cat) => ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: cat['bg'],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(cat['icon'], color: cat['color']),
                ),
                title: Text(cat['name']),
                onTap: () {
                  setState(() => _selectedCategory = cat['name']);
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
    final currentCat = _categories.firstWhere(
      (c) => c['name'] == _selectedCategory,
      orElse: () => _categories[0],
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFF3F8FF), Color(0xFFFFFBF3)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
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
                        icon: const Icon(
                          Icons.arrow_back,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    Text(
                      widget.todo != null ? 'Edit Task' : 'Add Task',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
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
                      // Task Group Selector
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.03),
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
                                color: Colors.grey[500],
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
                                      color: currentCat['bg'],
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Icon(
                                      currentCat['icon'],
                                      color: currentCat['color'],
                                      size: 20,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Text(
                                    currentCat['name'],
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  const Spacer(),
                                  Icon(
                                    Icons.keyboard_arrow_down,
                                    color: Colors.grey[400],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Description Input
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.03),
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
                                color: Colors.grey[500],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 12),
                            TextField(
                              controller: _ctrl,
                              maxLines: 6,
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.black87,
                                height: 1.5,
                              ),
                              decoration: InputDecoration.collapsed(
                                hintText:
                                    'This application is designed for super shops...',
                                hintStyle: TextStyle(
                                  color: Colors.grey[400],
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

              // Bottom Button
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
