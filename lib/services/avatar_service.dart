import 'dart:math' as math;
import 'package:flutter/material.dart';

enum PersonaCategory {
  maleTeen,
  femaleTeen,
  neutralTeen,
  maleAdult,
  femaleAdult,
  neutralAdult,
  maleSenior,
  femaleSenior,
  neutralSenior,
}

class AvatarData {
  final String id;
  final String label;
  final String description;
  final PersonaCategory category;
  final IconData baseIcon;
  final List<Color> gradientColors;
  final Color accentColor;
  final IconData? accessoryIcon;
  final Color skinTone;
  final Color skinShadow;
  final Color hairColor;
  final Color hairHighlight;
  final List<Color> clothingColors;

  const AvatarData({
    required this.id,
    required this.label,
    required this.description,
    required this.category,
    required this.baseIcon,
    required this.gradientColors,
    required this.accentColor,
    this.accessoryIcon,
    required this.skinTone,
    required this.skinShadow,
    required this.hairColor,
    required this.hairHighlight,
    required this.clothingColors,
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
      description: 'Enerjik, spor tutkunu genç erkek avatarı (Koşu Bandı & Sporcu)',
      category: PersonaCategory.maleTeen,
      baseIcon: Icons.directions_run_rounded,
      gradientColors: [Color(0xFF0284C7), Color(0xFF0C4A6E)],
      accentColor: Color(0xFFFACC15),
      accessoryIcon: Icons.bolt_rounded,
      skinTone: Color(0xFFFFDBAC),
      skinShadow: Color(0xFFE0AC69),
      hairColor: Color(0xFF3E2723),
      hairHighlight: Color(0xFF5D4037),
      clothingColors: [Color(0xFF0284C7), Color(0xFF0369A1)],
    ),
    'avatar_female_teen': AvatarData(
      id: 'avatar_female_teen',
      label: 'Genç Kaşif',
      description: 'Dinamik, meraklı ve enerjik genç kadın avatarı (At kuyruğu & Kulaklık)',
      category: PersonaCategory.femaleTeen,
      baseIcon: Icons.explore_rounded,
      gradientColors: [Color(0xFFDB2777), Color(0xFF831843)],
      accentColor: Color(0xFF38BDF8),
      accessoryIcon: Icons.star_rounded,
      skinTone: Color(0xFFFCD7B0),
      skinShadow: Color(0xFFE3AA72),
      hairColor: Color(0xFF5C2C16),
      hairHighlight: Color(0xFF8D4F2A),
      clothingColors: [Color(0xFFDB2777), Color(0xFFBE185D)],
    ),
    'avatar_neutral_teen': AvatarData(
      id: 'avatar_neutral_teen',
      label: 'Genç Öğrenci',
      description: 'Öğrenmeye ve gelişime açık genç avatarı (Gözlüklü & Kapüşonlu)',
      category: PersonaCategory.neutralTeen,
      baseIcon: Icons.school_rounded,
      gradientColors: [Color(0xFF7C3AED), Color(0xFF312E81)],
      accentColor: Color(0xFF34D399),
      accessoryIcon: Icons.auto_awesome_rounded,
      skinTone: Color(0xFFFBE0C3),
      skinShadow: Color(0xFFE5B88F),
      hairColor: Color(0xFF2B201A),
      hairHighlight: Color(0xFF4E382C),
      clothingColors: [Color(0xFF7C3AED), Color(0xFF6D28D9)],
    ),
    'avatar_male_adult': AvatarData(
      id: 'avatar_male_adult',
      label: 'Modern Profesyonel',
      description: 'Dinamik, hedef odaklı yetişkin erkek avatarı (Fitness & Akıllı Saat)',
      category: PersonaCategory.maleAdult,
      baseIcon: Icons.fitness_center_rounded,
      gradientColors: [Color(0xFF2563EB), Color(0xFF0F172A)],
      accentColor: Color(0xFF60A5FA),
      accessoryIcon: Icons.watch_rounded,
      skinTone: Color(0xFFECC29C),
      skinShadow: Color(0xFFC9956B),
      hairColor: Color(0xFF1C1917),
      hairHighlight: Color(0xFF44403C),
      clothingColors: [Color(0xFF1E3A8A), Color(0xFF172554)],
    ),
    'avatar_female_adult': AvatarData(
      id: 'avatar_female_adult',
      label: 'İlham Veren Lider',
      description: 'Kararlı, dengeli ve üretken yetişkin kadın avatarı (Yoga & Wellness)',
      category: PersonaCategory.femaleAdult,
      baseIcon: Icons.self_improvement_rounded,
      gradientColors: [Color(0xFF9D174D), Color(0xFF4C0519)],
      accentColor: Color(0xFFF43F5E),
      accessoryIcon: Icons.favorite_rounded,
      skinTone: Color(0xFFFFE0BD),
      skinShadow: Color(0xFFE5B588),
      hairColor: Color(0xFF451A03),
      hairHighlight: Color(0xFF78350F),
      clothingColors: [Color(0xFF9D174D), Color(0xFFBE185D)],
    ),
    'avatar_neutral_adult': AvatarData(
      id: 'avatar_neutral_adult',
      label: 'Dengeli Yaşam Mimarı',
      description: 'Modern, odaklanmış yetişkin avatarı (Doğa & Sağlıklı Yaşam)',
      category: PersonaCategory.neutralAdult,
      baseIcon: Icons.spa_rounded,
      gradientColors: [Color(0xFF0F766E), Color(0xFF042F2E)],
      accentColor: Color(0xFF5EEAD4),
      accessoryIcon: Icons.eco_rounded,
      skinTone: Color(0xFFF5D6B8),
      skinShadow: Color(0xFFD6A97E),
      hairColor: Color(0xFF262626),
      hairHighlight: Color(0xFF525252),
      clothingColors: [Color(0xFF0F766E), Color(0xFF115E59)],
    ),
    'avatar_male_senior': AvatarData(
      id: 'avatar_male_senior',
      label: 'Bilge Mentor',
      description: 'Deneyimli, karizmatik ve düzenli kıdemli erkek avatarı (Gümüş Sakal & Gözlük)',
      category: PersonaCategory.maleSenior,
      baseIcon: Icons.psychology_rounded,
      gradientColors: [Color(0xFF4338CA), Color(0xFF1E1B4B)],
      accentColor: Color(0xFFFFD700),
      accessoryIcon: Icons.military_tech_rounded,
      skinTone: Color(0xFFF2CBB0),
      skinShadow: Color(0xFFD3A382),
      hairColor: Color(0xFFCBD5E1),
      hairHighlight: Color(0xFFF8FAFC),
      clothingColors: [Color(0xFF312E81), Color(0xFF1E1B4B)],
    ),
    'avatar_female_senior': AvatarData(
      id: 'avatar_female_senior',
      label: 'Zarif Rehber',
      description: 'Bilge, yaşam dolu ve huzurlu kıdemli kadın avatarı (Gümüş Bukleler & Fular)',
      category: PersonaCategory.femaleSenior,
      baseIcon: Icons.nature_people_rounded,
      gradientColors: [Color(0xFF6B21A8), Color(0xFF3B0764)],
      accentColor: Color(0xFFFCD34D),
      accessoryIcon: Icons.workspace_premium_rounded,
      skinTone: Color(0xFFF7D9BF),
      skinShadow: Color(0xFFDCB28E),
      hairColor: Color(0xFFE2E8F0),
      hairHighlight: Color(0xFFFFFFFF),
      clothingColors: [Color(0xFF581C87), Color(0xFF3B0764)],
    ),
    'avatar_neutral_senior': AvatarData(
      id: 'avatar_neutral_senior',
      label: 'Hayat Ustası',
      description: 'Dengeyi yakalamış bilge kıdemli avatarı (Zen Denge & Huzur)',
      category: PersonaCategory.neutralSenior,
      baseIcon: Icons.all_inclusive_rounded,
      gradientColors: [Color(0xFF334155), Color(0xFF0F172A)],
      accentColor: Color(0xFF38BDF8),
      accessoryIcon: Icons.verified_rounded,
      skinTone: Color(0xFFEED0B5),
      skinShadow: Color(0xFFCE9E79),
      hairColor: Color(0xFF94A3B8),
      hairHighlight: Color(0xFFE2E8F0),
      clothingColors: [Color(0xFF334155), Color(0xFF1E293B)],
    ),
  };

