import 'package:flutter/material.dart';
import '../services/app_state.dart';
import '../theme/app_theme.dart';

class NotificationCenterModal extends StatelessWidget {
  final AppState state;

  const NotificationCenterModal({
    super.key,
    required this.state,
  });

  static Future<void> show(BuildContext context, AppState state) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => NotificationCenterModal(state: state),
    );
  }

  String _formatNotificationTime(DateTime date) {
    const months = [
      'Oca', 'Şub', 'Mar', 'Nis', 'May', 'Haz',
      'Tem', 'Ağu', 'Eyl', 'Eki', 'Kas', 'Ara'
    ];
    final m = months[date.month - 1];
    final h = date.hour.toString().padLeft(2, '0');
    final min = date.minute.toString().padLeft(2, '0');
    return '${date.day} $m, $h:$min';
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'water':
        return AppTheme.water;
      case 'running':
        return AppTheme.running;
      case 'swimming':
        return AppTheme.swimming;
      case 'reading':
        return AppTheme.reading;
      case 'fitness':
        return AppTheme.fitness;
      case 'quit_smoking':
      case 'quit_alcohol':
        return AppTheme.quitSmoking;
      case 'streak_shield':
        return AppTheme.success;
      default:
        return AppTheme.primary;
    }
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'water':
        return Icons.water_drop_rounded;
      case 'running':
        return Icons.directions_run_rounded;
      case 'swimming':
        return Icons.pool_rounded;
      case 'reading':
        return Icons.menu_book_rounded;
      case 'fitness':
        return Icons.fitness_center_rounded;
      case 'quit_smoking':
        return Icons.smoke_free_rounded;
      case 'quit_alcohol':
        return Icons.no_drinks_rounded;
      case 'streak_shield':
        return Icons.verified_rounded;
      default:
        return Icons.notifications_active_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final notifications = state.notifications;
    final unreadCount = state.unreadNotificationsCount;

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.85,
      ),
      decoration: const BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(28),
          topRight: Radius.circular(28),
        ),
      ),
      child: Column(
        children: [
          // Drag Handle
          const SizedBox(height: 12),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppTheme.outlineVariant,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 12),

          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppTheme.primary.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.notifications_active_rounded,
                    color: AppTheme.primary,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Text(
                            'Bildirim Merkezi',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: AppTheme.textPrimary,
                            ),
                          ),
                          if (unreadCount > 0) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppTheme.error,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                '$unreadCount Yeni',
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      Text(
                        'Alışkanlık hatırlatıcıları ve seri uyarıları',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppTheme.textSecondary.withValues(alpha: 0.85),
                        ),
                      ),
                    ],
                  ),
                ),
                // Actions (Mark All Read & Clear)
                if (notifications.isNotEmpty) ...[
                  IconButton(
                    tooltip: 'Tümünü Okundu İşaretle',
                    icon: const Icon(Icons.done_all_rounded, size: 20, color: AppTheme.primary),
                    onPressed: () {
                      state.markAllNotificationsAsRead();
                    },
                  ),
                  IconButton(
                    tooltip: 'Tümünü Temizle',
                    icon: const Icon(Icons.delete_sweep_rounded, size: 20, color: AppTheme.textMuted),
                    onPressed: () {
                      state.clearNotifications();
                    },
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 12),
          const Divider(height: 1, color: AppTheme.outlineVariant),

          // Content
          Expanded(
            child: notifications.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 72,
                            height: 72,
                            decoration: const BoxDecoration(
                              color: AppTheme.surfaceMuted,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.notifications_none_rounded,
                              size: 36,
                              color: AppTheme.textMuted,
                            ),
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Henüz Bildirim Yok',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: AppTheme.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Demo zaman makinesinde bir sonraki güne geçtiğinizde, o gün yapılmayan alışkanlıklarınız ve seri kırılmaları anında burada listelenir.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 13,
                              color: AppTheme.textSecondary.withValues(alpha: 0.8),
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    itemCount: notifications.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final item = notifications[index];
                      final catColor = _getCategoryColor(item.category);
                      final catIcon = _getCategoryIcon(item.category);

                      return InkWell(
                        onTap: () {
                          if (!item.isRead) {
                            state.markNotificationAsRead(item.id);
                          }
                        },
                        borderRadius: BorderRadius.circular(16),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: item.isRead
                                ? AppTheme.surfaceMuted.withValues(alpha: 0.6)
                                : (item.isStreakBroken
                                    ? AppTheme.error.withValues(alpha: 0.06)
                                    : AppTheme.primaryContainer.withValues(alpha: 0.4)),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: item.isRead
                                  ? AppTheme.outlineVariant
                                  : (item.isStreakBroken
                                      ? AppTheme.error.withValues(alpha: 0.3)
                                      : AppTheme.primary.withValues(alpha: 0.3)),
                            ),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Category Badge Icon
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: catColor.withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(catIcon, color: catColor, size: 22),
                              ),
                              const SizedBox(width: 12),

                              // Notification Text Content
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        if (item.isStreakBroken) ...[
                                          Container(
                                            margin: const EdgeInsets.only(right: 6),
                                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                            decoration: BoxDecoration(
                                              color: AppTheme.error,
                                              borderRadius: BorderRadius.circular(6),
                                            ),
                                            child: const Text(
                                              'SERİ SIFIRLANDI',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 9,
                                                fontWeight: FontWeight.w800,
                                              ),
                                            ),
                                          ),
                                        ],
                                        Expanded(
                                          child: Text(
                                            item.title,
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: item.isRead ? FontWeight.w600 : FontWeight.w700,
                                              color: AppTheme.textPrimary,
                                            ),
                                          ),
                                        ),
                                        Text(
                                          _formatNotificationTime(item.timestamp),
                                          style: const TextStyle(
                                            fontSize: 11,
                                            color: AppTheme.textMuted,
                                          ),
                                        ),
                                        if (!item.isRead) ...[
                                          const SizedBox(width: 6),
                                          Container(
                                            width: 8,
                                            height: 8,
                                            decoration: BoxDecoration(
                                              color: item.isStreakBroken ? AppTheme.error : AppTheme.primary,
                                              shape: BoxShape.circle,
                                            ),
                                          ),
                                        ],
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      item.message,
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: item.isRead
                                            ? AppTheme.textSecondary
                                            : AppTheme.textPrimary.withValues(alpha: 0.9),
                                        height: 1.35,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              // Delete Button
                              IconButton(
                                icon: const Icon(Icons.close_rounded, size: 16, color: AppTheme.textMuted),
                                onPressed: () {
                                  state.deleteNotification(item.id);
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
