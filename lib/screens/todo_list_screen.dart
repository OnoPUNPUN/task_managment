import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import '../providers/todo_provider.dart';
import '../providers/theme_provider.dart';
import '../widgets/avatar_header.dart';
import '../widgets/date_chip.dart';
import '../widgets/filter_chip.dart';
import '../widgets/loading.dart';
import '../widgets/todo_card.dart';
import '../models/todo.dart';
import '../utils/app_date_utils.dart';
import 'dart:math';

class TodoListScreen extends ConsumerStatefulWidget {
  const TodoListScreen({super.key});
  @override
  ConsumerState<TodoListScreen> createState() => _TodoListScreenState();
}

class _TodoListScreenState extends ConsumerState<TodoListScreen> {
  int _selectedDateIndex = 2;
  String _selectedFilter = 'All';
  late int _avatarId;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _avatarId = Random().nextInt(70);
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      ref.read(todoListProvider.notifier).loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final todosAsync = ref.watch(todoListProvider);
    final todoService = ref.watch(todoServiceProvider);
    final dates = generateSurroundingDates(anchor: DateTime.now());

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
          bottom: false,
          child: Column(
            children: [
              AvatarHeader(
                name: 'Livia Vaccaro',
                avatar: NetworkImage(
                  'https://i.pravatar.cc/150?img=$_avatarId',
                ),
                onToggleTheme: () =>
                    ref.read(themeNotifierProvider.notifier).toggle(),
              ),
              const SizedBox(height: 24),

              SizedBox(
                height: 120,
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  scrollDirection: Axis.horizontal,
                  itemCount: dates.length,
                  itemBuilder: (_, idx) {
                    final d = dates[idx];
                    final sel = idx == _selectedDateIndex;
                    return DateChip(
                      month: shortMonth(d.month),
                      day: '${d.day}',
                      weekday: weekdayShort(d.weekday),
                      selected: sel,
                      onTap: () => setState(() => _selectedDateIndex = idx),
                    );
                  },
                  separatorBuilder: (_, __) => const SizedBox(width: 16),
                ),
              ),

              const SizedBox(height: 24),

              SizedBox(
                height: 50,
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (_, idx) {
                    final labels = ['All', 'To do', 'In Progress', 'Completed'];
                    final label = labels[idx];
                    return ReusableFilterChip(
                      label: label,
                      selected: _selectedFilter == label,
                      onTap: () => setState(() => _selectedFilter = label),
                    );
                  },
                  separatorBuilder: (_, __) => const SizedBox(width: 12),
                  itemCount: 4,
                ),
              ),

              const SizedBox(height: 24),

              Expanded(
                child: todosAsync.when(
                  data: (list) {
                    final filtered = todoService.filterTodos(
                      list,
                      _selectedFilter,
                    );
                    if (filtered.isEmpty)
                      return const Center(child: Text('No tasks found'));

                    return CustomRefreshIndicator(
                      onRefresh: () => ref
                          .read(todoListProvider.notifier)
                          .loadTodos(refresh: true),
                      builder:
                          (
                            BuildContext context,
                            Widget child,
                            IndicatorController controller,
                          ) {
                            return Stack(
                              alignment: Alignment.topCenter,
                              children: [
                                if (!controller.isIdle)
                                  Positioned(
                                    top: 35 * controller.value,
                                    child: SizedBox(
                                      width: 50,
                                      height: 50,
                                      child: Lottie.asset(
                                        'assets/animations/loading/blue_loading.json',
                                      ),
                                    ),
                                  ),
                                Transform.translate(
                                  offset: Offset(0, 100.0 * controller.value),
                                  child: child,
                                ),
                              ],
                            );
                          },
                      child: ListView.separated(
                        controller: _scrollController,
                        padding: const EdgeInsets.fromLTRB(24, 0, 24, 120),
                        itemCount: filtered.length + 1, // +1 for loader
                        separatorBuilder: (_, __) => const SizedBox(height: 16),
                        itemBuilder: (ctx, i) {
                          if (i == filtered.length) {
                            return Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Center(
                                child: SizedBox(
                                  width: 50,
                                  height: 50,
                                  child: Lottie.asset(
                                    'assets/animations/loading/blue_loading.json',
                                  ),
                                ),
                              ),
                            );
                          }
                          final Todo t = filtered[i];
                          return TodoCard(
                            todo: t,
                            onToggle: () => ref
                                .read(todoListProvider.notifier)
                                .toggleCompleted(t.id),
                          );
                        },
                      ),
                    );
                  },
                  loading: () => const Loading(),
                  error: (e, st) => Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Error: ${e.toString()}'),
                        const SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: () => ref
                              .read(todoListProvider.notifier)
                              .loadTodos(refresh: true),
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),

      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 20, right: 10),
        child: SizedBox(
          width: 64,
          height: 64,
          child: FloatingActionButton(
            backgroundColor: const Color(0xFF6E3BFF),
            elevation: 10,
            shape: const CircleBorder(),
            onPressed: () => Navigator.pushNamed(context, '/add'),
            child: const Icon(Icons.add, size: 32, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
