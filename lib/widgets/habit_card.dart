import 'dart:async';
import 'package:flutter/material.dart';
import '../models/habit_model.dart';
import '../theme/app_theme.dart';

class HabitCard extends StatefulWidget {
  final HabitModel habit;
  final bool isCompletedToday;
  final VoidCallback onLogActivity;
  final VoidCallback onDelete;

  const HabitCard({
    super.key,
    required this.habit,
    required this.isCompletedToday,
    required this.onLogActivity,
    required this.onDelete,
  });

  @override
  State<HabitCard> createState() => _HabitCardState();
}

class _HabitCardState extends State<HabitCard> with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  Timer? _longPressTimer;
  bool _isDeletingMode = false;
  double _holdProgress = 0.0;
  Timer? _progressTimer;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
  }

  @override
  void dispose() {
    _longPressTimer?.cancel();
    _progressTimer?.cancel();
    _animController.dispose();
    super.dispose();
  }

  void _onPointerDown(PointerDownEvent event) {
    if (_isDeletingMode) return;

    setState(() {
      _holdProgress = 0.0;
    });

    const int totalDurationMs = 3000;
    const int stepMs = 50;
    int elapsedMs = 0;

    _progressTimer = Timer.periodic(const Duration(milliseconds: stepMs), (timer) {
      elapsedMs += stepMs;
      if (mounted) {
        setState(() {
          _holdProgress = (elapsedMs / totalDurationMs).clamp(0.0, 1.0);
        });
      }
      if (elapsedMs >= totalDurationMs) {
        timer.cancel();
      }
    });

    _longPressTimer = Timer(const Duration(milliseconds: totalDurationMs), () {
      _triggerDeleteMode();
    });
  }

  void _onPointerUp(PointerUpEvent event) {
    _cancelHold();
  }

  void _onPointerCancel(PointerCancelEvent event) {
    _cancelHold();
  }

  void _cancelHold() {
    _longPressTimer?.cancel();
    _progressTimer?.cancel();
    if (!_isDeletingMode && _holdProgress > 0) {
      setState(() {
        _holdProgress = 0.0;
      });
    }
  }

  void _triggerDeleteMode() {
    _animController.forward(from: 0.0).then((_) {
      _animController.reverse();
    });
    setState(() {
      _isDeletingMode = true;
      _holdProgress = 0.0;
    });
  }

  void _exitDeleteMode() {
    setState(() {
      _isDeletingMode = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final habitColor = widget.habit.color;

    return AnimatedBuilder(
      animation: _animController,
      builder: (context, child) {
        final double shakeOffset = 6.0 * (_animController.value * 2 - 1).abs();
        return Transform.translate(
          offset: Offset(shakeOffset, 0),
          child: child,
        );
      },
      child: Stack(
        children: [
          Listener(
            onPointerDown: _onPointerDown,
            onPointerUp: _onPointerUp,
            onPointerCancel: _onPointerCancel,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: _isDeletingMode
                      ? AppTheme.error
                      : (widget.isCompletedToday
                          ? habitColor.withValues(alpha: 0.6)
                          : AppTheme.outlineVariant),
                  width: _isDeletingMode ? 2 : (widget.isCompletedToday ? 1.8 : 1),
                ),
                boxShadow: [
                  BoxShadow(
                    color: _isDeletingMode
                        ? AppTheme.error.withValues(alpha: 0.12)
                        : (widget.isCompletedToday
                            ? habitColor.withValues(alpha: 0.1)
                            : Colors.black.withValues(alpha: 0.04)),
                    blurRadius: 14,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(19),
                child: Column(
                  children: [
                    // Hold progress indicator at the top
                    if (_holdProgress > 0 && !_isDeletingMode)
                      LinearProgressIndicator(
                        value: _holdProgress,
                        backgroundColor: AppTheme.surfaceMuted,
                        valueColor: AlwaysStoppedAnimation<Color>(AppTheme.error),
                        minHeight: 4,
                      ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          // Animated Avatar/Icon container for category
                          Container(
                            width: 54,
                            height: 54,
                            decoration: BoxDecoration(
                              color: habitColor.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: habitColor.withValues(alpha: 0.25),
                                width: 1.5,
                              ),
                            ),
                            child: Center(
                              child: Icon(
                                widget.habit.icon,
                                color: habitColor,
                                size: 28,
                              ),
                            ),
                          ),
                          const SizedBox(width: 14),

                          // Habit Info
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        widget.habit.title,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700,
                                          color: AppTheme.textPrimary,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    if (widget.isCompletedToday)
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                        decoration: BoxDecoration(
                                          color: AppTheme.success.withValues(alpha: 0.12),
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: const Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(Icons.check_circle_rounded, size: 13, color: AppTheme.success),
                                            SizedBox(width: 4),
                                            Text(
                                              'Bugün Yapıldı',
                                              style: TextStyle(
                                                fontSize: 11,
                                                fontWeight: FontWeight.w600,
                                                color: AppTheme.success,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                  ],
                                ),
                                const SizedBox(height: 6),
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: habitColor.withValues(alpha: 0.08),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        widget.habit.categoryTitle,
                                        style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w600,
                                          color: habitColor,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    // Streak Badge with Fire Icon
                                    Row(
                                      children: [
                                        const Text('🔥', style: TextStyle(fontSize: 13)),
                                        const SizedBox(width: 3),
                                        Text(
                                          '${widget.habit.currentStreak} Gün Seri',
                                          style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w700,
                                            color: Color(0xFFEA580C), // Orange
                                          ),
                                        ),
                                        if (widget.habit.longestStreak > 0) ...[
                                          const SizedBox(width: 6),
                                          Text(
                                            '(En iyi: ${widget.habit.longestStreak})',
                                            style: const TextStyle(
                                              fontSize: 11,
                                              color: AppTheme.textMuted,
                                            ),
                                          ),
                                        ],
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(width: 10),

                          // Card Action: Either Delete or Add Activity (+) Button
                          if (_isDeletingMode)
                            ElevatedButton.icon(
                              onPressed: widget.onDelete,
                              icon: const Icon(Icons.delete_forever_rounded, size: 16),
                              label: const Text('Sil'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppTheme.error,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              ),
                            )
                          else
                            InkWell(
                              onTap: widget.onLogActivity,
                              borderRadius: BorderRadius.circular(12),
                              child: Container(
                                width: 42,
                                height: 42,
                                decoration: BoxDecoration(
                                  color: habitColor.withValues(alpha: 0.12),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: habitColor.withValues(alpha: 0.3),
                                    width: 1,
                                  ),
                                ),
                                child: Icon(
                                  widget.isCompletedToday ? Icons.add_task_rounded : Icons.add_rounded,
                                  color: habitColor,
                                  size: 24,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Delete Mode Dismiss Overlay (outside click closes)
          if (_isDeletingMode)
            Positioned(
              top: 2,
              right: 20,
              child: GestureDetector(
                onTap: _exitDeleteMode,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: AppTheme.textSecondary,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.close_rounded, size: 14, color: Colors.white),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
