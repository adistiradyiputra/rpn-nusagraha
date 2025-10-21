class ResearchActivity {
  final String id;
  final String title;
  final String category;
  final String status;
  final String location;
  final String locationType;
  final DateTime startDate;
  final DateTime endDate;
  final String description;
  final String? created; // Original creation date
  final DateTime? lastUpdated;
  final bool isEdited; // Track if activity has been edited (manual tracking)

  ResearchActivity({
    required this.id,
    required this.title,
    required this.category,
    required this.status,
    required this.location,
    required this.locationType,
    required this.startDate,
    required this.endDate,
    required this.description,
    this.created,
    this.lastUpdated,
    this.isEdited = false,
  });

  ResearchActivity copyWith({
    String? id,
    String? title,
    String? category,
    String? status,
    String? location,
    String? locationType,
    DateTime? startDate,
    DateTime? endDate,
    String? description,
    String? created,
    DateTime? lastUpdated,
    bool? isEdited,
  }) {
    return ResearchActivity(
      id: id ?? this.id,
      title: title ?? this.title,
      category: category ?? this.category,
      status: status ?? this.status,
      location: location ?? this.location,
      locationType: locationType ?? this.locationType,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      description: description ?? this.description,
      created: created ?? this.created,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      isEdited: isEdited ?? this.isEdited,
    );
  }
}
