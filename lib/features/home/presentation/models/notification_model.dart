class NotificationModel {
  final String id;
  final String title;
  final String message;
  final String time;
  final bool isRead;
  final String moduleName;
  final String subModuleName;

  NotificationModel({
    required this.id,
    required this.title,
    required this.message,
    required this.time,
    required this.isRead,
    required this.moduleName,
    required this.subModuleName,
  });

  NotificationModel copyWith({
    String? id,
    String? title,
    String? message,
    String? time,
    bool? isRead,
    String? moduleName,
    String? subModuleName,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      title: title ?? this.title,
      message: message ?? this.message,
      time: time ?? this.time,
      isRead: isRead ?? this.isRead,
      moduleName: moduleName ?? this.moduleName,
      subModuleName: subModuleName ?? this.subModuleName,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'message': message,
      'time': time,
      'isRead': isRead,
      'moduleName': moduleName,
      'subModuleName': subModuleName,
    };
  }

  factory NotificationModel.fromMap(Map<String, dynamic> map) {
    return NotificationModel(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      message: map['message'] ?? '',
      time: map['time'] ?? '',
      isRead: map['isRead'] ?? false,
      moduleName: map['moduleName'] ?? '',
      subModuleName: map['subModuleName'] ?? '',
    );
  }
}
