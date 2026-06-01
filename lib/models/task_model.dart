/*  Defines the strict Task object blueprint (ID, title, isCompleted) 
    to ensure type safety. 
    We are upgrading our Task model by making all variables final and adding a copyWith 
    method. This allows us to duplicate a task and change just one property (like checking 
    it off) without mutating the original. */

class Task {
  final String id;
  final String title;
  final bool isCompleted;

  Task({required this.id, required this.title, this.isCompleted = false});

  // The Riverpod standard: A method to safely clone a task with updated values
  Task copyWith({String? id, String? title, bool? isCompleted}) {
    return Task(id: id ?? this.id, title: title ?? this.title, isCompleted: isCompleted ?? this.isCompleted);
  }
}
