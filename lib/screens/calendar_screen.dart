import 'package:flutter/material.dart';
import '../models/activity_log_model.dart';
import '../services/app_state.dart';
import '../theme/app_theme.dart';

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

  /// Calculates dynamic circle decoration for a given date (takvimpointerskill.md)
  BoxDecoration _getDayDecoration(DateTime day, bool isSelected, List<ActivityLogModel> logs) {
    final now = DateTime.now();
    final isToday = day.year == now.year && day.month == now.month && day.day == now.day;

    if (logs.isEmpty) {
      return BoxDecoration(
        color: isSelected
            ? AppTheme.primaryContainer
            : (isToday ? AppTheme.surfaceMuted : Colors.transparent),
        shape: BoxShape.circle,
        border: isSelected
            ? Border.all(color: AppTheme.primary, width: 2)
            : (isToday ? Border.all(color: AppTheme.outlineVariant, width: 1.5) : null),
      );
    }

    // Check categories present in this day's logs
    final categories = logs.map((l) => l.category).toSet();

    // 1. Special Combo Rule: Swimming + Running on the same day (takvimpointerskill.md)
    final hasSwimming = categories.contains('swimming');
    final hasRunning = categories.contains('running');

    if (hasSwimming && hasRunning) {
      return BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF00E5FF), Color(0xFF2563EB), Color(0xFF10B981)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF00E5FF).withValues(alpha: 0.5),
            blurRadius: 8,
            spreadRadius: 1,
          ),
        ],
        border: Border.all(
          color: Colors.white,
          width: 2.2,
        ),
      );
    }

    // 2. Single Category Ring
    if (categories.length == 1) {
      final cat = categories.first;
      Color circleColor = AppTheme.primary;
      switch (cat) {
        case 'swimming':
          circleColor = AppTheme.swimming; // #2196F3
          break;
        case 'running':
          circleColor = AppTheme.running; // #4CAF50
          break;
        case 'reading':
          circleColor = AppTheme.reading; // #FFB300
          break;
        case 'fitness':
          circleColor = AppTheme.fitness; // #FF5722
          break;
        case 'water':
          circleColor = AppTheme.water; // #03A9F4
          break;
        case 'healthy_food':
          circleColor = AppTheme.healthyFood; // #8BC34A
          break;
        case 'quit_smoking':
        case 'quit_alcohol':
          circleColor = AppTheme.quitSmoking; // #E91E63
          break;
        case 'mind_games':
          circleColor = AppTheme.mindGames; // #9C27B0
          break;
        case 'other_sports':
          circleColor = AppTheme.otherSports;
          break;
      }

      return BoxDecoration(
        color: circleColor.withValues(alpha: 0.18),
        shape: BoxShape.circle,
        border: Border.all(color: circleColor, width: 2.2),
        boxShadow: [
          BoxShadow(
            color: circleColor.withValues(alpha: 0.25),
            blurRadius: 6,
          ),
        ],
      );
    }

    // 3. Other Multi-Habit Combos: Multi-colored Gold Star Ring
    return BoxDecoration(
      color: AppTheme.goldBadge.withValues(alpha: 0.2),
      shape: BoxShape.circle,
      border: Border.all(color: AppTheme.goldBadge, width: 2.5),
      boxShadow: [
        BoxShadow(
          color: AppTheme.goldBadge.withValues(alpha: 0.35),
          blurRadius: 8,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final year = _selectedMonth.year;
    final month = _selectedMonth.month;

    final firstDayOfMonth = DateTime(year, month, 1);
    final daysInMonth = DateTime(year, month + 1, 0).day;
    // Monday as start of week: weekday 1 = Mon, 7 = Sun
    final startingWeekday = firstDayOfMonth.weekday; // 1 to 7

    final selectedDateStr = _formatDate(_selectedDay);
    final selectedDayLogs = widget.state.getLogsForDate(selectedDateStr);

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('Zincir ve Alışkanlık Takvimi'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Month Selector Bar
            Container(
              margin: const EdgeInsets.fromLTRB(16, 8, 16, 12),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppTheme.outlineVariant),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: _prevMonth,
                    icon: const Icon(Icons.chevron_left_rounded, color: AppTheme.textPrimary),
                  ),
                  Text(
                    '${_monthName(month)} $year',
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  IconButton(
                    onPressed: _nextMonth,
                    icon: const Icon(Icons.chevron_right_rounded, color: AppTheme.textPrimary),
                  ),
                ],
              ),
            ),

            // Calendar Card
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppTheme.outlineVariant),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.03),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Weekday Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: const ['Pzt', 'Sal', 'Çar', 'Per', 'Cum', 'Cmt', 'Paz']
                        .map((day) => Expanded(
                              child: Center(
                                child: Text(
                                  day,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: AppTheme.textMuted,
                                  ),
                                ),
                              ),
                            ))
                        .toList(),
                  ),
                  const SizedBox(height: 12),
                  const Divider(height: 1, color: AppTheme.outlineVariant),
                  const SizedBox(height: 12),

                  // Calendar Days Grid
                  _buildMonthGrid(daysInMonth, startingWeekday, year, month),
                ],
              ),
            ),

            // Selected Day Summary (takvimpointerskill.md)
            Container(
              margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppTheme.outlineVariant),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.event_note_rounded, color: AppTheme.primary, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        '${_selectedDay.day} ${_monthName(_selectedDay.month)} ${_selectedDay.year} Özeti',
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                      const Spacer(),
                      // Check for special combo badge
                      if (selectedDayLogs.any((l) => l.category == 'swimming') &&
                          selectedDayLogs.any((l) => l.category == 'running'))
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF00E5FF), Color(0xFF2563EB)],
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Text(
                            '⚡ Yüzme + Koşu Kombosu',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  if (selectedDayLogs.isEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                      child: Center(
                        child: Text(
                          'Bu gün için kayıtlı aktivite bulunmuyor.',
                          style: TextStyle(color: AppTheme.textMuted, fontSize: 13),
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

            // Color Legend Card (uitasarimskill.md)
            Container(
              margin: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppTheme.outlineVariant),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Renk ve Çember Göstergesi',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 12,
                    runSpacing: 8,
                    children: [
                      _buildLegendChip(
                        label: 'Yüzme + Koşu (Özel Kombo)',
                        color: const Color(0xFF00E5FF),
                        isGradient: true,
                      ),
                      _buildLegendChip(label: 'Yüzme', color: AppTheme.swimming),
                      _buildLegendChip(label: 'Koşu', color: AppTheme.running),
                      _buildLegendChip(label: 'Kitap Okuma', color: AppTheme.reading),
                      _buildLegendChip(label: 'Fitness', color: AppTheme.fitness),
                      _buildLegendChip(label: 'Su İçme', color: AppTheme.water),
                      _buildLegendChip(label: 'Sigara/Alkol', color: AppTheme.quitSmoking),
                      _buildLegendChip(label: 'Çoklu Alışkanlık', color: AppTheme.goldBadge),
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

  Widget _buildMonthGrid(int daysInMonth, int startingWeekday, int year, int month) {
    final List<Widget> dayWidgets = [];

    // Empty spaces before first day (Monday = 1, so offset = startingWeekday - 1)
    final offset = startingWeekday - 1;
    for (int i = 0; i < offset; i++) {
      dayWidgets.add(const SizedBox());
    }

    for (int d = 1; d <= daysInMonth; d++) {
      final dayDate = DateTime(year, month, d);
      final dateStr = _formatDate(dayDate);
      final logs = widget.state.getLogsForDate(dateStr);
      final isSelected = _selectedDay.year == year &&
          _selectedDay.month == month &&
          _selectedDay.day == d;

      final isCombo = logs.any((l) => l.category == 'swimming') &&
          logs.any((l) => l.category == 'running');

      dayWidgets.add(
        InkWell(
          onTap: () {
            setState(() {
              _selectedDay = dayDate;
            });
          },
          borderRadius: BorderRadius.circular(20),
          child: Container(
            margin: const EdgeInsets.all(2),
            decoration: _getDayDecoration(dayDate, isSelected, logs),
            child: Center(
              child: Text(
                '$d',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: (logs.isNotEmpty || isSelected)
                      ? FontWeight.w700
                      : FontWeight.w500,
                  color: isCombo
                      ? Colors.white
                      : (logs.isNotEmpty
                          ? AppTheme.textPrimary
                          : (isSelected ? AppTheme.primary : AppTheme.textSecondary)),
                ),
              ),
            ),
          ),
        ),
      );
    }

    return GridView.count(
      crossAxisCount: 7,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 6,
      crossAxisSpacing: 6,
      children: dayWidgets,
    );
  }

  Widget _buildDayLogItem(ActivityLogModel log) {
    Color itemColor = AppTheme.primary;
    IconData itemIcon = Icons.task_alt_rounded;
    String title = 'Aktivite';
    String detail = '';

    switch (log.category) {
      case 'swimming':
        itemColor = AppTheme.swimming;
        itemIcon = Icons.pool_rounded;
        title = 'Yüzme Antrenmanı';
        detail = '${log.durationMinutes ?? 30} dk • ${log.caloriesBurned?.toStringAsFixed(0) ?? "0"} kcal yakıldı';
        break;
      case 'running':
        itemColor = AppTheme.running;
        itemIcon = Icons.directions_run_rounded;
        title = 'Koşu';
        detail = '${log.distanceKm ?? 0} km • ${log.caloriesBurned?.toStringAsFixed(0) ?? "0"} kcal yakıldı';
        break;
      case 'reading':
        itemColor = AppTheme.reading;
        itemIcon = Icons.menu_book_rounded;
        title = 'Kitap Okuma';
        detail = '${log.pagesRead ?? 0} sayfa • ${log.bookGenre ?? "Kitap"} ${log.isBookFinished == true ? "(Bitirildi 🏆)" : ""}';
        break;
      case 'water':
        itemColor = AppTheme.water;
        itemIcon = Icons.water_drop_rounded;
        title = 'Su Tüketimi';
        detail = '${log.waterLiters ?? 0} Litre su içildi';
        break;
      case 'fitness':
        itemColor = AppTheme.fitness;
        itemIcon = Icons.fitness_center_rounded;
        title = 'Fitness';
        detail = '${log.durationMinutes ?? 0} dk • ${log.caloriesBurned?.toStringAsFixed(0) ?? "0"} kcal yakıldı';
        break;
      case 'healthy_food':
        itemColor = AppTheme.healthyFood;
        itemIcon = Icons.restaurant_rounded;
        title = 'Sağlıklı Beslenme';
        detail = '${log.caloriesSaved?.toStringAsFixed(0) ?? "0"} kcal kalori tasarrufu';
        break;
      case 'quit_smoking':
        itemColor = AppTheme.quitSmoking;
        itemIcon = Icons.smoke_free_rounded;
        title = 'Sigara Bırakma';
        detail = '${log.avoidedCount ?? 0} dal içilmedi • ${log.moneySavedTL?.toStringAsFixed(2) ?? "0"} TL kâr';
        break;
      case 'quit_alcohol':
        itemColor = AppTheme.quitAlcohol;
        itemIcon = Icons.no_drinks_rounded;
        title = 'Alkol Bırakma';
        detail = '${log.moneySavedTL?.toStringAsFixed(2) ?? "0"} TL tasarruf edildi';
        break;
      case 'mind_games':
        itemColor = AppTheme.mindGames;
        itemIcon = Icons.psychology_rounded;
        title = 'Zeka Oyunu';
        detail = '${log.durationMinutes ?? 0} dk • ${log.bookGenre ?? "Zeka Egzersizi"}';
        break;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(10),
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
            child: Icon(itemIcon, color: itemColor, size: 18),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textPrimary,
                  ),
                ),
                Text(
                  detail,
                  style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegendChip({
    required String label,
    required Color color,
    bool isGradient = false,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 14,
          height: 14,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isGradient ? null : color.withValues(alpha: 0.2),
            gradient: isGradient
                ? const LinearGradient(
                    colors: [Color(0xFF00E5FF), Color(0xFF2563EB)],
                  )
                : null,
            border: Border.all(color: color, width: 2),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary),
        ),
      ],
    );
  }
}
