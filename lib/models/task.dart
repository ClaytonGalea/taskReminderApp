class Task {
  String id;
  String title;
  String? description;
  double? latitude;
  double? longitude;
  String? locationName;

  Task({
    required this.id,
    required this.title,
    this.description,
    this.latitude,
    this.longitude,
    this.locationName
  });
}
