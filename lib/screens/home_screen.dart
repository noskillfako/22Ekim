import 'package:flutter/material.dart';
import '../models/habit_model.dart';
import '../services/app_state.dart';
import '../services/avatar_service.dart';
import '../theme/app_theme.dart';
import '../widgets/activity_entry_modal.dart';
import '../widgets/add_habit_modal.dart';
import '../widgets/day_transition_dialog.dart';
import '../widgets/habit_card.dart';
import '../widgets/notification_center_modal.dart';
import '../widgets/time_travel_modal.dart';

class HomeScreen extends StatelessWidget {
  final AppState state;
  final VoidCallback onNavigateToProfile;

  const HomeScreen({
    super.key,
    required this.state,
    required this.onNavigateToProfile,
  });

  String _formatTurkishDateHeader(DateTime date) {
    const months = [
      'Ocak', 'Şubat', 'Mart', 'Nisan', 'Mayıs', 'Haziran',
      'Temmuz', 'Ağustos', 'Eylül', 'Ekim', 'Kasım', 'Aralık'
    ];
    const weekdays = [
      'Pazartesi', 'Salı', 'Çarşamba', 'Perşembe', 'Cuma', 'Cumartesi', 'Pazar'
    ];
    final m = months[date.month - 1];
    final w = weekdays[date.weekday - 1];
    return '${date.day} $m, $w';
  }

  Future<void> _handleAdvanceDay(BuildContext context) async {
    final result = await state.advanceDay(days: 1);
    if (context.mounted) {
      showDialog(
        context: context,
        builder: (_) => DayTransitionDialog(
          result: result,
          onDismiss: () => Navigator.of(context).pop(),
        ),
      );
    }
  }

