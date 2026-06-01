/*  Houses the StateNotifier and StateNotifierProvider. This is the Riverpod 
    equivalent of the Week 6 provider task, offering immutable state updates and better 
    compile-time safety. 
    DIFFERENCE: Riverpod enforces immutability. Instead of modifying an existing list and yelling 
    notifyListeners() like we did in the standard Provider, Riverpod requires us to create 
    a brand new list every time a state changes. It is safer, faster, and highly preferred 
    in enterprise software. 
    Now we extend StateNotifier instead of ChangeNotifier. Whenever we assign a new 
    value to state, Riverpod automatically rebuilds the UI. No notifyListeners() required. */

import 'package:flutter_riverpod/flutter_riverpod.dart'; // The Riverpod package for state management
import '../models/task_model.dart'; // The Task model defines the structure of our tasks (id, title, isCompleted)

// 1. The Notifier (The Logic)
class TaskNotifier extends StateNotifier<List<Task>> {
  TaskNotifier() : super([]); // Initial state is an empty list

  void addTask(String title) {
    final newTask = Task(id: DateTime.now().toString(), title: title);
    // ⚡ Spread operator [...state] creates a new list with the old items, plus the new one
    state = [...state, newTask];
  }

  void toggleTaskStatus(String id) {
    // ⚡ Map through the old state. If we find the task, return a 'copyWith' cloned version.
    state = state.map((task) {
      if (task.id == id) {
        return task.copyWith(isCompleted: !task.isCompleted);
      }
      return task;
    }).toList();
  }

  void deleteTask(String id) {
    // ⚡ Filter out the deleted task and return a new list
    state = state.where((task) => task.id != id).toList();
  }

  // Maintaining your excellent Undo feature!
  void insertTask(int index, Task task) {
    final newState = [...state];
    newState.insert(index, task);
    state = newState;
  }
}

// 2. The Global Provider Declaration (How the UI accesses the logic)
final taskProvider = StateNotifierProvider<TaskNotifier, List<Task>>((ref) {
  return TaskNotifier();
});
