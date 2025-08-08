class TaskPriorityResult {
  final String task;
  final String priority;

  TaskPriorityResult({required this.task, required this.priority});

  factory TaskPriorityResult.fromJson(Map<String, dynamic> json) {
    return TaskPriorityResult(
      task: json['task'],
      priority: json['priority'],
    );
  }
}
