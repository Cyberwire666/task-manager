import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart'; // Import for authentication services
import '../services/task_service.dart'; // Import for task management services

class TaskInput extends StatefulWidget {
  @override
  _TaskInputState createState() => _TaskInputState();
}

class _TaskInputState extends State<TaskInput> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _deadlineController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  DateTime? _selectedDeadline;

  @override
  Widget build(BuildContext context) {
    final authService = context.read<AuthService>();
    final taskService = context.read<TaskService>();

    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Form(
        key: _formKey,
        child: Card(
          elevation: 10,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.deepPurpleAccent, Colors.purple],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    labelText: 'Task Title',
                    labelStyle: const TextStyle(color: Colors.white),
                    filled: true,
                    fillColor: Colors.white24,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                  ),
                  style: const TextStyle(color: Colors.white),
                  validator: (value) =>
                      value == null || value.isEmpty ? 'Please enter a title' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _descriptionController,
                  decoration: InputDecoration(
                    labelText: 'Description',
                    labelStyle: const TextStyle(color: Colors.white),
                    filled: true,
                    fillColor: Colors.white24,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                  ),
                  style: const TextStyle(color: Colors.white),
                  validator: (value) =>
                      value == null || value.isEmpty ? 'Please enter a description' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _deadlineController,
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: 'Deadline',
                    labelStyle: const TextStyle(color: Colors.white),
                    filled: true,
                    fillColor: Colors.white24,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                  ),
                  style: const TextStyle(color: Colors.white),
                  onTap: () async {
                    final pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2100),
                    );
                    if (pickedDate != null) {
                      setState(() {
                        _selectedDeadline = pickedDate;
                        _deadlineController.text = pickedDate.toString().split(' ')[0];
                      });
                    }
                  },
                  validator: (value) =>
                      value == null || value.isEmpty ? 'Please select a deadline' : null,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    padding: const EdgeInsets.all(15),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate() && _selectedDeadline != null) {
                      final userId = authService.user!.uid;
                      final newTask = Task(
                        id: DateTime.now().toString(),
                        title: _titleController.text,
                        description: _descriptionController.text,
                        isCompleted: false,
                        deadline: _selectedDeadline!,
                        userId: userId,
                      );

                      taskService.createTask(newTask);

                      _titleController.clear();
                      _descriptionController.clear();
                      _deadlineController.clear();
                      setState(() {
                        _selectedDeadline = null;
                      });
                    }
                  },
                  child: const Text(
                    'Add',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _deadlineController.dispose();
    super.dispose();
  }
}
