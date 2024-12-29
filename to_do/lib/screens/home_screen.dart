import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import '../services/task_service.dart';
import '../widgets/task_input.dart';
import '../widgets/task_list.dart';
import 'login_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authService = context.watch<AuthService>();
    final taskService = context.watch<TaskService>();

    if (authService.user != null) {
      taskService.listenToTasks(authService.user!.uid);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Your Tasks',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
        ),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: () {
              authService.logout();
              taskService.clearListener();

              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              );
            },
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.deepPurple, Colors.purpleAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "Add a Task:",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            TaskInput(),
            const Divider(thickness: 2, color: Colors.white70),
            Expanded(child: TaskList()),
          ],
        ),
      ),
    );
  }
}
