import 'package:flutter/material.dart';
import '../models/activity_log_model.dart';
import '../services/app_state.dart';
import '../theme/app_theme.dart';

/// Helper model representing color and display attributes for any habit combination
class HabitComboInfo {
  final String key;
  final String title;
  final String subtitle;
  final List<Color> gradientColors;
  final List<Color> habitColors;
  final IconData icon;
  final bool isMultiHabit;

  const HabitComboInfo({
    required this.key,
    required this.title,
    required this.subtitle,
    required this.gradientColors,
    required this.habitColors,
    required this.icon,
    required this.isMultiHabit,
  });
}

/// Dynamic combination engine that assigns distinct colors to EVERY habit combination
class HabitCombinationHelper {
  static Color getCategoryColor(String category) {
    switch (category) {
      case 'swimming':
        return const Color(0xFF4A88C7); // Dingin Okyanus Mavisi
      case 'running':
        return const Color(0xFF48A97C); // Sakin Adaçayı Yeşili
      case 'reading':
        return const Color(0xFFD99B43); // Sıcak Kehribar / Kum Sarısı
      case 'fitness':
        return const Color(0xFFD96B5B); // Yumuşak Mercan / Kiremit
      case 'water':
        return const Color(0xFF48A6BE); // Berrak Su Mavisi / Yumuşak Turkuaz
      case 'mind_games':
        return const Color(0xFF8A7AA8); // Yumuşak Lavanta
      case 'healthy_food':
        return const Color(0xFF6F9E60); // Taze Zeytin Yeşili
      case 'quit_smoking':
        return const Color(0xFFC76E87); // Yumuşak Gül Kurusu / Pudra
      case 'quit_alcohol':
        return const Color(0xFF976E9F); // Yumuşak Mürdüm
      case 'other_sports':
      default:
        return const Color(0xFF5A78A5); // Dingin İndigo / Denim
    }
  }

  static String getCategoryTitle(String category) {
    switch (category) {
      case 'swimming':
        return 'Yüzme';
      case 'running':
        return 'Koşu';
      case 'reading':
        return 'Kitap';
      case 'fitness':
        return 'Fitness';
      case 'water':
        return 'Su';
      case 'mind_games':
        return 'Zeka';
      case 'healthy_food':
        return 'Beslenme';
      case 'quit_smoking':
        return 'Sigara Bırakma';
      case 'quit_alcohol':
        return 'Alkol Bırakma';
      case 'other_sports':
      default:
        return 'Spor';
    }
  }

