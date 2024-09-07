import 'package:flutter/material.dart';
import '../task.dart';

class TaskListTile extends StatelessWidget {
  final Task task;
  final Function(int) onDelete;
  final Function(int) onToggleCompletion;
  final VoidCallback onToggleExpansion;

  TaskListTile({
    required this.task,
    required this.onDelete,
    required this.onToggleCompletion,
    required this.onToggleExpansion,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.blueAccent),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  '${task.time}', // Time always visible
                  style: TextStyle(fontSize: 16),
                ),
              ),
              Text(
                _getTaskStatusText(task), // Task status in "X/Y task(s) completed" format
                style: TextStyle(
                  fontSize: 16,
                  color: _getTaskStatusColor(task), // Color based on completion status
                ),
              ),
              IconButton(
                icon: Icon(
                  task.isExpanded
                      ? Icons.arrow_drop_up
                      : Icons.arrow_drop_down,
                ),
                onPressed: onToggleExpansion,
              ),
            ],
          ),
          if (task.isExpanded)
            Column(
              children: task.items.asMap().entries.map((entry) {
                int itemIndex = entry.key;
                TaskItem taskItem = entry.value;
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Checkbox(
                    value: taskItem.isCompleted,
                    onChanged: (bool? value) {
                      onToggleCompletion(itemIndex);
                    },
                    activeColor: Colors.green,
                  ),
                  title: Text(
                    taskItem.text,
                    style: TextStyle(
                      decoration: taskItem.isCompleted
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                    ),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit, color: Colors.orange),
                        onPressed: () {
                          // Handle edit task logic (if needed)
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.black),
                        onPressed: () {
                          onDelete(itemIndex);
                        },
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
        ],
      ),
    );
  }

  int _countCheckedTasks(Task task) {
    return task.items.where((item) => item.isCompleted).length;
  }

  Color _getTaskStatusColor(Task task) {
    int completedTasks = _countCheckedTasks(task);
    if (completedTasks == 0) {
      return Colors.grey; // No tasks completed
    } else if (completedTasks == task.items.length) {
      return Colors.green; // All tasks completed
    } else {
      return Colors.orange; // Some tasks completed
    }
  }

  String _getTaskStatusText(Task task) {
    int completedTasks = _countCheckedTasks(task);
    int totalTasks = task.items.length;
    if (completedTasks == totalTasks && totalTasks > 0) {
      return 'Completed'; // All tasks are done
    } else {
      return '$completedTasks/$totalTasks task completed'; // Partial or no completion
    }
  }
}
