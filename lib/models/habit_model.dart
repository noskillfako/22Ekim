import 'package:flutter/material.dart';

class HabitModel {
  final String id;
  final String userId;
  final String title;
  final String category; // 'reading', 'swimming', 'fitness', 'running', 'mind_games', 'water', 'other_sports', 'healthy_food', 'quit_smoking', 'quit_alcohol'
  final String colorHex;
  final String animationAsset;
  final int currentStreak;
  final int longestStreak;
  final String? lastCompletedDate; // 'YYYY-MM-DD'

  const HabitModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.category,
    required this.colorHex,
    required this.animationAsset,
    this.currentStreak = 0,
    this.longestStreak = 0,
    this.lastCompletedDate,
  });

  HabitModel copyWith({
    String? id,
    String? userId,
    String? title,
    String? category,
    String? colorHex,
    String? animationAsset,
    int? currentStreak,
    int? longestStreak,
    String? lastCompletedDate,
  }) {
    return HabitModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      category: category ?? this.category,
      colorHex: colorHex ?? this.colorHex,
      animationAsset: animationAsset ?? this.animationAsset,
      currentStreak: currentStreak ?? this.currentStreak,
      longestStreak: longestStreak ?? this.longestStreak,
      lastCompletedDate: lastCompletedDate ?? this.lastCompletedDate,
    );
  }

  Color get color {
    try {
      final hex = colorHex.replaceAll('#', '');
      return Color(int.parse('FF$hex', radix: 16));
    } catch (_) {
      return const Color(0xFF2563EB);
    }
  }

  IconData get icon {
    switch (category) {
      case 'reading':
        return Icons.menu_book_rounded;
      case 'swimming':
        return Icons.pool_rounded;
      case 'fitness':
        return Icons.fitness_center_rounded;
      case 'running':
        return Icons.directions_run_rounded;
      case 'mind_games':
        return Icons.psychology_rounded;
      case 'water':
        return Icons.water_drop_rounded;
      case 'healthy_food':
        return Icons.restaurant_rounded;
      case 'quit_smoking':
        return Icons.smoke_free_rounded;
      case 'quit_alcohol':
        return Icons.no_drinks_rounded;
      case 'other_sports':
      default:
        return Icons.sports_rounded;
    }
  }

  String get categoryTitle {
    switch (category) {
      case 'reading':
        return 'Kitap Okuma';
      case 'swimming':
        return 'Yüzme';
      case 'fitness':
        return 'Fitness';
      case 'running':
        return 'Koşu';
      case 'mind_games':
        return 'Zeka Oyunları';
      case 'water':
        return 'Su İçme';
      case 'healthy_food':
        return 'Sağlıklı Beslenme';
      case 'quit_smoking':
        return 'Sigara Bırakma';
      case 'quit_alcohol':
        return 'Alkol Bırakma';
      case 'other_sports':
      default:
        return 'Diğer Sporlar';
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'title': title,
      'category': category,
      'colorHex': colorHex,
      'animationAsset': animationAsset,
      'currentStreak': currentStreak,
      'longestStreak': longestStreak,
      'lastCompletedDate': lastCompletedDate,
    };
  }

  factory HabitModel.fromJson(Map<String, dynamic> json) {
    return HabitModel(
      id: json['id'] as String,
      userId: json['userId'] as String? ?? 'user_1',
      title: json['title'] as String,
      category: json['category'] as String,
      colorHex: json['colorHex'] as String? ?? '#2563EB',
      animationAsset: json['animationAsset'] as String? ?? '',
      currentStreak: (json['currentStreak'] as num?)?.toInt() ?? 0,
      longestStreak: (json['longestStreak'] as num?)?.toInt() ?? 0,
      lastCompletedDate: json['lastCompletedDate'] as String?,
    );
  }
}
