import 'package:flutter/material.dart';

class BadgeModel {
  final String id;
  final String title;
  final String description;
  final String category;
  final String tier; // 'bronze', 'silver', 'gold', 'diamond'
  final double targetValue;
  final double currentValue;
  final String unit;
  final bool isUnlocked;
  final DateTime? unlockedAt;

  const BadgeModel({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.tier,
    required this.targetValue,
    required this.currentValue,
    required this.unit,
    this.isUnlocked = false,
    this.unlockedAt,
  });

  BadgeModel copyWith({
    String? id,
    String? title,
    String? description,
    String? category,
    String? tier,
    double? targetValue,
    double? currentValue,
    String? unit,
    bool? isUnlocked,
    DateTime? unlockedAt,
  }) {
    return BadgeModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      tier: tier ?? this.tier,
      targetValue: targetValue ?? this.targetValue,
      currentValue: currentValue ?? this.currentValue,
      unit: unit ?? this.unit,
      isUnlocked: isUnlocked ?? this.isUnlocked,
      unlockedAt: unlockedAt ?? this.unlockedAt,
    );
  }

  double get progressPercent {
    if (targetValue <= 0) return 0.0;
    return (currentValue / targetValue).clamp(0.0, 1.0);
  }

  Color get tierColor {
    switch (tier) {
      case 'bronze':
        return const Color(0xFFCD7F32);
      case 'silver':
        return const Color(0xFFB0BEC5);
      case 'gold':
        return const Color(0xFFFFD700);
      case 'diamond':
        return const Color(0xFF00E5FF);
      default:
        return const Color(0xFFFFD700);
    }
  }

  IconData get icon {
    switch (id) {
      case 'gold_librarian_100':
        return Icons.auto_stories_rounded;
      case 'bronze_reader_10':
      case 'silver_bookworm_50':
        return Icons.menu_book_rounded;
      case 'page_master_5000':
        return Icons.import_contacts_rounded;
      case 'blue_dolphin_500':
      case 'poseidon_2000':
        return Icons.pool_rounded;
      case 'marathoner_100':
        return Icons.directions_run_rounded;
      case 'source_of_life_100':
        return Icons.water_drop_rounded;
      case 'iron_will_1500':
        return Icons.fitness_center_rounded;
      case 'calorie_hunter_10000':
        return Icons.local_fire_department_rounded;
      case 'clean_breath_500':
        return Icons.eco_rounded;
      case 'piggy_bank_master_5000':
        return Icons.savings_rounded;
      case 'chain_breaker_7':
      case 'habit_master_30':
        return Icons.bolt_rounded;
      case 'mind_master_300':
        return Icons.psychology_rounded;
      default:
        return Icons.military_tech_rounded;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'category': category,
      'tier': tier,
      'targetValue': targetValue,
      'currentValue': currentValue,
      'unit': unit,
      'isUnlocked': isUnlocked,
      'unlockedAt': unlockedAt?.toIso8601String(),
    };
  }

  factory BadgeModel.fromJson(Map<String, dynamic> json) {
    return BadgeModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String? ?? '',
      category: json['category'] as String,
      tier: json['tier'] as String? ?? 'gold',
      targetValue: (json['targetValue'] as num?)?.toDouble() ?? 100.0,
      currentValue: (json['currentValue'] as num?)?.toDouble() ?? 0.0,
      unit: json['unit'] as String? ?? '',
      isUnlocked: json['isUnlocked'] as bool? ?? false,
      unlockedAt: json['unlockedAt'] != null ? DateTime.parse(json['unlockedAt'] as String) : null,
    );
  }
}
