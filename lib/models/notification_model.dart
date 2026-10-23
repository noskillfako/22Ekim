class AppNotificationModel {
  final String id;
  final String title;
  final String message;
  final DateTime timestamp;
  final String dateString;
  final String category;
  final bool isStreakBroken;
  final bool isRead;

  const AppNotificationModel({
    required this.id,
    required this.title,
    required this.message,
    required this.timestamp,
    required this.dateString,
    required this.category,
    this.isStreakBroken = false,
    this.isRead = false,
  });

  AppNotificationModel copyWith({
    String? id,
    String? title,
    String? message,
    DateTime? timestamp,
    String? dateString,
    String? category,
    bool? isStreakBroken,
    bool? isRead,
  }) {
    return AppNotificationModel(
      id: id ?? this.id,
      title: title ?? this.title,
      message: message ?? this.message,
      timestamp: timestamp ?? this.timestamp,
      dateString: dateString ?? this.dateString,
      category: category ?? this.category,
      isStreakBroken: isStreakBroken ?? this.isStreakBroken,
      isRead: isRead ?? this.isRead,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'message': message,
      'timestamp': timestamp.toIso8601String(),
      'dateString': dateString,
      'category': category,
      'isStreakBroken': isStreakBroken,
      'isRead': isRead,
    };
  }

  factory AppNotificationModel.fromJson(Map<String, dynamic> json) {
    return AppNotificationModel(
      id: json['id'] as String,
      title: json['title'] as String,
      message: json['message'] as String,
      timestamp: DateTime.tryParse(json['timestamp'] as String? ?? '') ?? DateTime.now(),
      dateString: json['dateString'] as String? ?? '',
      category: json['category'] as String? ?? 'general',
      isStreakBroken: json['isStreakBroken'] as bool? ?? false,
      isRead: json['isRead'] as bool? ?? false,
    );
  }
}
