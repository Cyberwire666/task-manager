import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/task_service.dart';

class TaskList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final tasks = context.watch<TaskService>().tasks;

    if (tasks.isEmpty) {
      return Center(
        child: Text(
          'No tasks found. Add a task to get started!',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white70),
        ),
      );
    }

    return ListView.builder(
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        final task = tasks[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          elevation: 8,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          color: task.isCompleted ? Colors.green.shade200 : Colors.deepPurple.shade200,
          child: ListTile(
            leading: Icon(
              task.isCompleted ? Icons.check_circle : Icons.radio_button_unchecked,
              color: task.isCompleted ? Colors.green : Colors.deepPurple,
              size: 30,
            ),
            title: Text(
              task.title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.white,
                decoration: task.isCompleted ? TextDecoration.lineThrough : null,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task.description,
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
                const SizedBox(height: 4),
                Text(
                  'Due: ${task.deadline.toString().split(' ')[0]}',
                  style: TextStyle(fontSize: 14, color: Colors.white60),
                ),
              ],
            ),
            trailing: IconButton(
              icon: const Icon(Icons.delete, color: Colors.redAccent),
              onPressed: () {
                context.read<TaskService>().deleteTask(task.id);
              },
            ),
            onTap: () {
              task.isCompleted = !task.isCompleted;
              context.read<TaskService>().updateTask(task);
            },
          ),
        );
      },
    );
  }
}
