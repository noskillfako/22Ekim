import 'package:flutter/material.dart';
import '../models/habit_model.dart';
import '../services/app_state.dart';
import '../services/avatar_service.dart';
import '../theme/app_theme.dart';
import '../widgets/activity_entry_modal.dart';
import '../widgets/add_habit_modal.dart';
import '../widgets/habit_card.dart';

class HomeScreen extends StatelessWidget {
  final AppState state;
  final VoidCallback onNavigateToProfile;

  const HomeScreen({
    super.key,
    required this.state,
    required this.onNavigateToProfile,
  });

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

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(Icons.local_fire_department_rounded, color: Colors.white, size: 18),
                  const SizedBox(width: 8),
                  Text('${habit.title} kaydedildi! Zincir devam ediyor.'),
                ],
              ),
              backgroundColor: AppTheme.primary,
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

                      return HabitCard(
                        habit: habit,
                        isCompletedToday: isCompletedToday,
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
