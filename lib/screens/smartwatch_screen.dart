import 'dart:math';
import 'package:flutter/material.dart';
import '../services/app_state.dart';
import '../theme/app_theme.dart';

class SmartwatchScreen extends StatefulWidget {
  final AppState state;

  const SmartwatchScreen({
    super.key,
    required this.state,
  });

  @override
  State<SmartwatchScreen> createState() => _SmartwatchScreenState();
}

class _SmartwatchScreenState extends State<SmartwatchScreen> with SingleTickerProviderStateMixin {
  int _selectedTab = 0; // 0: Weekly (7 Days), 1: Monthly (30 Days)
  int? _selectedBarIndex;
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  String _formatDate(DateTime d) {
    final y = d.year.toString().padLeft(4, '0');
    final m = d.month.toString().padLeft(2, '0');
    final day = d.day.toString().padLeft(2, '0');
    return '$y-$m-$day';
  }

  @override
  Widget build(BuildContext context) {
    final isConnected = widget.state.isWatchConnected;

    // Prepare chart data
    final now = DateTime.now();
    final int daysCount = _selectedTab == 0 ? 7 : 30;
    final List<Map<String, dynamic>> dailyData = [];

    double totalBurned = 0.0;
    double maxBurned = 100.0; // Min scale

    for (int i = daysCount - 1; i >= 0; i--) {
      final date = now.subtract(Duration(days: i));
      final dateStr = _formatDate(date);
      final logs = widget.state.getLogsForDate(dateStr);

      double dayCalories = 0.0;
      final Map<String, double> sportsBreakdown = {};

      for (final l in logs) {
        if (l.caloriesBurned != null && l.caloriesBurned! > 0) {
          dayCalories += l.caloriesBurned!;
          final catName = l.category == 'swimming'
              ? 'Yüzme'
              : (l.category == 'running'
                  ? 'Koşu'
                  : (l.category == 'fitness' ? 'Fitness' : 'Diğer Spor'));
          sportsBreakdown[catName] = (sportsBreakdown[catName] ?? 0) + l.caloriesBurned!;
        }
      }

      totalBurned += dayCalories;
      if (dayCalories > maxBurned) {
        maxBurned = dayCalories;
      }

      dailyData.add({
        'date': date,
        'dateStr': dateStr,
        'calories': dayCalories,
        'breakdown': sportsBreakdown,
        'label': _selectedTab == 0
            ? ['Pzt', 'Sal', 'Çar', 'Per', 'Cum', 'Cmt', 'Paz'][date.weekday - 1]
            : '${date.day}',
      });
    }

    final double avgBurned = totalBurned / daysCount;

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('Akıllı Saat ve Kalori Analitiği'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 24),
        child: Column(
          children: [
            // Smartwatch Device Pairing Panel (watchskill.md)
            Container(
              margin: const EdgeInsets.fromLTRB(16, 8, 16, 12),
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isConnected ? const Color(0xFF10B981) : AppTheme.outlineVariant,
                  width: isConnected ? 1.8 : 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: isConnected
                        ? const Color(0xFF10B981).withValues(alpha: 0.1)
                        : Colors.black.withValues(alpha: 0.03),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: isConnected
                              ? const Color(0xFF10B981).withValues(alpha: 0.12)
                              : AppTheme.surfaceMuted,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.watch_rounded,
                          color: isConnected ? const Color(0xFF10B981) : AppTheme.textMuted,
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              isConnected ? 'Apple Watch Series 9' : 'Akıllı Saat Bağlı Değil',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: AppTheme.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              isConnected
                                  ? 'Bağlantı Aktif • HealthKit Senkronize'
                                  : 'Apple Watch / Galaxy Watch / Mi Band',
                              style: TextStyle(
                                fontSize: 12,
                                color: isConnected ? const Color(0xFF10B981) : AppTheme.textMuted,
                                fontWeight: isConnected ? FontWeight.w600 : FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          widget.state.toggleWatchConnection();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isConnected ? AppTheme.surfaceMuted : AppTheme.primary,
                          foregroundColor: isConnected ? AppTheme.textPrimary : Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: Text(
                          isConnected ? 'Bağlantıyı Kes' : 'Saat Bağla',
                          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
                        ),
                      ),
                    ],
                  ),

                  // Fallback Warning Banner if disconnected (errorskill.md rule 2)
                  if (!isConnected) ...[
                    const SizedBox(height: 14),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFEF3C7), // Amber 100
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFFDE68A)),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.info_outline_rounded, color: Color(0xFFD97706), size: 20),
                          SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'Saat bağlantısı kurulamadı, kaloriler tahmini olarak hesaplanacaktır.',
                              style: TextStyle(
                                color: Color(0xFF92400E),
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],

                  // Live Simulation Stats when Connected
                  if (isConnected) ...[
                    const SizedBox(height: 16),
                    const Divider(height: 1, color: AppTheme.outlineVariant),
                    const SizedBox(height: 14),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        // Heart rate with pulsing animation
                        AnimatedBuilder(
                          animation: _pulseController,
                          builder: (context, child) {
                            final scale = 1.0 + (_pulseController.value * 0.15);
                            return Column(
                              children: [
                                Transform.scale(
                                  scale: scale,
                                  child: const Icon(Icons.favorite_rounded,
                                      color: Color(0xFFEF4444), size: 22),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  '${widget.state.simulatedHeartRate} bpm',
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                    color: AppTheme.textPrimary,
                                  ),
                                ),
                                const Text('Kalp Ritmi',
                                    style: TextStyle(fontSize: 11, color: AppTheme.textMuted)),
                              ],
                            );
                          },
                        ),
                        // Active Calories
                        Column(
                          children: [
                            const Icon(Icons.local_fire_department_rounded,
                                color: Color(0xFFEA580C), size: 22),
                            const SizedBox(height: 6),
                            Text(
                              '${widget.state.simulatedActiveCaloriesBurned.toStringAsFixed(0)} kcal',
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: AppTheme.textPrimary,
                              ),
                            ),
                            const Text('Aktif Kalori',
                                style: TextStyle(fontSize: 11, color: AppTheme.textMuted)),
                          ],
                        ),
                        // Steps
                        Column(
                          children: [
                            const Icon(Icons.directions_walk_rounded,
                                color: Color(0xFF2563EB), size: 22),
                            const SizedBox(height: 6),
                            Text(
                              '${widget.state.simulatedSteps}',
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: AppTheme.textPrimary,
                              ),
                            ),
                            const Text('Adım Sayısı',
                                style: TextStyle(fontSize: 11, color: AppTheme.textMuted)),
                          ],
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),

            // Kalori ve Efor Grafikleri (watchskill.md)
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(18),
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Segmented Tabs: Haftalık vs Aylık
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Yakılan Kalori Grafiği',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          color: AppTheme.surfaceMuted,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            _buildTabButton(label: 'Haftalık', index: 0),
                            _buildTabButton(label: 'Aylık', index: 1),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Summary Chips
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryContainer,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Toplam Yakılan',
                                  style: TextStyle(fontSize: 11, color: AppTheme.primary)),
                              const SizedBox(height: 2),
                              Text(
                                '${totalBurned.toStringAsFixed(0)} kcal',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: AppTheme.primary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF0FDF4),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Günlük Ortalama',
                                  style: TextStyle(fontSize: 11, color: Color(0xFF16A34A))),
                              const SizedBox(height: 2),
                              Text(
                                '${avgBurned.toStringAsFixed(0)} kcal',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF16A34A),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Interactive Custom Bar Chart (watchskill.md)
                  SizedBox(
                    height: 180,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: List.generate(dailyData.length, (index) {
                        final data = dailyData[index];
                        final double calories = data['calories'] as double;
                        final double ratio = maxBurned > 0 ? (calories / maxBurned) : 0.0;
                        final bool isSelected = _selectedBarIndex == index;

                        return Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedBarIndex = (_selectedBarIndex == index) ? null : index;
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 2.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  // Bar
                                  AnimatedContainer(
                                    duration: const Duration(milliseconds: 300),
                                    height: max(6.0, 140 * ratio),
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? const Color(0xFFEA580C)
                                          : (calories > 0
                                              ? AppTheme.primary
                                              : AppTheme.outlineVariant),
                                      borderRadius: BorderRadius.circular(6),
                                      boxShadow: isSelected
                                          ? [
                                              BoxShadow(
                                                color: const Color(0xFFEA580C).withValues(alpha: 0.35),
                                                blurRadius: 8,
                                                offset: const Offset(0, 2),
                                              ),
                                            ]
                                          : null,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  // Label
                                  Text(
                                    data['label'] as String,
                                    style: TextStyle(
                                      fontSize: _selectedTab == 0 ? 11 : 9,
                                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                                      color: isSelected ? AppTheme.primary : AppTheme.textMuted,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  ),

                  // Tooltip / Breakdown card when bar is clicked
                  if (_selectedBarIndex != null && _selectedBarIndex! < dailyData.length) ...[
                    const SizedBox(height: 16),
                    _buildSelectedBarTooltip(dailyData[_selectedBarIndex!]),
                  ] else ...[
                    const SizedBox(height: 12),
                    const Center(
                      child: Text(
                        'Detayları görmek için grafikteki bir sütuna dokunun.',
                        style: TextStyle(fontSize: 12, color: AppTheme.textMuted),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabButton({required String label, required int index}) {
    final isSelected = _selectedTab == index;
    return InkWell(
      onTap: () {
        setState(() {
          _selectedTab = index;
          _selectedBarIndex = null;
        });
      },
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 4,
                  ),
                ]
              : null,
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            color: isSelected ? AppTheme.textPrimary : AppTheme.textMuted,
          ),
        ),
      ),
    );
  }

  Widget _buildSelectedBarTooltip(Map<String, dynamic> data) {
    final DateTime date = data['date'] as DateTime;
    final double calories = data['calories'] as double;
    final Map<String, double> breakdown = data['breakdown'] as Map<String, double>;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.surfaceMuted,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${date.day}.${date.month}.${date.year} Aktivite Detayı',
                style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
              ),
              Text(
                'Toplam: ${calories.toStringAsFixed(0)} kcal',
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                  color: Color(0xFFEA580C),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          if (breakdown.isEmpty)
            const Text(
              'Bu gün kaydedilmiş spor/kalori aktivitesi yok.',
              style: TextStyle(fontSize: 12, color: AppTheme.textMuted),
            )
          else
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: breakdown.entries.map((e) {
                return Chip(
                  label: Text('${e.key}: ${e.value.toStringAsFixed(0)} kcal'),
                  labelStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
                  backgroundColor: Colors.white,
                  padding: EdgeInsets.zero,
                  visualDensity: VisualDensity.compact,
                  side: const BorderSide(color: AppTheme.outlineVariant),
                );
              }).toList(),
            ),
        ],
      ),
    );
  }
}
