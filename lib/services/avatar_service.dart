import 'package:flutter/material.dart';

class AvatarData {
  final String id;
  final String label;
  final String description;
  final IconData baseIcon;
  final List<Color> gradientColors;
  final Color accentColor;
  final IconData? accessoryIcon;

  const AvatarData({
    required this.id,
    required this.label,
    required this.description,
    required this.baseIcon,
    required this.gradientColors,
    required this.accentColor,
    this.accessoryIcon,
  });
}

class AvatarService {
  /// Assigns avatarId based on age and gender matrix (avatarskill.md)
  static String getAvatarId(int age, String gender) {
    final g = gender.toLowerCase();
    final isMale = g == 'male' || g == 'erkek';
    final isFemale = g == 'female' || g == 'kadın' || g == 'kadin';

    if (age < 20) {
      if (isMale) return 'avatar_male_teen';
      if (isFemale) return 'avatar_female_teen';
      return 'avatar_neutral_teen';
    } else if (age <= 45) {
      if (isMale) return 'avatar_male_adult';
      if (isFemale) return 'avatar_female_adult';
      return 'avatar_neutral_adult';
    } else {
      if (isMale) return 'avatar_male_senior';
      if (isFemale) return 'avatar_female_senior';
      return 'avatar_neutral_senior';
    }
  }

  static const Map<String, AvatarData> avatars = {
    'avatar_male_teen': AvatarData(
      id: 'avatar_male_teen',
      label: 'Genç Atlet',
      description: 'Enerjik, spor tutkunu genç erkek avatarı',
      baseIcon: Icons.sports_tennis_rounded,
      gradientColors: [Color(0xFF38BDF8), Color(0xFF0284C7)],
      accentColor: Color(0xFFFACC15),
      accessoryIcon: Icons.bolt_rounded,
    ),
    'avatar_female_teen': AvatarData(
      id: 'avatar_female_teen',
      label: 'Genç Kaşif',
      description: 'Dinamik, meraklı ve enerjik genç kadın avatarı',
      baseIcon: Icons.skateboarding_rounded,
      gradientColors: [Color(0xFFF472B6), Color(0xFFDB2777)],
      accentColor: Color(0xFF38BDF8),
      accessoryIcon: Icons.star_rounded,
    ),
    'avatar_neutral_teen': AvatarData(
      id: 'avatar_neutral_teen',
      label: 'Genç Öğrenci',
      description: 'Öğrenmeye ve gelişime açık genç avatarı',
      baseIcon: Icons.school_rounded,
      gradientColors: [Color(0xFFA78BFA), Color(0xFF7C3AED)],
      accentColor: Color(0xFF34D399),
      accessoryIcon: Icons.auto_awesome_rounded,
    ),
    'avatar_male_adult': AvatarData(
      id: 'avatar_male_adult',
      label: 'Modern Profesyonel',
      description: 'Dinamik, hedef odaklı yetişkin erkek avatarı',
      baseIcon: Icons.fitness_center_rounded,
      gradientColors: [Color(0xFF2563EB), Color(0xFF1E3A8A)],
      accentColor: Color(0xFF60A5FA),
      accessoryIcon: Icons.watch_rounded,
    ),
    'avatar_female_adult': AvatarData(
      id: 'avatar_female_adult',
      label: 'İlham Veren Lider',
      description: 'Kararlı, dengeli ve üretken yetişkin kadın avatarı',
      baseIcon: Icons.self_improvement_rounded,
      gradientColors: [Color(0xFFEC4899), Color(0xFF9D174D)],
      accentColor: Color(0xFFF43F5E),
      accessoryIcon: Icons.favorite_rounded,
    ),
    'avatar_neutral_adult': AvatarData(
      id: 'avatar_neutral_adult',
      label: 'Dengeli Yaşam Mimarı',
      description: 'Modern, odaklanmış yetişkin avatarı',
      baseIcon: Icons.spa_rounded,
      gradientColors: [Color(0xFF14B8A6), Color(0xFF0F766E)],
      accentColor: Color(0xFF5EEAD4),
      accessoryIcon: Icons.eco_rounded,
    ),
    'avatar_male_senior': AvatarData(
      id: 'avatar_male_senior',
      label: 'Bilge Mentor',
      description: 'Deneyimli, karizmatik ve düzenli kıdemli erkek avatarı',
      baseIcon: Icons.psychology_rounded,
      gradientColors: [Color(0xFF6366F1), Color(0xFF312E81)],
      accentColor: Color(0xFFFFD700),
      accessoryIcon: Icons.military_tech_rounded,
    ),
    'avatar_female_senior': AvatarData(
      id: 'avatar_female_senior',
      label: 'Zarif Rehber',
      description: 'Bilge, yaşam dolu ve huzurlu kıdemli kadın avatarı',
      baseIcon: Icons.nature_people_rounded,
      gradientColors: [Color(0xFF8B5CF6), Color(0xFF4C1D95)],
      accentColor: Color(0xFFFCD34D),
      accessoryIcon: Icons.workspace_premium_rounded,
    ),
    'avatar_neutral_senior': AvatarData(
      id: 'avatar_neutral_senior',
      label: 'Hayat Ustası',
      description: 'Dengeyi yakalamış bilge kıdemli avatarı',
      baseIcon: Icons.all_inclusive_rounded,
      gradientColors: [Color(0xFF475569), Color(0xFF1E293B)],
      accentColor: Color(0xFF38BDF8),
      accessoryIcon: Icons.verified_rounded,
    ),
  };

  static AvatarData getAvatarData(String avatarId) {
    return avatars[avatarId] ?? avatars['avatar_neutral_adult']!;
  }
}

class UserAvatarWidget extends StatelessWidget {
  final String avatarId;
  final double radius;
  final bool showBadge;
  final VoidCallback? onTap;

  const UserAvatarWidget({
    super.key,
    required this.avatarId,
    this.radius = 28,
    this.showBadge = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final data = AvatarService.getAvatarData(avatarId);

    Widget avatarCore = Container(
      width: radius * 2,
      height: radius * 2,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: data.gradientColors,
        ),
        boxShadow: [
          BoxShadow(
            color: data.gradientColors.first.withValues(alpha: 0.35),
            blurRadius: radius * 0.4,
            offset: Offset(0, radius * 0.15),
          ),
        ],
        border: Border.all(color: Colors.white, width: radius > 30 ? 3 : 2),
      ),
      child: Center(
        child: Icon(
          data.baseIcon,
          size: radius * 1.05,
          color: Colors.white,
        ),
      ),
    );

    if (showBadge && data.accessoryIcon != null) {
      avatarCore = Stack(
        clipBehavior: Clip.none,
        children: [
          avatarCore,
          Positioned(
            right: 0,
            bottom: 0,
            child: Container(
              padding: EdgeInsets.all(radius * 0.12),
              decoration: BoxDecoration(
                color: data.accentColor,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.15),
                    blurRadius: 4,
                  ),
                ],
              ),
              child: Icon(
                data.accessoryIcon,
                size: radius * 0.45,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      );
    }

    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(radius),
        child: avatarCore,
      );
    }

    return avatarCore;
  }
}
