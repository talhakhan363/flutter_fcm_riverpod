/*  A ConsumerWidget that listens to the Riverpod state and renders 
    the high-contrast dark mode UI, swipe-to-delete animations, and the task list. 
    NOTE:
    When moving from standard Provider to Riverpod, the UI layer requires a few specific 
    but powerful syntax changes:
    1) We change StatelessWidget to a ConsumerWidget.
    2) The build method now takes a second parameter called WidgetRef ref. This ref is your 
       UI's direct line of communication to the Riverpod providers.
    3) Instead of context.watch(), we use ref.watch() to listen to data.
    4) Instead of context.read(), we use ref.read(taskProvider.notifier) to trigger functions. */

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/task_provider.dart';

// ⚡ 1. Change to ConsumerWidget
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  // ⚡ 2. Add WidgetRef ref to the build method
  Widget build(BuildContext context, WidgetRef ref) {
    // ⚡ 3. Use ref.watch to listen to the state
    final tasks = ref.watch(taskProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.cloud_done_outlined, color: Colors.tealAccent, size: 28),
            SizedBox(width: 10),
            Text(
              'RIVERPOD TASKS',
              style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 2.0, fontSize: 22, color: Colors.white),
            ),
          ],
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: tasks.isEmpty
          ? _buildEmptyState()
          : ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                final task = tasks[index];

                return Dismissible(
                  key: Key(task.id),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20.0),
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(color: Colors.redAccent.withOpacity(0.8), borderRadius: BorderRadius.circular(16)),
                    child: const Icon(Icons.delete_sweep, color: Colors.white, size: 30),
                  ),
                  onDismissed: (direction) {
                    // Capture data for the Undo function
                    final deletedTask = task;
                    final deletedIndex = index;

                    // ⚡ 4. Use ref.read(...notifier) to execute functions
                    ref.read(taskProvider.notifier).deleteTask(task.id);

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('Task deleted'),
                        backgroundColor: Colors.grey[900],
                        duration: const Duration(seconds: 2),
                        action: SnackBarAction(
                          label: 'Undo',
                          textColor: Colors.tealAccent,
                          onPressed: () {
                            ref.read(taskProvider.notifier).insertTask(deletedIndex, deletedTask);
                          },
                        ),
                      ),
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E1E1E),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.tealAccent.withOpacity(0.1)),
                      boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 8, offset: Offset(0, 4))],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        decoration: const BoxDecoration(
                          border: Border(left: BorderSide(color: Colors.tealAccent, width: 6)),
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          leading: Transform.scale(
                            scale: 1.2,
                            child: Checkbox(
                              value: task.isCompleted,
                              activeColor: Colors.tealAccent,
                              checkColor: Colors.black,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                              onChanged: (value) {
                                ref.read(taskProvider.notifier).toggleTaskStatus(task.id);
                              },
                            ),
                          ),
                          title: AnimatedDefaultTextStyle(
                            duration: const Duration(milliseconds: 300),
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              decoration: task.isCompleted ? TextDecoration.lineThrough : null,
                              color: task.isCompleted ? Colors.white38 : Colors.white,
                            ),
                            child: Text(task.title),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.tealAccent,
        foregroundColor: Colors.black,
        elevation: 6,
        onPressed: () => _showAddTaskSheet(context, ref),
        icon: const Icon(Icons.add, size: 24),
        label: const Text('New Task', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.task_alt, size: 80, color: Colors.tealAccent.withOpacity(0.3)),
          const SizedBox(height: 16),
          const Text(
            'All caught up!',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white70),
          ),
          const SizedBox(height: 8),
          const Text('Tap the button below to add a task.', style: TextStyle(color: Colors.white38, fontSize: 16)),
        ],
      ),
    );
  }

  // ⚡ Pass WidgetRef here so the dialog can talk to the provider
  void _showAddTaskSheet(BuildContext context, WidgetRef ref) {
    String newTaskTitle = '';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF1E1E1E),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, left: 24, right: 24, top: 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Add New Task',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              const SizedBox(height: 20),
              TextField(
                autofocus: true,
                textCapitalization: TextCapitalization.sentences,
                cursorColor: Colors.tealAccent,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'What needs to be done?',
                  hintStyle: const TextStyle(color: Colors.white38),
                  filled: true,
                  fillColor: const Color(0xFF121212),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.tealAccent, width: 1.5),
                  ),
                ),
                onChanged: (value) => newTaskTitle = value,
                onSubmitted: (value) {
                  if (value.trim().isNotEmpty) {
                    ref.read(taskProvider.notifier).addTask(value.trim());
                    Navigator.pop(context);
                  }
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.tealAccent,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 2,
                ),
                onPressed: () {
                  if (newTaskTitle.trim().isNotEmpty) {
                    ref.read(taskProvider.notifier).addTask(newTaskTitle.trim());
                    Navigator.pop(context);
                  }
                },
                child: const Text('Save Task', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 32),
            ],
          ),
        );
      },
    );
  }
}
