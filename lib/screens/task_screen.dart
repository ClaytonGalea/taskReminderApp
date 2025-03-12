import 'package:flutter/material.dart';
import '../models/task.dart';
import 'package:uuid/uuid.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';


class NewTaskScreen extends StatefulWidget {
  final Function(Task) onTaskCreated;

  const NewTaskScreen({super.key, required this.onTaskCreated});

  @override
  State<NewTaskScreen> createState() => _NewTaskScreenState();
}

class _NewTaskScreenState extends State<NewTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  double? _latitude;
  double? _longitude;
  String? _placeName;


  void _saveTask() {
    if (_formKey.currentState!.validate()) {
      final newTask = Task(
        id: const Uuid().v4(),
        title: _titleController.text,
        description: _descriptionController.text,
        latitude: _latitude,
        longitude: _longitude,
        locationName: _placeName
      );

      widget.onTaskCreated(newTask);
      Navigator.pop(context);
    }
  }
Future<void> _getCurrentLocation() async {
  bool serviceEnabled;
  LocationPermission permission;

  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    await Geolocator.openLocationSettings();
    return;
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      return;
    }
  }

  if (permission == LocationPermission.deniedForever) {
    return;
  }

  final position = await Geolocator.getCurrentPosition();

  // Converting the GPS into human readable address
  List<Placemark> placemarks = await placemarkFromCoordinates(
    position.latitude,
    position.longitude,
  );

  final place = placemarks.first;

  setState(() {
    _latitude = position.latitude;
    _longitude = position.longitude;
    _placeName = '${place.street}, ${place.locality} ${place.country}';
  });

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        '📍 ${place.street}, ${place.locality}, ${place.country}',
      ),
    ),
  );
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Task')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Task Title'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Title is required' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
              ),ElevatedButton.icon(
                onPressed: _getCurrentLocation,
                icon: const Icon(Icons.my_location),
                label: const Text("Use My Location"),
              ),
              if (_latitude != null && _longitude != null)
                Text('📍 $_latitude, $_longitude'),
              const SizedBox(height: 16),

              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _saveTask,
                child: const Text('Save Task'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