  static AvatarData getAvatarData(String avatarId) {
    return avatars[avatarId] ?? avatars['avatar_neutral_adult']!;
  }
}

/// A high-fidelity realistic illustrated character painter for wellness personas
class RealisticAvatarPainter extends CustomPainter {
  final AvatarData data;

  RealisticAvatarPainter({required this.data});

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final cx = w / 2;
    final cy = h / 2;

    // Outer circular boundary clip
    final clipPath = Path()..addOval(Rect.fromLTWH(0, 0, w, h));
    canvas.clipPath(clipPath);

    // 1. Studio Background Gradient
    final bgPaint = Paint()
      ..shader = RadialGradient(
        center: const Alignment(0.0, -0.3),
        radius: 0.95,
        colors: [
          data.gradientColors.first.withValues(alpha: 0.95),
          data.gradientColors.last,
        ],
      ).createShader(Rect.fromLTWH(0, 0, w, h));
    canvas.drawRect(Rect.fromLTWH(0, 0, w, h), bgPaint);

    // Subtle ambient background ring/glow
    final glowPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.12)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(cx, cy * 0.75), w * 0.42, glowPaint);

    // 2. Torso / Shoulders / Clothing
    final shoulderPath = Path()
      ..moveTo(0, h)
      ..lineTo(0, h * 0.82)
      ..cubicTo(w * 0.12, h * 0.72, w * 0.28, h * 0.65, w * 0.38, h * 0.66)
      ..lineTo(cx, h * 0.73)
      ..lineTo(w * 0.62, h * 0.66)
      ..cubicTo(w * 0.72, h * 0.65, w * 0.88, h * 0.72, w, h * 0.82)
      ..lineTo(w, h)
      ..close();

    final clothPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: data.clothingColors,
      ).createShader(Rect.fromLTWH(0, h * 0.6, w, h * 0.4));
    canvas.drawPath(shoulderPath, clothPaint);

    // Persona-specific clothing details (collar, stripes, zippers)
    _paintClothingDetails(canvas, w, h, cx, cy);

    // 3. Neck & Shadow
    final neckPath = Path()
      ..moveTo(w * 0.40, h * 0.52)
      ..lineTo(w * 0.40, h * 0.70)
      ..cubicTo(w * 0.45, h * 0.74, w * 0.55, h * 0.74, w * 0.60, h * 0.70)
      ..lineTo(w * 0.60, h * 0.52)
      ..close();

    final neckPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [data.skinShadow, data.skinTone],
      ).createShader(Rect.fromLTWH(w * 0.40, h * 0.50, w * 0.20, h * 0.24));
    canvas.drawPath(neckPath, neckPaint);

    // 4. Head & Face
    final faceRect = Rect.fromCenter(
      center: Offset(cx, cy * 0.88),
      width: w * 0.45,
      height: h * 0.52,
    );

    // Head base shape
    final facePath = Path()
      ..addOval(faceRect);

    final facePaint = Paint()
      ..shader = RadialGradient(
        center: const Alignment(0.0, -0.1),
        radius: 0.8,
        colors: [
          data.skinTone,
          data.skinShadow.withValues(alpha: 0.95),
        ],
      ).createShader(faceRect);
    canvas.drawPath(facePath, facePaint);

    // Rosy cheek glow for warmth
    final cheekPaint = Paint()
      ..color = const Color(0xFFFF5252).withValues(alpha: 0.12)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);
    canvas.drawOval(
      Rect.fromCenter(center: Offset(cx - w * 0.13, cy * 0.96), width: w * 0.10, height: h * 0.06),
      cheekPaint,
    );
    canvas.drawOval(
      Rect.fromCenter(center: Offset(cx + w * 0.13, cy * 0.96), width: w * 0.10, height: h * 0.06),
      cheekPaint,
    );

    // Ears
    final leftEar = Path()
      ..addOval(Rect.fromCenter(center: Offset(cx - w * 0.23, cy * 0.88), width: w * 0.07, height: h * 0.12));
    final rightEar = Path()
      ..addOval(Rect.fromCenter(center: Offset(cx + w * 0.23, cy * 0.88), width: w * 0.07, height: h * 0.12));
    final earPaint = Paint()..color = data.skinShadow;
    canvas.drawPath(leftEar, earPaint);
    canvas.drawPath(rightEar, earPaint);

    // 5. Facial Details: Eyes, Eyebrows, Nose, Smile
    _paintFacialFeatures(canvas, w, h, cx, cy);

    // 6. Hair & Specific Accessories (Headband, glasses, beard, etc.)
    _paintHairAndGear(canvas, w, h, cx, cy);

    // 7. Subtle Rim Lighting Overlay
    final rimPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.18)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;
    canvas.drawCircle(Offset(cx, cy), (w / 2) - 1, rimPaint);
  }

  void _paintClothingDetails(Canvas canvas, double w, double h, double cx, double cy) {
    final detailPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.28)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.8;

    switch (data.category) {
      case PersonaCategory.maleTeen:
        // Athletic jersey stripe & collar
        final stripePath = Path()
          ..moveTo(cx - w * 0.06, h * 0.72)
          ..lineTo(cx - w * 0.06, h)
          ..moveTo(cx + w * 0.06, h * 0.72)
          ..lineTo(cx + w * 0.06, h);
        canvas.drawPath(stripePath, detailPaint..strokeWidth = 2.5);
        break;

      case PersonaCategory.femaleTeen:
        // Sporty zip jacket collar
        final zipPath = Path()
          ..moveTo(cx, h * 0.72)
          ..lineTo(cx, h);
        canvas.drawPath(zipPath, detailPaint..color = const Color(0xFFFBCFE8)..strokeWidth = 2.0);
        break;

      case PersonaCategory.neutralTeen:
        // Hoodie collar and drawstrings
        final hoodiePath = Path()
          ..moveTo(cx - w * 0.08, h * 0.73)
          ..quadraticBezierTo(cx - w * 0.10, h * 0.83, cx - w * 0.07, h * 0.90)
          ..moveTo(cx + w * 0.08, h * 0.73)
          ..quadraticBezierTo(cx + w * 0.10, h * 0.83, cx + w * 0.07, h * 0.90);
        canvas.drawPath(hoodiePath, detailPaint..color = Colors.white70..strokeWidth = 1.8);
        break;

      case PersonaCategory.maleAdult:
        // Polo button placket
        final poloPath = Path()
          ..moveTo(cx, h * 0.72)
          ..lineTo(cx, h * 0.88);
        canvas.drawPath(poloPath, detailPaint..color = Colors.white54..strokeWidth = 2.0);
        canvas.drawCircle(Offset(cx, h * 0.77), 1.6, Paint()..color = Colors.white70);
        canvas.drawCircle(Offset(cx, h * 0.83), 1.6, Paint()..color = Colors.white70);
        break;

      case PersonaCategory.femaleAdult:
        // Yoga cross strap collar
        final yogaPath = Path()
          ..moveTo(cx - w * 0.15, h * 0.70)
          ..lineTo(cx + w * 0.05, h * 0.78)
          ..moveTo(cx + w * 0.15, h * 0.70)
          ..lineTo(cx - w * 0.05, h * 0.78);
        canvas.drawPath(yogaPath, detailPaint..color = Colors.white38);
        break;

      case PersonaCategory.neutralAdult:
        // Sleek mockneck seam
        final mockPath = Path()
          ..moveTo(cx - w * 0.12, h * 0.69)
          ..quadraticBezierTo(cx, h * 0.74, cx + w * 0.12, h * 0.69);
        canvas.drawPath(mockPath, detailPaint..color = const Color(0xFF5EEAD4).withValues(alpha: 0.5));
        break;

      case PersonaCategory.maleSenior:
        // Classic sweater with white shirt collar peeking
        final collarWhite = Paint()..color = Colors.white.withValues(alpha: 0.9);
        final collarL = Path()
          ..moveTo(cx - w * 0.08, h * 0.67)
          ..lineTo(cx - w * 0.02, h * 0.74)
          ..lineTo(cx - w * 0.14, h * 0.72)
          ..close();
        final collarR = Path()
          ..moveTo(cx + w * 0.08, h * 0.67)
          ..lineTo(cx + w * 0.02, h * 0.74)
          ..lineTo(cx + w * 0.14, h * 0.72)
          ..close();
        canvas.drawPath(collarL, collarWhite);
        canvas.drawPath(collarR, collarWhite);
        break;

      case PersonaCategory.femaleSenior:
        // Elegant draped wellness scarf
        final scarfPaint = Paint()
          ..color = const Color(0xFFE9D5FF).withValues(alpha: 0.85);
        final scarfPath = Path()
          ..moveTo(cx - w * 0.16, h * 0.68)
          ..quadraticBezierTo(cx, h * 0.78, cx + w * 0.16, h * 0.68)
          ..quadraticBezierTo(cx, h * 0.84, cx - w * 0.16, h * 0.68);
        canvas.drawPath(scarfPath, scarfPaint);
        break;

      case PersonaCategory.neutralSenior:
        // Zen tunic neckline
        final zenPath = Path()
          ..moveTo(cx - w * 0.14, h * 0.68)
          ..lineTo(cx, h * 0.76)
          ..lineTo(cx + w * 0.14, h * 0.68);
        canvas.drawPath(zenPath, detailPaint..color = const Color(0xFF94A3B8));
        break;
    }
  }

  void _paintFacialFeatures(Canvas canvas, double w, double h, double cx, double cy) {
    final browPaint = Paint()
      ..color = data.hairColor
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 2.2;

    // Eyebrows
    final leftBrow = Path()
      ..moveTo(cx - w * 0.15, cy * 0.78)
      ..quadraticBezierTo(cx - w * 0.09, cy * 0.75, cx - w * 0.03, cy * 0.78);
    final rightBrow = Path()
      ..moveTo(cx + w * 0.03, cy * 0.78)
      ..quadraticBezierTo(cx + w * 0.09, cy * 0.75, cx + w * 0.15, cy * 0.78);
    canvas.drawPath(leftBrow, browPaint);
    canvas.drawPath(rightBrow, browPaint);

    // Eyes: Sclera (Whites)
    final eyeWhitePaint = Paint()..color = Colors.white;
    final leftEyeRect = Rect.fromCenter(center: Offset(cx - w * 0.09, cy * 0.85), width: w * 0.075, height: h * 0.05);
    final rightEyeRect = Rect.fromCenter(center: Offset(cx + w * 0.09, cy * 0.85), width: w * 0.075, height: h * 0.05);
    canvas.drawOval(leftEyeRect, eyeWhitePaint);
    canvas.drawOval(rightEyeRect, eyeWhitePaint);

    // Iris & Pupil
    Color irisColor = const Color(0xFF3B2F2F);
    if (data.category == PersonaCategory.femaleTeen || data.category == PersonaCategory.maleTeen) {
      irisColor = const Color(0xFF1E3A8A);
    } else if (data.category == PersonaCategory.neutralAdult || data.category == PersonaCategory.femaleSenior) {
      irisColor = const Color(0xFF0F766E);
    }

    final irisPaint = Paint()..color = irisColor;
    canvas.drawCircle(Offset(cx - w * 0.09, cy * 0.85), w * 0.022, irisPaint);
    canvas.drawCircle(Offset(cx + w * 0.09, cy * 0.85), w * 0.022, irisPaint);

    final pupilPaint = Paint()..color = Colors.black;
    canvas.drawCircle(Offset(cx - w * 0.09, cy * 0.85), w * 0.012, pupilPaint);
    canvas.drawCircle(Offset(cx + w * 0.09, cy * 0.85), w * 0.012, pupilPaint);

    // Catchlight / Life sparkle reflections
    final sparklePaint = Paint()..color = Colors.white;
    canvas.drawCircle(Offset(cx - w * 0.096, cy * 0.842), 1.4, sparklePaint);
    canvas.drawCircle(Offset(cx + w * 0.084, cy * 0.842), 1.4, sparklePaint);

    // Eyelid line
    final lidPaint = Paint()
      ..color = data.skinShadow
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;
    canvas.drawArc(leftEyeRect, math.pi, math.pi, false, lidPaint);
    canvas.drawArc(rightEyeRect, math.pi, math.pi, false, lidPaint);

    // Nose
    final nosePaint = Paint()
      ..color = data.skinShadow
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 1.8;
    final nosePath = Path()
      ..moveTo(cx, cy * 0.84)
      ..lineTo(cx + w * 0.012, cy * 0.94)
      ..quadraticBezierTo(cx, cy * 0.96, cx - w * 0.018, cy * 0.945);
    canvas.drawPath(nosePath, nosePaint);

    // Warm Smile
    final smilePaint = Paint()
      ..color = const Color(0xFFC2410C).withValues(alpha: 0.8)
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 2.2;

    final smilePath = Path()
      ..moveTo(cx - w * 0.08, cy * 1.04)
      ..quadraticBezierTo(cx, cy * 1.10, cx + w * 0.08, cy * 1.04);
    canvas.drawPath(smilePath, smilePaint);

    // Senior subtle smile lines
    if (data.category == PersonaCategory.maleSenior ||
        data.category == PersonaCategory.femaleSenior ||
        data.category == PersonaCategory.neutralSenior) {
      final linePaint = Paint()
        ..color = data.skinShadow.withValues(alpha: 0.6)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.0;
      canvas.drawLine(Offset(cx - w * 0.12, cy * 0.85), Offset(cx - w * 0.15, cy * 0.83), linePaint);
      canvas.drawLine(Offset(cx + w * 0.12, cy * 0.85), Offset(cx + w * 0.15, cy * 0.83), linePaint);
      canvas.drawLine(Offset(cx - w * 0.10, cy * 1.02), Offset(cx - w * 0.12, cy * 1.07), linePaint);
      canvas.drawLine(Offset(cx + w * 0.10, cy * 1.02), Offset(cx + w * 0.12, cy * 1.07), linePaint);
    }
  }

  void _paintHairAndGear(Canvas canvas, double w, double h, double cx, double cy) {
    final hairPaint = Paint()..color = data.hairColor;
    final highlightPaint = Paint()
      ..color = data.hairHighlight
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    switch (data.category) {
      case PersonaCategory.maleTeen:
        // Textured Athletic Hair + Sports Headband
        final hairPath = Path()
          ..moveTo(cx - w * 0.22, cy * 0.82)
          ..quadraticBezierTo(cx - w * 0.25, cy * 0.55, cx, cy * 0.50)
          ..quadraticBezierTo(cx + w * 0.25, cy * 0.55, cx + w * 0.22, cy * 0.82)
          ..quadraticBezierTo(cx + w * 0.12, cy * 0.70, cx, cy * 0.72)
          ..quadraticBezierTo(cx - w * 0.12, cy * 0.70, cx - w * 0.22, cy * 0.82);
        canvas.drawPath(hairPath, hairPaint);

        // Athletic runner sweatband across forehead
        final bandPaint = Paint()
          ..shader = const LinearGradient(
            colors: [Color(0xFFF97316), Color(0xFFFACC15)],
          ).createShader(Rect.fromLTWH(cx - w * 0.23, cy * 0.69, w * 0.46, h * 0.08));
        final bandPath = Path()
          ..moveTo(cx - w * 0.22, cy * 0.74)
          ..quadraticBezierTo(cx, cy * 0.71, cx + w * 0.22, cy * 0.74)
          ..lineTo(cx + w * 0.22, cy * 0.79)
          ..quadraticBezierTo(cx, cy * 0.76, cx - w * 0.22, cy * 0.79)
          ..close();
        canvas.drawPath(bandPath, bandPaint);
        break;

      case PersonaCategory.femaleTeen:
        // High active ponytail + bangs
        // Ponytail on top right
        final ponyPath = Path()
          ..moveTo(cx + w * 0.12, cy * 0.52)
          ..cubicTo(cx + w * 0.35, cy * 0.38, cx + w * 0.38, cy * 0.70, cx + w * 0.28, cy * 0.80)
          ..cubicTo(cx + w * 0.25, cy * 0.65, cx + w * 0.20, cy * 0.58, cx + w * 0.12, cy * 0.52);
        canvas.drawPath(ponyPath, hairPaint);

        // Hair tie
        canvas.drawCircle(Offset(cx + w * 0.14, cy * 0.52), 3.5, Paint()..color = const Color(0xFFF43F5E));

        // Front layered bob / bangs
        final frontHair = Path()
          ..moveTo(cx - w * 0.23, cy * 0.85)
          ..quadraticBezierTo(cx - w * 0.24, cy * 0.56, cx, cy * 0.52)
          ..quadraticBezierTo(cx + w * 0.24, cy * 0.56, cx + w * 0.23, cy * 0.85)
          ..quadraticBezierTo(cx + w * 0.15, cy * 0.68, cx, cy * 0.72)
          ..quadraticBezierTo(cx - w * 0.15, cy * 0.68, cx - w * 0.23, cy * 0.85);
        canvas.drawPath(frontHair, hairPaint);

        // Wireless runner earbud in left ear
        final earbudPaint = Paint()..color = Colors.white;
        canvas.drawCircle(Offset(cx - w * 0.22, cy * 0.88), 2.5, earbudPaint);
        break;

      case PersonaCategory.neutralTeen:
        // Wavy student crop + Stylish Round Modern Glasses
        final hairPath = Path()
          ..moveTo(cx - w * 0.23, cy * 0.85)
          ..cubicTo(cx - w * 0.24, cy * 0.52, cx + w * 0.24, cy * 0.52, cx + w * 0.23, cy * 0.85)
          ..quadraticBezierTo(cx + w * 0.10, cy * 0.70, cx, cy * 0.74)
          ..quadraticBezierTo(cx - w * 0.10, cy * 0.70, cx - w * 0.23, cy * 0.85);
        canvas.drawPath(hairPath, hairPaint);

        // Round smart glasses
        final glassPaint = Paint()
          ..color = const Color(0xFF38BDF8)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.0;
        final leftGlass = Rect.fromCenter(center: Offset(cx - w * 0.09, cy * 0.85), width: w * 0.13, height: h * 0.10);
        final rightGlass = Rect.fromCenter(center: Offset(cx + w * 0.09, cy * 0.85), width: w * 0.13, height: h * 0.10);
        canvas.drawOval(leftGlass, glassPaint);
        canvas.drawOval(rightGlass, glassPaint);
        canvas.drawLine(Offset(cx - w * 0.025, cy * 0.85), Offset(cx + w * 0.025, cy * 0.85), glassPaint);
        // Subtle blue anti-reflective reflection glare
        final glarePaint = Paint()..color = Colors.white.withValues(alpha: 0.35);
        canvas.drawLine(Offset(cx - w * 0.12, cy * 0.82), Offset(cx - w * 0.06, cy * 0.88), glarePaint);
        canvas.drawLine(Offset(cx + w * 0.06, cy * 0.82), Offset(cx + w * 0.12, cy * 0.88), glarePaint);
        break;

      case PersonaCategory.maleAdult:
        // Sharp Modern Fade + Athletic Grooming
        final hairPath = Path()
          ..moveTo(cx - w * 0.22, cy * 0.82)
          ..quadraticBezierTo(cx - w * 0.22, cy * 0.54, cx - w * 0.04, cy * 0.52)
          ..quadraticBezierTo(cx + w * 0.18, cy * 0.50, cx + w * 0.22, cy * 0.80)
          ..lineTo(cx + w * 0.20, cy * 0.80)
          ..quadraticBezierTo(cx + w * 0.08, cy * 0.68, cx - w * 0.16, cy * 0.70)
          ..close();
        canvas.drawPath(hairPath, hairPaint);

        // Neat modern stubble / jawline definition
        final stubblePaint = Paint()
          ..color = data.hairColor.withValues(alpha: 0.28)
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round
          ..strokeWidth = 3.0;
        final jawPath = Path()
          ..moveTo(cx - w * 0.18, cy * 0.95)
          ..quadraticBezierTo(cx, cy * 1.15, cx + w * 0.18, cy * 0.95);
        canvas.drawPath(jawPath, stubblePaint);
        break;

      case PersonaCategory.femaleAdult:
        // Elegant flowing wavy hair
        final hairPath = Path()
          ..moveTo(cx - w * 0.24, cy * 0.96)
          ..cubicTo(cx - w * 0.26, cy * 0.50, cx + w * 0.26, cy * 0.50, cx + w * 0.24, cy * 0.96)
          ..quadraticBezierTo(cx + w * 0.20, cy * 0.68, cx, cy * 0.70)
          ..quadraticBezierTo(cx - w * 0.20, cy * 0.68, cx - w * 0.24, cy * 0.96);
        canvas.drawPath(hairPath, hairPaint);
        canvas.drawPath(
          Path()
            ..moveTo(cx - w * 0.18, cy * 0.58)
            ..quadraticBezierTo(cx, cy * 0.56, cx + w * 0.18, cy * 0.62),
          highlightPaint,
        );
        break;

      case PersonaCategory.neutralAdult:
        // Minimalist modern crop
        final hairPath = Path()
          ..moveTo(cx - w * 0.23, cy * 0.85)
          ..quadraticBezierTo(cx - w * 0.22, cy * 0.54, cx, cy * 0.54)
          ..quadraticBezierTo(cx + w * 0.22, cy * 0.54, cx + w * 0.23, cy * 0.85)
          ..quadraticBezierTo(cx + w * 0.10, cy * 0.70, cx, cy * 0.72)
          ..quadraticBezierTo(cx - w * 0.10, cy * 0.70, cx - w * 0.23, cy * 0.85);
        canvas.drawPath(hairPath, hairPaint);
        break;

      case PersonaCategory.maleSenior:
        // Silver-Grey Hair & Neatly Trimmed Silver Beard + Wireframe Glasses
        final hairPath = Path()
          ..moveTo(cx - w * 0.24, cy * 0.84)
          ..quadraticBezierTo(cx - w * 0.25, cy * 0.52, cx, cy * 0.52)
          ..quadraticBezierTo(cx + w * 0.25, cy * 0.52, cx + w * 0.24, cy * 0.84)
          ..quadraticBezierTo(cx + w * 0.12, cy * 0.68, cx, cy * 0.71)
          ..quadraticBezierTo(cx - w * 0.12, cy * 0.68, cx - w * 0.24, cy * 0.84);
        canvas.drawPath(hairPath, hairPaint);

        // Neat silver beard
        final beardPath = Path()
          ..moveTo(cx - w * 0.14, cy * 0.98)
          ..quadraticBezierTo(cx - w * 0.12, cy * 1.15, cx, cy * 1.16)
          ..quadraticBezierTo(cx + w * 0.12, cy * 1.15, cx + w * 0.14, cy * 0.98)
          ..quadraticBezierTo(cx, cy * 1.08, cx - w * 0.14, cy * 0.98);
        canvas.drawPath(beardPath, hairPaint);

        // Wireframe spectacles
        final wirePaint = Paint()
          ..color = const Color(0xFFFFD700)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.6;
        final leftWire = Rect.fromCenter(center: Offset(cx - w * 0.09, cy * 0.85), width: w * 0.11, height: h * 0.08);
        final rightWire = Rect.fromCenter(center: Offset(cx + w * 0.09, cy * 0.85), width: w * 0.11, height: h * 0.08);
        canvas.drawRRect(RRect.fromRectAndRadius(leftWire, const Radius.circular(4)), wirePaint);
        canvas.drawRRect(RRect.fromRectAndRadius(rightWire, const Radius.circular(4)), wirePaint);
        canvas.drawLine(Offset(cx - w * 0.035, cy * 0.85), Offset(cx + w * 0.035, cy * 0.85), wirePaint);
        break;

      case PersonaCategory.femaleSenior:
        // Elegant voluminous layered silver bob
        final hairPath = Path()
          ..moveTo(cx - w * 0.25, cy * 0.90)
          ..cubicTo(cx - w * 0.28, cy * 0.50, cx + w * 0.28, cy * 0.50, cx + w * 0.25, cy * 0.90)
          ..quadraticBezierTo(cx + w * 0.16, cy * 0.68, cx, cy * 0.70)
          ..quadraticBezierTo(cx - w * 0.16, cy * 0.68, cx - w * 0.25, cy * 0.90);
        canvas.drawPath(hairPath, hairPaint);
        canvas.drawPath(
          Path()
            ..moveTo(cx - w * 0.14, cy * 0.56)
            ..quadraticBezierTo(cx, cy * 0.54, cx + w * 0.14, cy * 0.58),
          highlightPaint,
        );
        break;

      case PersonaCategory.neutralSenior:
        // Dignified silver cropped hair
        final hairPath = Path()
          ..moveTo(cx - w * 0.23, cy * 0.84)
          ..quadraticBezierTo(cx - w * 0.23, cy * 0.54, cx, cy * 0.54)
          ..quadraticBezierTo(cx + w * 0.23, cy * 0.54, cx + w * 0.23, cy * 0.84)
          ..quadraticBezierTo(cx + w * 0.10, cy * 0.70, cx, cy * 0.72)
          ..quadraticBezierTo(cx - w * 0.10, cy * 0.70, cx - w * 0.23, cy * 0.84);
        canvas.drawPath(hairPath, hairPaint);
        break;
    }
  }

  @override
  bool shouldRepaint(covariant RealisticAvatarPainter oldDelegate) {
    return oldDelegate.data.id != data.id;
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
        boxShadow: [
          BoxShadow(
            color: data.gradientColors.first.withValues(alpha: 0.35),
            blurRadius: radius * 0.45,
            offset: Offset(0, radius * 0.18),
          ),
        ],
        border: Border.all(
          color: Colors.white,
          width: radius > 30 ? 3.0 : 2.0,
        ),
      ),
      child: ClipOval(
        child: CustomPaint(
          size: Size(radius * 2, radius * 2),
          painter: RealisticAvatarPainter(data: data),
        ),
      ),
    );

    if (showBadge && data.accessoryIcon != null) {
      avatarCore = Stack(
        clipBehavior: Clip.none,
        children: [
          avatarCore,
          Positioned(
            right: -2,
            bottom: -2,
            child: Container(
              padding: EdgeInsets.all(radius * 0.14),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [data.accentColor, data.gradientColors.first],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.22),
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(
                data.accessoryIcon,
                size: radius * 0.44,
                color: Colors.white,
              ),
            ),
          ),
        ],
      );
    }

    if (onTap != null) {
      return Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(radius),
          child: avatarCore,
        ),
      );
    }

    return avatarCore;
  }
}