  void _openAddHabitModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => AddHabitModal(
        existingHabits: state.habits,
        onAddHabit: ({
          required String title,
          required String category,
          required String colorHex,
          int? smokingBaseline,
          double? smokingPackPrice,
          double? alcoholPrice,
        }) {
          state.addHabit(
            title: title,
            category: category,
            colorHex: colorHex,
            smokingBaseline: smokingBaseline,
            smokingPackPrice: smokingPackPrice,
            alcoholPrice: alcoholPrice,
          );
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(Icons.check_circle_rounded, color: Colors.white, size: 18),
                  const SizedBox(width: 8),
                  Text('"$title" alışkanlığı listenize eklendi!'),
                ],
              ),
              backgroundColor: AppTheme.success,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
          );
        },
      ),
    );
  }

  void _openActivityEntryModal(BuildContext context, HabitModel habit) {
    if (state.currentUser == null) return;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => ActivityEntryModal(
        habit: habit,
        user: state.currentUser!,
        isWatchConnected: state.isWatchConnected,
        onSave: ({
          int? durationMinutes,
          double? distanceKm,
          int? pagesRead,
          int? bookTotalPages,
          String? bookGenre,
          bool? isBookFinished,
          double? waterLiters,
          int? mealCalories,
          int? smokedCount,
          int? avoidedCount,
        }) {
          state.logActivity(
            habitId: habit.id,
            category: habit.category,
            durationMinutes: durationMinutes,
            distanceKm: distanceKm,
            pagesRead: pagesRead,
            bookTotalPages: bookTotalPages,
            bookGenre: bookGenre,
            isBookFinished: isBookFinished,
            waterLiters: waterLiters,
            mealCalories: mealCalories,
            smokedCount: smokedCount,
            avoidedCount: avoidedCount,
          );

          final isSmokeBroken = habit.category == 'quit_smoking' && (smokedCount ?? 0) > 0;

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  Icon(
                    isSmokeBroken ? Icons.heart_broken_rounded : Icons.local_fire_department_rounded,
                    color: Colors.white,
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      isSmokeBroken
                          ? '$smokedCount dal sigara içildiği için seri sıfırlandı. Pes etmek yok, yarın yeniden başla!'
                          : '${habit.title} kaydedildi! Zincir devam ediyor.',
                    ),
                  ),
                ],
              ),
              backgroundColor: isSmokeBroken ? AppTheme.error : AppTheme.primary,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
          );
        },
      ),
    );
  }

  void _confirmDeleteHabit(BuildContext context, HabitModel habit) {
    state.deleteHabit(habit.id);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.delete_outline_rounded, color: Colors.white, size: 18),
            const SizedBox(width: 8),
            Text('"${habit.title}" alışkanlığı kaldırıldı.'),
          ],
        ),
        backgroundColor: AppTheme.error,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = state.currentUser;
    final habits = state.habits;
    final today = state.todayString;

    final completedCount = habits.where((h) => h.lastCompletedDate == today).length;
    final totalCount = habits.length;
    final completionRatio = totalCount > 0 ? (completedCount / totalCount) : 0.0;

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        toolbarHeight: 74,
        title: Row(
          children: [
            if (user != null)
              UserAvatarWidget(
                avatarId: user.avatarId,
                radius: 20,
                onTap: onNavigateToProfile,
              ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Merhaba, ${user?.fullName ?? "Kullanıcı"} 👋',
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.textPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  const Text(
                    'Bugün zinciri kırma, hedeflerine odaklan!',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          // Notifications Bell Button
          IconButton(
            tooltip: 'Bildirim Merkezi',
            onPressed: () => NotificationCenterModal.show(context, state),
            icon: Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: state.unreadNotificationsCount > 0
                        ? AppTheme.primaryContainer
                        : AppTheme.surfaceMuted,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: state.unreadNotificationsCount > 0
                          ? AppTheme.primary.withValues(alpha: 0.4)
                          : AppTheme.outlineVariant,
                    ),
                  ),
                  child: Icon(
                    state.unreadNotificationsCount > 0
                        ? Icons.notifications_active_rounded
                        : Icons.notifications_none_rounded,
                    color: state.unreadNotificationsCount > 0
                        ? AppTheme.primary
                        : AppTheme.textSecondary,
                    size: 22,
                  ),
                ),
                if (state.unreadNotificationsCount > 0)
                  Positioned(
                    top: -2,
                    right: -2,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppTheme.error,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.white, width: 1.5),
                      ),
                      child: Text(
                        '${state.unreadNotificationsCount}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),

          // Demo Time Travel Button
          IconButton(
            tooltip: 'Demo Zaman Makinesi',
            onPressed: () => TimeTravelModal.show(context, state),
            icon: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: state.isSimulatedTime
                    ? const Color(0xFFFEF3C7)
                    : AppTheme.surfaceMuted,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: state.isSimulatedTime
                      ? const Color(0xFFF59E0B)
                      : AppTheme.outlineVariant,
                ),
              ),
              child: Icon(
                Icons.schedule_rounded,
                color: state.isSimulatedTime
                    ? const Color(0xFFD97706)
                    : AppTheme.textSecondary,
                size: 22,
              ),
            ),
          ),

          // General "+" Button in Top Right (Header)
          Padding(
            padding: const EdgeInsets.only(right: 14.0),
            child: IconButton(
              tooltip: 'Yeni Alışkanlık Ekle',
              onPressed: () => _openAddHabitModal(context),
              icon: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppTheme.primary,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.primary.withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: const Icon(Icons.add_rounded, color: Colors.white, size: 24),
              ),
            ),
          ),
        ],
      ),
      body: habits.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: AppTheme.primaryContainer,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.playlist_add_check_rounded,
                          size: 44, color: AppTheme.primary),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Henüz Alışkanlık Eklenmedi',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Sağ üstteki "+" butonuna tıklayarak ilk pozitif alışkanlığınızı ekleyin.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14, color: AppTheme.textSecondary),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                      onPressed: () => _openAddHabitModal(context),
                      icon: const Icon(Icons.add_rounded),
                      label: const Text('Alışkanlık Ekle'),
                    ),
                  ],
                ),
              ),
            )
          : CustomScrollView(
              slivers: [
                // Demo Zaman & Gün Simülatörü Banner
                SliverToBoxAdapter(
                  child: Container(
                    margin: const EdgeInsets.fromLTRB(16, 12, 16, 4),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
                    decoration: BoxDecoration(
                      color: state.isSimulatedTime
                          ? const Color(0xFFFFFBEB)
                          : AppTheme.surface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: state.isSimulatedTime
                            ? const Color(0xFFF59E0B)
                            : AppTheme.outlineVariant,
                        width: state.isSimulatedTime ? 1.5 : 1.0,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.04),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: state.isSimulatedTime
                                ? const Color(0xFFF59E0B).withValues(alpha: 0.18)
                                : AppTheme.primary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            state.isSimulatedTime
                                ? Icons.history_toggle_off_rounded
                                : Icons.calendar_today_rounded,
                            color: state.isSimulatedTime
                                ? const Color(0xFFD97706)
                                : AppTheme.primary,
                            size: 18,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    _formatTurkishDateHeader(state.currentDateTime),
                                    style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w700,
                                      color: AppTheme.textPrimary,
                                    ),
                                  ),
                                  if (state.isSimulatedTime) ...[
                                    const SizedBox(width: 6),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFF59E0B),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: const Text(
                                        'DEMO',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 9,
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                              Text(
                                state.isSimulatedTime
                                    ? 'Saat: ${state.currentDateTime.hour.toString().padLeft(2, '0')}:${state.currentDateTime.minute.toString().padLeft(2, '0')} (Simülasyon Aktif)'
                                    : 'Gerçek zamanlı görünüm',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: AppTheme.textSecondary.withValues(alpha: 0.85),
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Quick Advance +1 Day Button
                        ElevatedButton.icon(
                          onPressed: () => _handleAdvanceDay(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.primary,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            elevation: 0,
                          ),
                          icon: const Icon(Icons.fast_forward_rounded, size: 15),
                          label: const Text(
                            '+1 Gün',
                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
                          ),
                        ),
                        const SizedBox(width: 4),
                        IconButton(
                          tooltip: 'Tarih & Saat Ayarla',
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                          icon: const Icon(Icons.tune_rounded, size: 19, color: AppTheme.textSecondary),
                          onPressed: () => TimeTravelModal.show(context, state),
                        ),
                      ],
                    ),
                  ),
                ),
                // Top Motivation Card
                SliverToBoxAdapter(
                  child: Container(
                    margin: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF2563EB), Color(0xFF1D4ED8)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF2563EB).withValues(alpha: 0.25),
                          blurRadius: 14,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Text(
                              'Günün İlerlemesi',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const Spacer(),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                '$completedCount / $totalCount Tamamlandı',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: LinearProgressIndicator(
                            value: completionRatio,
                            minHeight: 8,
                            backgroundColor: Colors.white.withValues(alpha: 0.25),
                            valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'İpucu: Alışkanlığı silmek için kartın üzerine 3 saniye basılı tutun.',
                          style: TextStyle(
                            color: Color(0xFFBFDBFE),
                            fontSize: 11.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Section Title
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 14, 20, 6),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Aktif Alışkanlıklarım',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                        Text(
                          '$totalCount Alışkanlık',
                          style: const TextStyle(
                            fontSize: 13,
                            color: AppTheme.textMuted,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Habit Cards List (ListView.builder equivalent in Slivers)
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final habit = habits[index];
                      final isCompletedToday = habit.lastCompletedDate == today;
                      final isStreakBrokenToday = habit.category == 'quit_smoking' &&
                          state.getLogsForDate(today).any(
                                (l) => l.habitId == habit.id && (l.smokedCount ?? 0) > 0,
                              );

                      return HabitCard(
                        habit: habit,
                        isCompletedToday: isCompletedToday,
                        isStreakBrokenToday: isStreakBrokenToday,
                        onLogActivity: () => _openActivityEntryModal(context, habit),
                        onDelete: () => _confirmDeleteHabit(context, habit),
                      );
                    },
                    childCount: habits.length,
                  ),
                ),

                const SliverToBoxAdapter(
                  child: SizedBox(height: 24),
                ),
              ],
            ),
    );
  }
}
