import 'package:flutter/material.dart';
import 'models/task.dart';
import 'screens/task_screen.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

void main() {
  runApp(const TaskReminderApp());
}

class TaskReminderApp extends StatelessWidget {
  const TaskReminderApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task Reminder',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Task> _tasks = [
    Task(id: '1', title: 'Buy groceries', description: 'Milk, eggs, bread'),
    Task(id: '2', title: 'Walk the dog', description: '6:00 PM in the park'),
  ];

@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: const Text('Task Reminder'),
    ),
    body: ListView.builder(
      itemCount: _tasks.length,
      itemBuilder: (context, index) {
        final task = _tasks[index];
        return ListTile(
            leading: const Icon(Icons.check_box_outline_blank),
            title: Text(task.title),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (task.description != null && task.description!.isNotEmpty)
                  Text(task.description!),
                if (task.latitude != null && task.longitude != null)
                  Text(' ${task.latitude}, ${task.longitude}'),
                if (task.locationName != null && task.locationName!.isNotEmpty)
                  Text(' ${task.locationName}'),
              ],
            ),
          );


      },
    ),
    floatingActionButton: FloatingActionButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NewTaskScreen(
              onTaskCreated: (newTask) {
                setState(() {
                  _tasks.add(newTask);
                });
              },
            ),
          ),
        );
      },
      child: const Icon(Icons.add),
    ),
  );
}

}