  static IconData getCategoryIcon(String category) {
    switch (category) {
      case 'swimming':
        return Icons.pool_rounded;
      case 'running':
        return Icons.directions_run_rounded;
      case 'reading':
        return Icons.menu_book_rounded;
      case 'fitness':
        return Icons.fitness_center_rounded;
      case 'water':
        return Icons.water_drop_rounded;
      case 'mind_games':
        return Icons.psychology_rounded;
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

  /// Evaluates any list of logs and determines its unique, distinct combination presentation
  static HabitComboInfo? getComboInfo(List<ActivityLogModel> logs) {
    if (logs.isEmpty) return null;

    final categories = logs.map((l) => l.category).toSet().toList();
    categories.sort(); // Canonical alphabetical order

    // 1. Single habit
    if (categories.length == 1) {
      final cat = categories.first;
      final color = getCategoryColor(cat);
      return HabitComboInfo(
        key: cat,
        title: getCategoryTitle(cat),
        subtitle: '1 Alışkanlık Tamamlandı',
        gradientColors: [color, color],
        habitColors: [color],
        icon: getCategoryIcon(cat),
        isMultiHabit: false,
      );
    }

    final habitColors = categories.map((c) => getCategoryColor(c)).toList();
    final comboKey = categories.join('_');

    // 2. Curated 2-Habit Combinations with Handcrafted Distinct Palettes
    if (categories.length == 2) {
      final c1 = categories[0];
      final c2 = categories[1];

      // Swimming + Running (Classic Special Combo)
      if (categories.contains('swimming') && categories.contains('running')) {
        return HabitComboInfo(
          key: comboKey,
          title: 'Yüzme + Koşu (Deniz & Kara)',
          subtitle: '2 Alışkanlık Kombosu',
          gradientColors: const [Color(0xFF4A88C7), Color(0xFF48A97C)],
          habitColors: habitColors,
          icon: Icons.bolt_rounded,
          isMultiHabit: true,
        );
      }

      // Running + Reading (Koşu + Kitap: Zihin & Beden)
      if (categories.contains('reading') && categories.contains('running')) {
        return HabitComboInfo(
          key: comboKey,
          title: 'Koşu + Kitap (Zihin & Beden)',
          subtitle: '2 Alışkanlık Kombosu',
          gradientColors: const [Color(0xFF48A97C), Color(0xFFD99B43)],
          habitColors: habitColors,
          icon: Icons.auto_awesome_rounded,
          isMultiHabit: true,
        );
      }

      // Fitness + Water (Hidrasyon & Güç)
      if (categories.contains('fitness') && categories.contains('water')) {
        return HabitComboInfo(
          key: comboKey,
          title: 'Fitness + Su (Hidrasyon & Güç)',
          subtitle: '2 Alışkanlık Kombosu',
          gradientColors: const [Color(0xFFD96B5B), Color(0xFF48A6BE)],
          habitColors: habitColors,
          icon: Icons.local_fire_department_rounded,
          isMultiHabit: true,
        );
      }

      // Reading + Mind Games (Bilişsel Odak)
      if (categories.contains('mind_games') && categories.contains('reading')) {
        return HabitComboInfo(
          key: comboKey,
          title: 'Kitap + Zeka (Bilişsel Odak)',
          subtitle: '2 Alışkanlık Kombosu',
          gradientColors: const [Color(0xFFD99B43), Color(0xFF8A7AA8)],
          habitColors: habitColors,
          icon: Icons.psychology_rounded,
          isMultiHabit: true,
        );
      }

      // Fitness + Running (Yüksek Efor)
      if (categories.contains('fitness') && categories.contains('running')) {
        return HabitComboInfo(
          key: comboKey,
          title: 'Koşu + Fitness (Yüksek Efor)',
          subtitle: '2 Alışkanlık Kombosu',
          gradientColors: const [Color(0xFF48A97C), Color(0xFFD96B5B)],
          habitColors: habitColors,
          icon: Icons.whatshot_rounded,
          isMultiHabit: true,
        );
      }

      // Healthy Food + Water (Saf Detoks)
      if (categories.contains('healthy_food') && categories.contains('water')) {
        return HabitComboInfo(
          key: comboKey,
          title: 'Beslenme + Su (Saf Detoks)',
          subtitle: '2 Alışkanlık Kombosu',
          gradientColors: const [Color(0xFF6F9E60), Color(0xFF48A6BE)],
          habitColors: habitColors,
          icon: Icons.eco_rounded,
          isMultiHabit: true,
        );
      }

      // Quit Smoking + Running (Temiz Nefes)
      if (categories.contains('quit_smoking') && categories.contains('running')) {
        return HabitComboInfo(
          key: comboKey,
          title: 'Koşu + Sigara Bırakma (Temiz Nefes)',
          subtitle: '2 Alışkanlık Kombosu',
          gradientColors: const [Color(0xFF48A97C), Color(0xFFC76E87)],
          habitColors: habitColors,
          icon: Icons.air_rounded,
          isMultiHabit: true,
        );
      }

      // Quit Alcohol + Quit Smoking (Tam Arınma)
      if (categories.contains('quit_alcohol') && categories.contains('quit_smoking')) {
        return HabitComboInfo(
          key: comboKey,
          title: 'Sigara + Alkol Bırakma (Tam Arınma)',
          subtitle: '2 Alışkanlık Kombosu',
          gradientColors: const [Color(0xFFC76E87), Color(0xFF976E9F)],
          habitColors: habitColors,
          icon: Icons.shield_rounded,
          isMultiHabit: true,
        );
      }

      // Reading + Water (Dingin Zihin)
      if (categories.contains('reading') && categories.contains('water')) {
        return HabitComboInfo(
          key: comboKey,
          title: 'Kitap + Su (Dingin Zihin)',
          subtitle: '2 Alışkanlık Kombosu',
          gradientColors: const [Color(0xFFD99B43), Color(0xFF48A6BE)],
          habitColors: habitColors,
          icon: Icons.spa_rounded,
          isMultiHabit: true,
        );
      }

      // Fitness + Healthy Food (Fit Form)
      if (categories.contains('fitness') && categories.contains('healthy_food')) {
        return HabitComboInfo(
          key: comboKey,
          title: 'Fitness + Beslenme (Fit Form)',
          subtitle: '2 Alışkanlık Kombosu',
          gradientColors: const [Color(0xFFD96B5B), Color(0xFF6F9E60)],
          habitColors: habitColors,
          icon: Icons.fitness_center_rounded,
          isMultiHabit: true,
        );
      }

      // Reading + Swimming (Denge & Huzur)
      if (categories.contains('reading') && categories.contains('swimming')) {
        return HabitComboInfo(
          key: comboKey,
          title: 'Yüzme + Kitap (Ruh & Beden)',
          subtitle: '2 Alışkanlık Kombosu',
          gradientColors: const [Color(0xFF4A88C7), Color(0xFFD99B43)],
          habitColors: habitColors,
          icon: Icons.waves_rounded,
          isMultiHabit: true,
        );
      }

      // Swimming + Water (Mavi Dalga)
      if (categories.contains('swimming') && categories.contains('water')) {
        return HabitComboInfo(
          key: comboKey,
          title: 'Yüzme + Su (Mavi Dalga)',
          subtitle: '2 Alışkanlık Kombosu',
          gradientColors: const [Color(0xFF4A88C7), Color(0xFF48A6BE)],
          habitColors: habitColors,
          icon: Icons.pool_rounded,
          isMultiHabit: true,
        );
      }

      // Running + Water (Mavi Rüzgar)
      if (categories.contains('running') && categories.contains('water')) {
        return HabitComboInfo(
          key: comboKey,
          title: 'Koşu + Su (Mavi Rüzgar)',
          subtitle: '2 Alışkanlık Kombosu',
          gradientColors: const [Color(0xFF48A97C), Color(0xFF48A6BE)],
          habitColors: habitColors,
          icon: Icons.air_rounded,
          isMultiHabit: true,
        );
      }

      // Quit Smoking + Water (Detoks & Arınma)
      if (categories.contains('quit_smoking') && categories.contains('water')) {
        return HabitComboInfo(
          key: comboKey,
          title: 'Sigara Bırakma + Su (Detoks)',
          subtitle: '2 Alışkanlık Kombosu',
          gradientColors: const [Color(0xFFC76E87), Color(0xFF48A6BE)],
          habitColors: habitColors,
          icon: Icons.spa_rounded,
          isMultiHabit: true,
        );
      }

      // Mind Games + Running (Hız & Strateji)
      if (categories.contains('mind_games') && categories.contains('running')) {
        return HabitComboInfo(
          key: comboKey,
          title: 'Koşu + Zeka (Hız & Strateji)',
          subtitle: '2 Alışkanlık Kombosu',
          gradientColors: const [Color(0xFF48A97C), Color(0xFF8A7AA8)],
          habitColors: habitColors,
          icon: Icons.insights_rounded,
          isMultiHabit: true,
        );
      }

      // Fitness + Quit Smoking (Canlanma)
      if (categories.contains('fitness') && categories.contains('quit_smoking')) {
        return HabitComboInfo(
          key: comboKey,
          title: 'Fitness + Sigara Bırakma (Canlanma)',
          subtitle: '2 Alışkanlık Kombosu',
          gradientColors: const [Color(0xFFD96B5B), Color(0xFFC76E87)],
          habitColors: habitColors,
          icon: Icons.favorite_rounded,
          isMultiHabit: true,
        );
      }

      // Healthy Food + Reading (Bilinçli Yaşam)
      if (categories.contains('healthy_food') && categories.contains('reading')) {
        return HabitComboInfo(
          key: comboKey,
          title: 'Kitap + Beslenme (Bilinçli Yaşam)',
          subtitle: '2 Alışkanlık Kombosu',
          gradientColors: const [Color(0xFFD99B43), Color(0xFF6F9E60)],
          habitColors: habitColors,
          icon: Icons.wb_sunny_rounded,
          isMultiHabit: true,
        );
      }

      // Generic 2-Habit Combination (Automatic distinct blend)
      return HabitComboInfo(
        key: comboKey,
        title: '${getCategoryTitle(c1)} + ${getCategoryTitle(c2)} İkilisi',
        subtitle: '2 Alışkanlık Kombosu',
        gradientColors: [getCategoryColor(c1), getCategoryColor(c2)],
        habitColors: habitColors,
        icon: Icons.stars_rounded,
        isMultiHabit: true,
      );
    }

    // 3. Curated 3-Habit Combinations
    if (categories.length == 3) {
      if (categories.contains('reading') && categories.contains('running') && categories.contains('swimming')) {
        return HabitComboInfo(
          key: comboKey,
          title: 'Altın Üçlü',
          subtitle: 'Yüzme + Koşu + Kitap',
          gradientColors: const [Color(0xFF4A88C7), Color(0xFF48A97C), Color(0xFFD99B43)],
          habitColors: habitColors,
          icon: Icons.emoji_events_rounded,
          isMultiHabit: true,
        );
      }

      if (categories.contains('fitness') && categories.contains('running') && categories.contains('water')) {
        return HabitComboInfo(
          key: comboKey,
          title: 'Triatlon Gücü',
          subtitle: 'Koşu + Fitness + Su',
          gradientColors: const [Color(0xFF48A97C), Color(0xFFD96B5B), Color(0xFF48A6BE)],
          habitColors: habitColors,
          icon: Icons.flash_on_rounded,
          isMultiHabit: true,
        );
      }

      if (categories.contains('mind_games') && categories.contains('reading') && categories.contains('water')) {
        return HabitComboInfo(
          key: comboKey,
          title: 'Zihin Maratonu',
          subtitle: 'Kitap + Zeka + Su',
          gradientColors: const [Color(0xFFD99B43), Color(0xFF8A7AA8), Color(0xFF48A6BE)],
          habitColors: habitColors,
          icon: Icons.psychology_rounded,
          isMultiHabit: true,
        );
      }

      if (categories.contains('healthy_food') && categories.contains('running') && categories.contains('water')) {
        return HabitComboInfo(
          key: comboKey,
          title: 'Canlılık Üçlüsü',
          subtitle: 'Koşu + Beslenme + Su',
          gradientColors: const [Color(0xFF48A97C), Color(0xFF6F9E60), Color(0xFF48A6BE)],
          habitColors: habitColors,
          icon: Icons.volunteer_activism_rounded,
          isMultiHabit: true,
        );
      }

      if (categories.contains('quit_alcohol') && categories.contains('quit_smoking') && categories.contains('water')) {
        return HabitComboInfo(
          key: comboKey,
          title: 'Büyük Arınma',
          subtitle: 'Detoks & Tasarruf',
          gradientColors: const [Color(0xFFC76E87), Color(0xFF976E9F), Color(0xFF48A6BE)],
          habitColors: habitColors,
          icon: Icons.verified_user_rounded,
          isMultiHabit: true,
        );
      }

      if (categories.contains('running') && categories.contains('swimming') && categories.contains('water')) {
        return HabitComboInfo(
          key: comboKey,
          title: 'Mavi Güç (Triatlon)',
          subtitle: 'Yüzme + Koşu + Su',
          gradientColors: const [Color(0xFF4A88C7), Color(0xFF48A97C), Color(0xFF48A6BE)],
          habitColors: habitColors,
          icon: Icons.bolt_rounded,
          isMultiHabit: true,
        );
      }

      if (categories.contains('reading') && categories.contains('quit_smoking') && categories.contains('water')) {
        return HabitComboInfo(
          key: comboKey,
          title: 'Bilinçli Zihin',
          subtitle: 'Kitap + Su + Arınma',
          gradientColors: const [Color(0xFFD99B43), Color(0xFF48A6BE), Color(0xFFC76E87)],
          habitColors: habitColors,
          icon: Icons.spa_rounded,
          isMultiHabit: true,
        );
      }

      // Generic 3-habit combination
      final titles = categories.map((c) => getCategoryTitle(c)).join(' + ');
      return HabitComboInfo(
        key: comboKey,
        title: '3\'lü Seri',
        subtitle: titles,
        gradientColors: habitColors,
        habitColors: habitColors,
        icon: Icons.military_tech_rounded,
        isMultiHabit: true,
      );
    }

    // 4. 4 or More Habits (Super Master Spectrum)
    final titles = categories.map((c) => getCategoryTitle(c)).join(' + ');

    return HabitComboInfo(
      key: comboKey,
      title: '${categories.length}\'li Usta Serisi',
      subtitle: titles,
      gradientColors: const [Color(0xFF4A6B82), Color(0xFF5A78A5), Color(0xFF48A97C)],
      habitColors: habitColors,
      icon: Icons.workspace_premium_rounded,
      isMultiHabit: true,
    );
  }
}

class CalendarScreen extends StatefulWidget {
  final AppState state;

  const CalendarScreen({
    super.key,
    required this.state,
  });

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  late DateTime _selectedMonth;
  late DateTime _selectedDay;
  String? _selectedCategoryFilter; // null = Tümü, otherwise category key like 'water'

  @override
  void initState() {
    super.initState();
    final now = widget.state.currentDateTime;
    _selectedMonth = DateTime(now.year, now.month, 1);
    _selectedDay = DateTime(now.year, now.month, now.day);
  }

  void _prevMonth() {
    setState(() {
      _selectedMonth = DateTime(_selectedMonth.year, _selectedMonth.month - 1, 1);
    });
  }

  void _nextMonth() {
    setState(() {
      _selectedMonth = DateTime(_selectedMonth.year, _selectedMonth.month + 1, 1);
    });
  }

  void _goToToday() {
    final now = widget.state.currentDateTime;
    setState(() {
      _selectedMonth = DateTime(now.year, now.month, 1);
      _selectedDay = DateTime(now.year, now.month, now.day);
    });
  }

  String _formatDate(DateTime d) {
    final y = d.year.toString().padLeft(4, '0');
    final m = d.month.toString().padLeft(2, '0');
    final day = d.day.toString().padLeft(2, '0');
    return '$y-$m-$day';
  }

  String _monthName(int month) {
    const months = [
      'Ocak', 'Şubat', 'Mart', 'Nisan', 'Mayıs', 'Haziran',
      'Temmuz', 'Ağustos', 'Eylül', 'Ekim', 'Kasım', 'Aralık'
    ];
    return months[month - 1];
  }

  Widget _buildHabitFilterChip({
    required String label,
    IconData? icon,
    required bool isSelected,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5.5),
        decoration: BoxDecoration(
          color: isSelected ? color : AppTheme.surfaceMuted,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? color : AppTheme.outlineVariant,
            width: isSelected ? 1.6 : 1.0,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: color.withValues(alpha: 0.28),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: 14,
                color: isSelected ? Colors.white : color,
              ),
              const SizedBox(width: 5),
            ],
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                color: isSelected ? Colors.white : AppTheme.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final year = _selectedMonth.year;
    final month = _selectedMonth.month;

    final firstDayOfMonth = DateTime(year, month, 1);
    final daysInMonth = DateTime(year, month + 1, 0).day;
    final startingWeekday = firstDayOfMonth.weekday; // 1 (Mon) to 7 (Sun)

    final selectedDateStr = _formatDate(_selectedDay);
    final selectedDayLogs = widget.state.getLogsForDate(selectedDateStr);
    final selectedCombo = HabitCombinationHelper.getComboInfo(selectedDayLogs);

    // Count days with completions this month based on filter
    int activeDaysThisMonth = 0;
    for (int d = 1; d <= daysInMonth; d++) {
      final dateStr = _formatDate(DateTime(year, month, d));
      final logs = widget.state.getLogsForDate(dateStr);
      if (_selectedCategoryFilter != null) {
        final hasActive = logs.any((l) =>
            l.category == _selectedCategoryFilter &&
            (l.category != 'quit_smoking' || (l.smokedCount ?? 0) == 0));
        if (hasActive) activeDaysThisMonth++;
      } else {
        if (logs.isNotEmpty) activeDaysThisMonth++;
      }
    }

    final activeFilterHabit = _selectedCategoryFilter != null
        ? widget.state.habits.where((h) => h.category == _selectedCategoryFilter).firstOrNull
        : null;
    final activeFilterTitle = activeFilterHabit?.title ??
        (_selectedCategoryFilter != null
            ? HabitCombinationHelper.getCategoryTitle(_selectedCategoryFilter!)
            : null);

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('Zincir ve Alışkanlık Takvimi'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 28),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 630),
            child: Column(
              children: [
                // Unified Compact Calendar Card
                Container(
                  margin: const EdgeInsets.fromLTRB(16, 10, 16, 14),
                  padding: const EdgeInsets.fromLTRB(18, 16, 18, 18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(color: AppTheme.outlineVariant),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Header: Month Navigation + Quick Stats
                      Row(
                        children: [
                          // Month Title + Year
                          Text(
                            '${_monthName(month)} $year',
                            style: const TextStyle(
                              fontSize: 19,
                              fontWeight: FontWeight.w700,
                              color: AppTheme.textPrimary,
                            ),
                          ),
                          const SizedBox(width: 10),
                          // Mini monthly active badge
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3.5),
                            decoration: BoxDecoration(
                              color: AppTheme.primary.withValues(alpha: 0.08),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              _selectedCategoryFilter != null
                                  ? '🔥 $activeDaysThisMonth Gün $activeFilterTitle'
                                  : '🔥 $activeDaysThisMonth Gün Aktif',
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: AppTheme.primary,
                              ),
                            ),
                          ),
                          const Spacer(),
                          // "Bugün" Jump Button
                          InkWell(
                            onTap: _goToToday,
                            borderRadius: BorderRadius.circular(8),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                              decoration: BoxDecoration(
                                color: AppTheme.surfaceMuted,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: AppTheme.outlineVariant),
                              ),
                              child: const Text(
                                'Bugün',
                                style: TextStyle(
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w600,
                                  color: AppTheme.textSecondary,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 6),
                          // Prev Month Arrow
                          InkWell(
                            onTap: _prevMonth,
                            borderRadius: BorderRadius.circular(8),
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: AppTheme.surfaceMuted,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(Icons.chevron_left_rounded, size: 22, color: AppTheme.textPrimary),
                            ),
                          ),
                          const SizedBox(width: 5),
                          // Next Month Arrow
                          InkWell(
                            onTap: _nextMonth,
                            borderRadius: BorderRadius.circular(8),
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: AppTheme.surfaceMuted,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(Icons.chevron_right_rounded, size: 22, color: AppTheme.textPrimary),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // Horizontal Quick Habit Filter Bar
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        child: Row(
                          children: [
                            _buildHabitFilterChip(
                              label: '🌟 Tümü',
                              isSelected: _selectedCategoryFilter == null,
                              color: AppTheme.primary,
                              onTap: () => setState(() => _selectedCategoryFilter = null),
                            ),
                            const SizedBox(width: 6),
                            ...widget.state.habits.map((habit) {
                              final cat = habit.category;
                              final color = HabitCombinationHelper.getCategoryColor(cat);
                              final streak = widget.state.calculateHabitStreak(habit.id);
                              final isSelected = _selectedCategoryFilter == cat;

                              return Padding(
                                padding: const EdgeInsets.only(right: 6),
                                child: _buildHabitFilterChip(
                                  label: '${habit.title} ($streak Gün)',
                                  icon: HabitCombinationHelper.getCategoryIcon(cat),
                                  isSelected: isSelected,
                                  color: color,
                                  onTap: () {
                                    setState(() {
                                      _selectedCategoryFilter = isSelected ? null : cat;
                                    });
                                  },
                                ),
                              );
                            }),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Weekday Labels
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: const ['PZT', 'SAL', 'ÇAR', 'PER', 'CUM', 'CMT', 'PAZ']
                              .map((day) => Expanded(
                                    child: Center(
                                      child: Text(
                                        day,
                                        style: const TextStyle(
                                          fontSize: 13.5,
                                          fontWeight: FontWeight.w700,
                                          color: AppTheme.textMuted,
                                          letterSpacing: 0.3,
                                        ),
                                      ),
                                    ),
                                  ))
                              .toList(),
                        ),
                      ),
                      const SizedBox(height: 10),

                  // Mini Calendar Days Grid
                  _buildCompactMonthGrid(daysInMonth, startingWeekday, year, month),

                  const SizedBox(height: 14),
                  const Divider(height: 1, color: AppTheme.outlineVariant),
                  const SizedBox(height: 12),

                  // Direct Color Combinations Legend directly under the calendar
                  _buildDirectCalendarLegend(),
                ],
              ),
            ),

            // Selected Day Summary Card
            Container(
              margin: const EdgeInsets.fromLTRB(14, 4, 14, 16),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: AppTheme.outlineVariant),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.02),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Day Header with Dynamic Combo Banner (Overflow protected)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: AppTheme.primary.withValues(alpha: 0.08),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(Icons.event_available_rounded, color: AppTheme.primary, size: 18),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '${_selectedDay.day} ${_monthName(_selectedDay.month)} ${_selectedDay.year}',
                            style: const TextStyle(
                              fontSize: 14.5,
                              fontWeight: FontWeight.w700,
                              color: AppTheme.textPrimary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 8),
                      // Dynamic Combination Badge for the selected day with overflow protection
                      if (selectedCombo != null && selectedCombo.isMultiHabit)
                        Flexible(
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: selectedCombo.gradientColors,
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: selectedCombo.gradientColors.first.withValues(alpha: 0.35),
                                  blurRadius: 6,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(selectedCombo.icon, size: 13, color: Colors.white),
                                const SizedBox(width: 4),
                                Flexible(
                                  child: Text(
                                    selectedCombo.title,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      else if (selectedCombo != null && !selectedCombo.isMultiHabit)
                        Flexible(
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3.5),
                            decoration: BoxDecoration(
                              color: selectedCombo.gradientColors.first.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: selectedCombo.gradientColors.first.withValues(alpha: 0.4),
                                width: 1,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(selectedCombo.icon, size: 12, color: selectedCombo.gradientColors.first),
                                const SizedBox(width: 4),
                                Flexible(
                                  child: Text(
                                    selectedCombo.title,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: selectedCombo.gradientColors.first,
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  if (selectedDayLogs.isEmpty)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        color: AppTheme.surfaceMuted,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text(
                          'Bu gün için kayıtlı aktivite bulunmuyor.',
                          style: TextStyle(color: AppTheme.textMuted, fontSize: 12.5),
                        ),
                      ),
                    )
                  else
                    Column(
                      children: selectedDayLogs.map((log) => _buildDayLogItem(log)).toList(),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  ),
);
}

  /// Compact calendar grid with tight aspect ratio and circular day cells
  Widget _buildCompactMonthGrid(int daysInMonth, int startingWeekday, int year, int month) {
    final List<Widget> dayWidgets = [];

    // Empty spaces before first day (Monday = 1, so offset = startingWeekday - 1)
    final offset = startingWeekday - 1;
    for (int i = 0; i < offset; i++) {
      dayWidgets.add(const SizedBox());
    }

    final now = widget.state.currentDateTime;

    for (int d = 1; d <= daysInMonth; d++) {
      final dayDate = DateTime(year, month, d);
      final dateStr = _formatDate(dayDate);
      final rawLogs = widget.state.getLogsForDate(dateStr);
      final isSelected = _selectedDay.year == year &&
          _selectedDay.month == month &&
          _selectedDay.day == d;
      final isToday = dayDate.year == now.year && dayDate.month == now.month && dayDate.day == now.day;

      final List<ActivityLogModel> displayLogs;
      if (_selectedCategoryFilter != null) {
        displayLogs = rawLogs.where((l) =>
            l.category == _selectedCategoryFilter &&
            (l.category != 'quit_smoking' || (l.smokedCount ?? 0) == 0)).toList();
      } else {
        displayLogs = rawLogs;
      }

      final combo = HabitCombinationHelper.getComboInfo(displayLogs);

      dayWidgets.add(
        InkWell(
          onTap: () {
            setState(() {
              _selectedDay = dayDate;
            });
          },
          customBorder: const CircleBorder(),
          child: _buildDayCell(
            day: d,
            isSelected: isSelected,
            isToday: isToday,
            combo: combo,
          ),
        ),
      );
    }

    return GridView.count(
      crossAxisCount: 7,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 8,
      crossAxisSpacing: 8,
      childAspectRatio: 1.0, // Dengeli ve doğal 1:1 dairesel oran
      children: dayWidgets,
    );
  }

  /// Builds a prominent circular calendar cell (52x52px) with calm styling
  Widget _buildDayCell({
    required int day,
    required bool isSelected,
    required bool isToday,
    required HabitComboInfo? combo,
  }) {
    // 1. Multi-habit combination day: elegant soft gradient circle + habit-colored micro-dots
    if (combo != null && combo.isMultiHabit) {
      return Center(
        child: SizedBox(
          width: 52,
          height: 52,
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: combo.gradientColors,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              border: Border.all(
                color: isSelected ? AppTheme.textPrimary : Colors.white.withValues(alpha: 0.9),
                width: isSelected ? 2.8 : 1.3,
              ),
              boxShadow: [
                BoxShadow(
                  color: combo.gradientColors.first.withValues(alpha: 0.22),
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
                if (isSelected)
                  BoxShadow(
                    color: AppTheme.textPrimary.withValues(alpha: 0.25),
                    blurRadius: 7,
                    spreadRadius: 1,
                  ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '$day',
                  style: const TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    height: 1.0,
                  ),
                ),
                const SizedBox(height: 3.5),
                // Micro dots for each habit in the combo (showing actual habit colors!)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: combo.habitColors.take(4).map((c) {
                    return Container(
                      width: 5.5,
                      height: 5.5,
                      margin: const EdgeInsets.symmetric(horizontal: 1.0),
                      decoration: BoxDecoration(
                        color: c,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 0.9),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.25),
                            blurRadius: 1,
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ),
      );
    }

    // 2. Single habit day: calm solid soft-color circle + single dot
    if (combo != null && !combo.isMultiHabit) {
      final color = combo.gradientColors.first;
      return Center(
        child: SizedBox(
          width: 52,
          height: 52,
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color,
              border: Border.all(
                color: isSelected ? AppTheme.textPrimary : Colors.white.withValues(alpha: 0.9),
                width: isSelected ? 2.8 : 1.3,
              ),
              boxShadow: [
                BoxShadow(
                  color: color.withValues(alpha: 0.22),
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
                if (isSelected)
                  BoxShadow(
                    color: AppTheme.textPrimary.withValues(alpha: 0.25),
                    blurRadius: 7,
                    spreadRadius: 1,
                  ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '$day',
                  style: const TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    height: 1.0,
                  ),
                ),
                const SizedBox(height: 3.5),
                Container(
                  width: 4.5,
                  height: 4.5,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.95),
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    // 3. Inactive / Empty Day
    return Center(
      child: SizedBox(
        width: 52,
        height: 52,
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isSelected
                ? AppTheme.primaryContainer
                : (isToday ? AppTheme.surfaceMuted : Colors.transparent),
            border: Border.all(
              color: isSelected
                  ? AppTheme.primary
                  : (isToday ? AppTheme.outline : Colors.transparent),
              width: isSelected ? 2.4 : 1.0,
            ),
          ),
          child: Center(
            child: Text(
              '$day',
              style: TextStyle(
                fontSize: 15.0,
                fontWeight: isSelected
                    ? FontWeight.w700
                    : (isToday ? FontWeight.w600 : FontWeight.w500),
                color: isSelected
                    ? AppTheme.primary
                    : (isToday ? AppTheme.textPrimary : AppTheme.textSecondary),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDayLogItem(ActivityLogModel log) {
    final itemColor = HabitCombinationHelper.getCategoryColor(log.category);
    final itemIcon = HabitCombinationHelper.getCategoryIcon(log.category);
    final isFilteredItem = _selectedCategoryFilter == log.category;
    String title = 'Aktivite';
    String detail = '';

    switch (log.category) {
      case 'swimming':
        title = 'Yüzme Antrenmanı';
        detail = '${log.durationMinutes ?? 30} dk • ${log.caloriesBurned?.toStringAsFixed(0) ?? "0"} kcal yakıldı';
        break;
      case 'running':
        title = 'Koşu';
        detail = '${log.distanceKm ?? 0} km • ${log.caloriesBurned?.toStringAsFixed(0) ?? "0"} kcal yakıldı';
        break;
      case 'reading':
        title = 'Kitap Okuma';
        detail = '${log.pagesRead ?? 0} sayfa • ${log.bookGenre ?? "Kitap"} ${log.isBookFinished == true ? "(Bitirildi 🏆)" : ""}';
        break;
      case 'water':
        title = 'Su Tüketimi';
        detail = '${log.waterLiters ?? 0} Litre su içildi • Günlük Hidrasyon Tamamlandı';
        break;
      case 'fitness':
        title = 'Fitness';
        detail = '${log.durationMinutes ?? 0} dk • ${log.caloriesBurned?.toStringAsFixed(0) ?? "0"} kcal yakıldı';
        break;
      case 'healthy_food':
        title = 'Sağlıklı Beslenme';
        detail = '${log.caloriesSaved?.toStringAsFixed(0) ?? "0"} kcal kalori tasarrufu';
        break;
      case 'quit_smoking':
        title = 'Sigara Bırakma / Tasarruf';
        final smoked = log.smokedCount ?? 0;
        final avoided = log.avoidedCount ?? 0;
        final saved = log.moneySavedTL ?? 0.0;
        final packPrice = widget.state.currentUser?.smokingPackPrice ?? 75.0;
        final pricePerCig = packPrice / 20.0;
        final cost = smoked * pricePerCig;

        if (smoked == 0) {
          detail = '0 dal içildi (Seri korundu 🔥) • $avoided dal tasarruf • +${saved.toStringAsFixed(2)} TL Kâr';
        } else if (saved > 0) {
          detail = '$smoked dal içildi (Seri bozuldu 💔) • $avoided dal pas geçildi • +${saved.toStringAsFixed(2)} TL Kâr';
        } else {
          final packs = smoked / 20.0;
          final packStr = packs == packs.roundToDouble() ? packs.toInt().toString() : packs.toStringAsFixed(1);
          detail = '$smoked dal içildi ($packStr paket • Seri bozuldu 💔) • ${cost.toStringAsFixed(2)} TL harcama';
        }
        break;
      case 'quit_alcohol':
        title = 'Alkol Bırakma';
        detail = '${log.moneySavedTL?.toStringAsFixed(2) ?? "0"} TL tasarruf edildi';
        break;
      case 'mind_games':
        title = 'Zeka Oyunu';
        detail = '${log.durationMinutes ?? 0} dk • ${log.bookGenre ?? "Zeka Egzersizi"}';
        break;
      default:
        title = 'Diğer Spor';
        detail = '${log.durationMinutes ?? 0} dk aktivite';
        break;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 7),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
      decoration: BoxDecoration(
        color: isFilteredItem ? itemColor.withValues(alpha: 0.12) : itemColor.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isFilteredItem ? itemColor : itemColor.withValues(alpha: 0.2),
          width: isFilteredItem ? 1.6 : 1.0,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: itemColor.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(itemIcon, color: itemColor, size: 16),
          ),
          const SizedBox(width: 9),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textPrimary,
                  ),
                ),
                Text(
                  detail,
                  style: const TextStyle(fontSize: 11.5, color: AppTheme.textSecondary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Color combinations and single habit legend directly beneath the calendar grid
  Widget _buildDirectCalendarLegend() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: const [
            Icon(Icons.palette_outlined, size: 18, color: AppTheme.primary),
            SizedBox(width: 8),
            Text(
              'Renk Kombinasyonları ve Göstergeler',
              style: TextStyle(
                fontSize: 14.5,
                fontWeight: FontWeight.w700,
                color: AppTheme.textPrimary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 5),
        const Text(
          'Takvimdeki sade renkler ve yapılan aktivite kombinasyonları:',
          style: TextStyle(fontSize: 12.5, color: AppTheme.textSecondary),
        ),
        const SizedBox(height: 12),

        // Tekil Alışkanlıklar
        const Text(
          'Tekil Alışkanlıklar',
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppTheme.textMuted),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _buildSingleLegendItem('Koşu', HabitCombinationHelper.getCategoryColor('running'), 'running'),
            _buildSingleLegendItem('Kitap', HabitCombinationHelper.getCategoryColor('reading'), 'reading'),
            _buildSingleLegendItem('Yüzme', HabitCombinationHelper.getCategoryColor('swimming'), 'swimming'),
            _buildSingleLegendItem('Fitness', HabitCombinationHelper.getCategoryColor('fitness'), 'fitness'),
            _buildSingleLegendItem('Su', HabitCombinationHelper.getCategoryColor('water'), 'water'),
            _buildSingleLegendItem('Zeka', HabitCombinationHelper.getCategoryColor('mind_games'), 'mind_games'),
            _buildSingleLegendItem('Beslenme', HabitCombinationHelper.getCategoryColor('healthy_food'), 'healthy_food'),
            _buildSingleLegendItem('Sigara Bırakma', HabitCombinationHelper.getCategoryColor('quit_smoking'), 'quit_smoking'),
            _buildSingleLegendItem('Alkol Bırakma', HabitCombinationHelper.getCategoryColor('quit_alcohol'), 'quit_alcohol'),
          ],
        ),
        const SizedBox(height: 14),

        // Kombinasyonlar
        const Text(
          'Renk Kombinasyonları (Birlikte Yapılanlar)',
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppTheme.textMuted),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _buildComboLegendItem(
              label: 'Yüzme + Koşu',
              colors: [
                HabitCombinationHelper.getCategoryColor('swimming'),
                HabitCombinationHelper.getCategoryColor('running'),
              ],
            ),
            _buildComboLegendItem(
              label: 'Koşu + Kitap',
              colors: [
                HabitCombinationHelper.getCategoryColor('running'),
                HabitCombinationHelper.getCategoryColor('reading'),
              ],
            ),
            _buildComboLegendItem(
              label: 'Fitness + Su',
              colors: [
                HabitCombinationHelper.getCategoryColor('fitness'),
                HabitCombinationHelper.getCategoryColor('water'),
              ],
            ),
            _buildComboLegendItem(
              label: 'Kitap + Zeka',
              colors: [
                HabitCombinationHelper.getCategoryColor('reading'),
                HabitCombinationHelper.getCategoryColor('mind_games'),
              ],
            ),
            _buildComboLegendItem(
              label: 'Beslenme + Su',
              colors: [
                HabitCombinationHelper.getCategoryColor('healthy_food'),
                HabitCombinationHelper.getCategoryColor('water'),
              ],
            ),
            _buildComboLegendItem(
              label: 'Koşu + Fitness',
              colors: [
                HabitCombinationHelper.getCategoryColor('running'),
                HabitCombinationHelper.getCategoryColor('fitness'),
              ],
            ),
            _buildComboLegendItem(
              label: '3\'lü Seri',
              colors: const [
                Color(0xFF4A88C7),
                Color(0xFF48A97C),
                Color(0xFFD99B43),
              ],
            ),
            _buildComboLegendItem(
              label: '4+ Usta Serisi',
              colors: const [
                Color(0xFF4A6B82),
                Color(0xFF5A78A5),
                Color(0xFF48A97C),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildComboLegendItem({
    required String label,
    required List<Color> colors,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        color: AppTheme.surfaceMuted,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.outlineVariant),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: colors,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: colors.first.withValues(alpha: 0.25),
                  blurRadius: 2,
                ),
              ],
            ),
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSingleLegendItem(String label, Color color, String category) {
    final isSelected = _selectedCategoryFilter == category;
    return InkWell(
      onTap: () {
        setState(() {
          _selectedCategoryFilter = isSelected ? null : category;
        });
      },
      borderRadius: BorderRadius.circular(12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
        decoration: BoxDecoration(
          color: isSelected ? color.withValues(alpha: 0.16) : AppTheme.surfaceMuted,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? color : AppTheme.outlineVariant,
            width: isSelected ? 1.6 : 1.0,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 11,
              height: 11,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: color,
              ),
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 12.5,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                color: isSelected ? color : AppTheme.textPrimary,
              ),
            ),
            if (isSelected) ...[
              const SizedBox(width: 4),
              Icon(Icons.check_circle_rounded, size: 12, color: color),
            ],
          ],
        ),
      ),
    );
  }
}
