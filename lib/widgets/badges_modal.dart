import 'package:flutter/material.dart';
import '../models/badge_model.dart';
import '../theme/app_theme.dart';

class BadgesModal extends StatefulWidget {
  final List<BadgeModel> badges;

  const BadgesModal({
    super.key,
    required this.badges,
  });

  @override
  State<BadgesModal> createState() => _BadgesModalState();
}

class _BadgesModalState extends State<BadgesModal> {
  String _selectedCategory = 'all';

  final List<Map<String, String>> _categories = const [
    {'id': 'all', 'label': 'Tümü'},
    {'id': 'reading', 'label': 'Kitap'},
    {'id': 'sports', 'label': 'Spor'},
    {'id': 'healthy', 'label': 'Sağlık & Su'},
    {'id': 'savings', 'label': 'Tasarruf'},
    {'id': 'streak', 'label': 'Zincir'},
  ];

  @override
  Widget build(BuildContext context) {
    final filteredBadges = widget.badges.where((b) {
      if (_selectedCategory == 'all') return true;
      if (_selectedCategory == 'reading') return b.category == 'reading';
      if (_selectedCategory == 'sports') {
        return b.category == 'swimming' || b.category == 'running' || b.category == 'fitness' || b.category == 'other_sports';
      }
      if (_selectedCategory == 'healthy') {
        return b.category == 'water' || b.category == 'healthy_food';
      }
      if (_selectedCategory == 'savings') {
        return b.category == 'quit_smoking' || b.category == 'quit_alcohol';
      }
      if (_selectedCategory == 'streak') return b.category == 'streak';
      return true;
    }).toList();

    final unlockedCount = widget.badges.where((b) => b.isUnlocked).length;

    return Container(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 16, bottom: 24),
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.88,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Drag handle
          Center(
            child: Container(
              width: 44,
              height: 4,
              margin: const EdgeInsets.only(bottom: 14),
              decoration: BoxDecoration(
                color: AppTheme.outlineVariant,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          // Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppTheme.goldBadge.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.military_tech_rounded, color: Color(0xFFD97706), size: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Başarı Rozetleri',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    Text(
                      '$unlockedCount / ${widget.badges.length} Rozet Kazanıldı',
                      style: const TextStyle(fontSize: 13, color: AppTheme.textSecondary),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.close_rounded, color: AppTheme.textSecondary),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Category Chips Filter
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _categories.map((cat) {
                final isSelected = _selectedCategory == cat['id'];
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: FilterChip(
                    label: Text(cat['label']!),
                    selected: isSelected,
                    selectedColor: AppTheme.primaryContainer,
                    backgroundColor: AppTheme.surfaceMuted,
                    labelStyle: TextStyle(
                      color: isSelected ? AppTheme.primary : AppTheme.textSecondary,
                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                      fontSize: 13,
                    ),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    side: BorderSide(
                      color: isSelected ? AppTheme.primary : AppTheme.outlineVariant,
                      width: 1,
                    ),
                    onSelected: (_) {
                      setState(() {
                        _selectedCategory = cat['id']!;
                      });
                    },
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 16),

          // Grid of Badges
          Expanded(
            child: GridView.builder(
              itemCount: filteredBadges.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.82,
              ),
              itemBuilder: (context, index) {
                final badge = filteredBadges[index];
                return _buildBadgeCard(badge);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBadgeCard(BadgeModel badge) {
    final bool isGoldSpecial = badge.id == 'gold_librarian_100';
    final tierColor = badge.tierColor;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: badge.isUnlocked
            ? (isGoldSpecial
                ? const Color(0xFFFEF9C3) // Bright gold glow
                : tierColor.withValues(alpha: 0.08))
            : AppTheme.surfaceMuted,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: badge.isUnlocked
              ? (isGoldSpecial ? const Color(0xFFEAB308) : tierColor)
              : AppTheme.outlineVariant,
          width: badge.isUnlocked ? 2 : 1,
        ),
        boxShadow: badge.isUnlocked
            ? [
                BoxShadow(
                  color: (isGoldSpecial ? const Color(0xFFEAB308) : tierColor).withValues(alpha: 0.25),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ]
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icon with status
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: badge.isUnlocked ? Colors.white : Colors.white.withValues(alpha: 0.7),
                  border: Border.all(
                    color: badge.isUnlocked ? tierColor : AppTheme.outline,
                    width: 2,
                  ),
                ),
                child: Icon(
                  badge.icon,
                  size: 28,
                  color: badge.isUnlocked ? tierColor : AppTheme.textMuted,
                ),
              ),
              if (!badge.isUnlocked)
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.black.withValues(alpha: 0.25),
                  ),
                  child: const Center(
                    child: Icon(Icons.lock_rounded, size: 20, color: Colors.white),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),

          // Title
          Text(
            badge.title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: badge.isUnlocked ? AppTheme.textPrimary : AppTheme.textSecondary,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),

          // Description
          Text(
            badge.description,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 10.5,
              color: AppTheme.textMuted,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const Spacer(),

          // Progress bar or Unlocked tag
          if (badge.isUnlocked)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: tierColor.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.verified_rounded, size: 12, color: tierColor),
                  const SizedBox(width: 4),
                  Text(
                    'Kazanıldı',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: tierColor,
                    ),
                  ),
                ],
              ),
            )
          else ...[
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: badge.progressPercent,
                minHeight: 5,
                backgroundColor: AppTheme.outlineVariant,
                valueColor: AlwaysStoppedAnimation<Color>(tierColor),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '${badge.currentValue.toStringAsFixed(badge.currentValue % 1 == 0 ? 0 : 1)} / ${badge.targetValue.toInt()} ${badge.unit} (%${(badge.progressPercent * 100).toInt()})',
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: AppTheme.textSecondary,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
