class ActivityLogModel {
  final String id;
  final String habitId;
  final String category;
  final String date; // 'YYYY-MM-DD'
  final int? durationMinutes;
  final double? distanceKm;
  final int? pagesRead;
  final int? bookTotalPages;
  final String? bookGenre;
  final bool? isBookFinished;
  final double? waterLiters;
  final double? caloriesBurned;
  final int? mealCalories;
  final double? caloriesSaved;
  final int? smokedCount;
  final int? avoidedCount;
  final double? moneySavedTL;

  const ActivityLogModel({
    required this.id,
    required this.habitId,
    required this.category,
    required this.date,
    this.durationMinutes,
    this.distanceKm,
    this.pagesRead,
    this.bookTotalPages,
    this.bookGenre,
    this.isBookFinished,
    this.waterLiters,
    this.caloriesBurned,
    this.mealCalories,
    this.caloriesSaved,
    this.smokedCount,
    this.avoidedCount,
    this.moneySavedTL,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'habitId': habitId,
      'category': category,
      'date': date,
      'durationMinutes': durationMinutes,
      'distanceKm': distanceKm,
      'pagesRead': pagesRead,
      'bookTotalPages': bookTotalPages,
      'bookGenre': bookGenre,
      'isBookFinished': isBookFinished,
      'waterLiters': waterLiters,
      'caloriesBurned': caloriesBurned,
      'mealCalories': mealCalories,
      'caloriesSaved': caloriesSaved,
      'smokedCount': smokedCount,
      'avoidedCount': avoidedCount,
      'moneySavedTL': moneySavedTL,
    };
  }

  factory ActivityLogModel.fromJson(Map<String, dynamic> json) {
    return ActivityLogModel(
      id: json['id'] as String,
      habitId: json['habitId'] as String,
      category: json['category'] as String,
      date: json['date'] as String,
      durationMinutes: (json['durationMinutes'] as num?)?.toInt(),
      distanceKm: (json['distanceKm'] as num?)?.toDouble(),
      pagesRead: (json['pagesRead'] as num?)?.toInt(),
      bookTotalPages: (json['bookTotalPages'] as num?)?.toInt(),
      bookGenre: json['bookGenre'] as String?,
      isBookFinished: json['isBookFinished'] as bool?,
      waterLiters: (json['waterLiters'] as num?)?.toDouble(),
      caloriesBurned: (json['caloriesBurned'] as num?)?.toDouble(),
      mealCalories: (json['mealCalories'] as num?)?.toInt(),
      caloriesSaved: (json['caloriesSaved'] as num?)?.toDouble(),
      smokedCount: (json['smokedCount'] as num?)?.toInt(),
      avoidedCount: (json['avoidedCount'] as num?)?.toInt(),
      moneySavedTL: (json['moneySavedTL'] as num?)?.toDouble(),
    );
  }
}
