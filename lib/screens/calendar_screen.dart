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
        return const Color(0xFF0284C7); // Okyanus Mavisi
      case 'running':
        return const Color(0xFF10B981); // Zümrüt Yeşili
      case 'reading':
        return const Color(0xFFF59E0B); // Kehribar / Kitap Sarısı
      case 'fitness':
        return const Color(0xFFEF4444); // Ateş Kırmızısı / Mercan
      case 'water':
        return const Color(0xFF06B6D4); // Canlı Su Turkuazı
      case 'mind_games':
        return const Color(0xFF8B5CF6); // Ametist Moru
      case 'healthy_food':
        return const Color(0xFF84CC16); // Taze Yeşil
      case 'quit_smoking':
        return const Color(0xFFEC4899); // Canlı Pembe
      case 'quit_alcohol':
        return const Color(0xFFA855F7); // Menekşe
      case 'other_sports':
      default:
        return const Color(0xFF3B82F6); // İndigo
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
          gradientColors: const [Color(0xFF00E5FF), Color(0xFF2563EB), Color(0xFF10B981)],
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
          gradientColors: const [Color(0xFF10B981), Color(0xFFF59E0B)],
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
          gradientColors: const [Color(0xFFFF5722), Color(0xFF06B6D4)],
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
          gradientColors: const [Color(0xFFF59E0B), Color(0xFF8B5CF6)],
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
          gradientColors: const [Color(0xFF10B981), Color(0xFFEF4444)],
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
          gradientColors: const [Color(0xFF84CC16), Color(0xFF06B6D4)],
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
          gradientColors: const [Color(0xFF10B981), Color(0xFFEC4899)],
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
          gradientColors: const [Color(0xFFEC4899), Color(0xFFA855F7)],
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
          gradientColors: const [Color(0xFFF59E0B), Color(0xFF0284C7)],
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
          gradientColors: const [Color(0xFFEF4444), Color(0xFF84CC16)],
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
          gradientColors: const [Color(0xFF0284C7), Color(0xFFF59E0B)],
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
          gradientColors: const [Color(0xFF0284C7), Color(0xFF38BDF8)],
          habitColors: habitColors,
          icon: Icons.pool_rounded,
          isMultiHabit: true,
        );
      }

      // Mind Games + Running (Hız & Strateji)
      if (categories.contains('mind_games') && categories.contains('running')) {
        return HabitComboInfo(
          key: comboKey,
          title: 'Koşu + Zeka (Hız & Strateji)',
          subtitle: '2 Alışkanlık Kombosu',
          gradientColors: const [Color(0xFF10B981), Color(0xFF8B5CF6)],
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
          gradientColors: const [Color(0xFFFF5722), Color(0xFFEC4899)],
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
          gradientColors: const [Color(0xFFF59E0B), Color(0xFF84CC16)],
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
          title: 'Altın Üçlü (Yüzme + Koşu + Kitap)',
          subtitle: '3 Alışkanlık Kombosu',
          gradientColors: const [Color(0xFF00E5FF), Color(0xFF10B981), Color(0xFFF59E0B)],
          habitColors: habitColors,
          icon: Icons.emoji_events_rounded,
          isMultiHabit: true,
        );
      }

      if (categories.contains('fitness') && categories.contains('running') && categories.contains('water')) {
        return HabitComboInfo(
          key: comboKey,
          title: 'Triatlon Gücü (Koşu + Fitness + Su)',
          subtitle: '3 Alışkanlık Kombosu',
          gradientColors: const [Color(0xFF10B981), Color(0xFFEF4444), Color(0xFF06B6D4)],
          habitColors: habitColors,
          icon: Icons.flash_on_rounded,
          isMultiHabit: true,
        );
      }

      if (categories.contains('mind_games') && categories.contains('reading') && categories.contains('water')) {
        return HabitComboInfo(
          key: comboKey,
          title: 'Zihin Maratonu (Kitap + Zeka + Su)',
          subtitle: '3 Alışkanlık Kombosu',
          gradientColors: const [Color(0xFFF59E0B), Color(0xFF8B5CF6), Color(0xFF06B6D4)],
          habitColors: habitColors,
          icon: Icons.psychology_rounded,
          isMultiHabit: true,
        );
      }

      if (categories.contains('healthy_food') && categories.contains('running') && categories.contains('water')) {
        return HabitComboInfo(
          key: comboKey,
          title: 'Canlılık Üçlüsü (Koşu + Beslenme + Su)',
          subtitle: '3 Alışkanlık Kombosu',
          gradientColors: const [Color(0xFF10B981), Color(0xFF84CC16), Color(0xFF06B6D4)],
          habitColors: habitColors,
          icon: Icons.volunteer_activism_rounded,
          isMultiHabit: true,
        );
      }

      if (categories.contains('quit_alcohol') && categories.contains('quit_smoking') && categories.contains('water')) {
        return HabitComboInfo(
          key: comboKey,
          title: 'Büyük Arınma (Detoks & Tasarruf)',
          subtitle: '3 Alışkanlık Kombosu',
          gradientColors: const [Color(0xFFEC4899), Color(0xFFA855F7), Color(0xFF06B6D4)],
          habitColors: habitColors,
          icon: Icons.verified_user_rounded,
          isMultiHabit: true,
        );
      }

      // Generic 3-habit combination
      final titles = categories.map((c) => getCategoryTitle(c)).join(' + ');
      return HabitComboInfo(
        key: comboKey,
        title: '3\'lü Seri ($titles)',
        subtitle: '3 Alışkanlık Kombosu',
        gradientColors: habitColors,
        habitColors: habitColors,
        icon: Icons.military_tech_rounded,
        isMultiHabit: true,
      );
    }

    // 4. 4 or More Habits (Super Master Spectrum)
    final titles = categories.map((c) => getCategoryTitle(c)).join(' + ');
    final multiColors = habitColors.length > 5
        ? [habitColors[0], habitColors[2], habitColors[4], habitColors.last]
        : habitColors;

    return HabitComboInfo(
      key: comboKey,
      title: '${categories.length}\'li Usta Serisi ($titles)',
      subtitle: '${categories.length} Alışkanlık Süper Kombosu',
      gradientColors: multiColors,
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

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
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
    final now = DateTime.now();
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

    // Count days with completions this month
    int activeDaysThisMonth = 0;
    for (int d = 1; d <= daysInMonth; d++) {
      final dateStr = _formatDate(DateTime(year, month, d));
      if (widget.state.getLogsForDate(dateStr).isNotEmpty) {
        activeDaysThisMonth++;
      }
    }

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('Zincir ve Alışkanlık Takvimi'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 28),
        child: Column(
          children: [
            // Unified Compact Calendar Card
            Container(
              margin: const EdgeInsets.fromLTRB(14, 6, 14, 10),
              padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppTheme.outlineVariant),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.03),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Compact Header: Month Navigation + Quick Stats
                  Row(
                    children: [
                      // Month Title + Year
                      Text(
                        '${_monthName(month)} $year',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Mini monthly active badge
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2.5),
                        decoration: BoxDecoration(
                          color: AppTheme.primary.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          '🔥 $activeDaysThisMonth Gün Aktif',
                          style: const TextStyle(
                            fontSize: 10.5,
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
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppTheme.surfaceMuted,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: AppTheme.outlineVariant),
                          ),
                          child: const Text(
                            'Bugün',
                            style: TextStyle(
                              fontSize: 11,
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
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: AppTheme.surfaceMuted,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(Icons.chevron_left_rounded, size: 20, color: AppTheme.textPrimary),
                        ),
                      ),
                      const SizedBox(width: 4),
                      // Next Month Arrow
                      InkWell(
                        onTap: _nextMonth,
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: AppTheme.surfaceMuted,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(Icons.chevron_right_rounded, size: 20, color: AppTheme.textPrimary),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // Compact Weekday Labels
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: const ['PZT', 'SAL', 'ÇAR', 'PER', 'CUM', 'CMT', 'PAZ']
                          .map((day) => Expanded(
                                child: Center(
                                  child: Text(
                                    day,
                                    style: const TextStyle(
                                      fontSize: 10.5,
                                      fontWeight: FontWeight.w700,
                                      color: AppTheme.textMuted,
                                      letterSpacing: 0.2,
                                    ),
                                  ),
                                ),
                              ))
                          .toList(),
                    ),
                  ),
                  const SizedBox(height: 6),

                  // Mini Calendar Days Grid
                  _buildCompactMonthGrid(daysInMonth, startingWeekday, year, month),
                ],
              ),
            ),

            // Selected Day Summary Card
            Container(
              margin: const EdgeInsets.fromLTRB(14, 4, 14, 10),
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
                  // Day Header with Dynamic Combo Banner
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
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
                      const Spacer(),
                      // Dynamic Combination Badge for the selected day
                      if (selectedCombo != null && selectedCombo.isMultiHabit)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
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
                              const SizedBox(width: 5),
                              Text(
                                selectedCombo.title,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        )
                      else if (selectedCombo != null && !selectedCombo.isMultiHabit)
                        Container(
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
                              Text(
                                selectedCombo.title,
                                style: TextStyle(
                                  color: selectedCombo.gradientColors.first,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
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

            // Color & Multi-Combination Legend Card
            Container(
              margin: const EdgeInsets.fromLTRB(14, 4, 14, 16),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: AppTheme.outlineVariant),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: const [
                      Icon(Icons.palette_rounded, size: 16, color: AppTheme.primary),
                      SizedBox(width: 6),
                      Text(
                        'Renk & Kombinasyon Göstergesi',
                        style: TextStyle(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Her farklı alışkanlık kombinasyonu takvimde kendine özel bir renk karışımı ve gradyan ile gösterilir:',
                    style: TextStyle(fontSize: 11.5, color: AppTheme.textSecondary),
                  ),
                  const SizedBox(height: 10),

                  // Special Combinations Showcase
                  const Text(
                    'Özel Kombinasyon Renkleri',
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppTheme.textMuted),
                  ),
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 8,
                    runSpacing: 6,
                    children: [
                      _buildGradientLegendBadge(
                        label: 'Koşu + Kitap',
                        colors: const [Color(0xFF10B981), Color(0xFFF59E0B)],
                      ),
                      _buildGradientLegendBadge(
                        label: 'Yüzme + Koşu',
                        colors: const [Color(0xFF00E5FF), Color(0xFF2563EB), Color(0xFF10B981)],
                      ),
                      _buildGradientLegendBadge(
                        label: 'Fitness + Su',
                        colors: const [Color(0xFFFF5722), Color(0xFF06B6D4)],
                      ),
                      _buildGradientLegendBadge(
                        label: 'Kitap + Zeka',
                        colors: const [Color(0xFFF59E0B), Color(0xFF8B5CF6)],
                      ),
                      _buildGradientLegendBadge(
                        label: 'Beslenme + Su',
                        colors: const [Color(0xFF84CC16), Color(0xFF06B6D4)],
                      ),
                      _buildGradientLegendBadge(
                        label: '3\'lü Süper Seri',
                        colors: const [Color(0xFF10B981), Color(0xFF84CC16), Color(0xFF06B6D4)],
                      ),
                      _buildGradientLegendBadge(
                        label: '4+\'li Usta Serisi',
                        colors: const [Color(0xFFEC4899), Color(0xFF8B5CF6), Color(0xFF3B82F6), Color(0xFF10B981)],
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Single Habit Colors
                  const Text(
                    'Tekil Alışkanlıklar',
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppTheme.textMuted),
                  ),
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 10,
                    runSpacing: 6,
                    children: [
                      _buildSingleLegendChip('Koşu', const Color(0xFF10B981)),
                      _buildSingleLegendChip('Kitap', const Color(0xFFF59E0B)),
                      _buildSingleLegendChip('Yüzme', const Color(0xFF0284C7)),
                      _buildSingleLegendChip('Fitness', const Color(0xFFEF4444)),
                      _buildSingleLegendChip('Su', const Color(0xFF06B6D4)),
                      _buildSingleLegendChip('Zeka', const Color(0xFF8B5CF6)),
                      _buildSingleLegendChip('Beslenme', const Color(0xFF84CC16)),
                      _buildSingleLegendChip('Sigara/Alkol', const Color(0xFFEC4899)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Compact calendar grid with tighter aspect ratio and mini day cells
  Widget _buildCompactMonthGrid(int daysInMonth, int startingWeekday, int year, int month) {
    final List<Widget> dayWidgets = [];

    // Empty spaces before first day (Monday = 1, so offset = startingWeekday - 1)
    final offset = startingWeekday - 1;
    for (int i = 0; i < offset; i++) {
      dayWidgets.add(const SizedBox());
    }

    final now = DateTime.now();

    for (int d = 1; d <= daysInMonth; d++) {
      final dayDate = DateTime(year, month, d);
      final dateStr = _formatDate(dayDate);
      final logs = widget.state.getLogsForDate(dateStr);
      final isSelected = _selectedDay.year == year &&
          _selectedDay.month == month &&
          _selectedDay.day == d;
      final isToday = dayDate.year == now.year && dayDate.month == now.month && dayDate.day == now.day;

      final combo = HabitCombinationHelper.getComboInfo(logs);

      dayWidgets.add(
        InkWell(
          onTap: () {
            setState(() {
              _selectedDay = dayDate;
            });
          },
          borderRadius: BorderRadius.circular(12),
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
      mainAxisSpacing: 3,
      crossAxisSpacing: 3,
      childAspectRatio: 1.15, // Compact, non-stretched height
      children: dayWidgets,
    );
  }

  /// Builds a compact, aesthetic calendar cell with distinct multi-color styling
  Widget _buildDayCell({
    required int day,
    required bool isSelected,
    required bool isToday,
    required HabitComboInfo? combo,
  }) {
    // 1. Multi-habit combination day: vibrant gradient + micro-dots
    if (combo != null && combo.isMultiHabit) {
      return Container(
        margin: const EdgeInsets.all(1.5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          gradient: LinearGradient(
            colors: combo.gradientColors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          border: Border.all(
            color: isSelected ? Colors.white : Colors.transparent,
            width: isSelected ? 2.2 : 0,
          ),
          boxShadow: [
            BoxShadow(
              color: combo.gradientColors.first.withValues(alpha: 0.35),
              blurRadius: 4,
              offset: const Offset(0, 1.5),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '$day',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w800,
                color: Colors.white,
                height: 1.1,
              ),
            ),
            const SizedBox(height: 2),
            // Mini colored dot pills for each distinct habit in the combo
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: combo.habitColors.take(4).map((c) {
                return Container(
                  width: 3.2,
                  height: 3.2,
                  margin: const EdgeInsets.symmetric(horizontal: 0.6),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.3),
                        blurRadius: 1,
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      );
    }

    // 2. Single habit day: clean colored ring & tint
    if (combo != null && !combo.isMultiHabit) {
      final color = combo.gradientColors.first;
      return Container(
        margin: const EdgeInsets.all(1.5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: color.withValues(alpha: 0.16),
          border: Border.all(
            color: isSelected ? AppTheme.textPrimary : color,
            width: isSelected ? 2.2 : 1.6,
          ),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.20),
              blurRadius: 3,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '$day',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: isSelected ? AppTheme.textPrimary : color,
                height: 1.1,
              ),
            ),
            const SizedBox(height: 2),
            Container(
              width: 3.2,
              height: 3.2,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
            ),
          ],
        ),
      );
    }

    // 3. Inactive / Empty Day
    return Container(
      margin: const EdgeInsets.all(1.5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: isSelected
            ? AppTheme.primaryContainer
            : (isToday ? AppTheme.surfaceMuted : Colors.transparent),
        border: Border.all(
          color: isSelected
              ? AppTheme.primary
              : (isToday ? AppTheme.outline : Colors.transparent),
          width: isSelected ? 1.8 : 1.0,
        ),
      ),
      child: Center(
        child: Text(
          '$day',
          style: TextStyle(
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.w700 : (isToday ? FontWeight.w600 : FontWeight.w500),
            color: isSelected
                ? AppTheme.primary
                : (isToday ? AppTheme.textPrimary : AppTheme.textSecondary),
          ),
        ),
      ),
    );
  }

  Widget _buildDayLogItem(ActivityLogModel log) {
    final itemColor = HabitCombinationHelper.getCategoryColor(log.category);
    final itemIcon = HabitCombinationHelper.getCategoryIcon(log.category);
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
        detail = '${log.waterLiters ?? 0} Litre su içildi';
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
        title = 'Sigara Bırakma';
        detail = '${log.avoidedCount ?? 0} dal içilmedi • ${log.moneySavedTL?.toStringAsFixed(2) ?? "0"} TL kâr';
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
        color: itemColor.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: itemColor.withValues(alpha: 0.2)),
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

  Widget _buildGradientLegendBadge({
    required String label,
    required List<Color> colors,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3.5),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: colors),
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: colors.first.withValues(alpha: 0.25),
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 10.5,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildSingleLegendChip(String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 9,
          height: 9,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 11, color: AppTheme.textSecondary, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}
