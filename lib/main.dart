import 'package:flutter/material.dart';
import 'models/task.dart';
import 'screens/task_screen.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:accessibility_tools/accessibility_tools.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();


  // Initialize the notification system
  await AwesomeNotifications().initialize(
    null,
    [
      NotificationChannel(
        channelKey: 'basic_channel',
        channelName: 'Task Reminders',
        channelDescription: 'Channel for task notifications',
        defaultColor: Color(0xFF9D50DD),
        ledColor: Colors.white,
        importance: NotificationImportance.High,
        criticalAlerts: true,
        locked: true,
    ),

    ],
    debug: true,
  );

  // Ask for permission
  bool isAllowed = await AwesomeNotifications().isNotificationAllowed();
  if (!isAllowed) {
    AwesomeNotifications().requestPermissionToSendNotifications();
  }

  runApp(const TaskReminderApp());
}

class TaskReminderApp extends StatelessWidget {
  const TaskReminderApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: (context, child) => AccessibilityTools(child: child,buttonsAlignment: ButtonsAlignment.bottomLeft,),
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
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () async {
              await AwesomeNotifications().createNotification(
                content: NotificationContent(
                  id: 999,
                  channelKey: 'basic_channel',
                  title: 'Reminder Notification',
                  body: 'Please check your remaining tasks',
                ),
              );
            },
            child: const Text("Alert Notification"),
          ),
          Expanded(
            child: ListView.builder(
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
                      if (task.description != null &&
                          task.description!.isNotEmpty)
                        Text(task.description!),
                      if (task.latitude != null && task.longitude != null)
                        Text(' ${task.latitude}, ${task.longitude}'),
                      if (task.locationName != null &&
                          task.locationName!.isNotEmpty)
                        Text(' ${task.locationName}'),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
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
