import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/app_state.dart';
import '../services/avatar_service.dart';
import '../theme/app_theme.dart';
import '../widgets/badges_modal.dart';

class ProfileScreen extends StatefulWidget {
  final AppState state;
  final VoidCallback onLogout;

  const ProfileScreen({
    super.key,
    required this.state,
    required this.onLogout,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _notificationsEnabled = true;

  void _openBadgesModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => BadgesModal(badges: widget.state.badges),
    );
  }

  void _showEditProfileDialog(UserModel user) {
    final nameCtrl = TextEditingController(text: user.fullName);
    int ageVal = user.age;
    String genderVal = user.gender;
    final smokePackCtrl = TextEditingController(text: user.smokingPackPrice.toStringAsFixed(0));
    final smokeBaseCtrl = TextEditingController(text: user.smokingBaselineDaily.toString());
    final alcoholPriceCtrl = TextEditingController(text: user.alcoholBaselinePrice.toStringAsFixed(0));

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) {
          final previewAvatarId = AvatarService.getAvatarId(ageVal, genderVal);

          return AlertDialog(
            title: const Text('Profili ve Ayarları Düzenle', style: TextStyle(fontWeight: FontWeight.bold)),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Live Avatar Preview based on age & gender (avatarskill.md)
                  Center(
                    child: Column(
                      children: [
                        UserAvatarWidget(avatarId: previewAvatarId, radius: 36, showBadge: true),
                        const SizedBox(height: 6),
                        Text(
                          AvatarService.getAvatarData(previewAvatarId).label,
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppTheme.primary),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),

                  TextField(
                    controller: nameCtrl,
                    decoration: const InputDecoration(labelText: 'Ad Soyad'),
                  ),
                  const SizedBox(height: 12),

                  // Age Selector
                  Row(
                    children: [
                      const Text('Yaş:', style: TextStyle(fontWeight: FontWeight.w600)),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.remove_circle_outline_rounded),
                        onPressed: ageVal > 10 ? () => setDialogState(() => ageVal--) : null,
                      ),
                      Text('$ageVal', style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
                      IconButton(
                        icon: const Icon(Icons.add_circle_outline_rounded),
                        onPressed: ageVal < 99 ? () => setDialogState(() => ageVal++) : null,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Gender Dropdown
                  DropdownButtonFormField<String>(
                    initialValue: genderVal,
                    decoration: const InputDecoration(labelText: 'Cinsiyet'),
                    items: const [
                      DropdownMenuItem(value: 'male', child: Text('Erkek')),
                      DropdownMenuItem(value: 'female', child: Text('Kadın')),
                      DropdownMenuItem(value: 'unisex', child: Text('Belirtmek İstemiyorum')),
                    ],
                    onChanged: (val) {
                      if (val != null) {
                        setDialogState(() => genderVal = val);
                      }
                    },
                  ),
                  const SizedBox(height: 12),

                  // Baseline Prices
                  TextField(
                    controller: smokePackCtrl,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: const InputDecoration(
                      labelText: '1 Paket Sigara Fiyatı (TL)',
                      helperText: '1 Paket = 20 dal (Örn: 75 TL)',
                      suffixText: 'TL',
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: smokeBaseCtrl,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Normalde İçilen Günlük Dal Sayısı',
                      helperText: 'Örn: 20 veya 30 dal (Tasarruf bu sayıdan düşülür)',
                      suffixText: 'dal',
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: alcoholPriceCtrl,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: const InputDecoration(
                      labelText: '1 Birim Alkol Maliyeti (TL)',
                      suffixText: 'TL',
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(),
                child: const Text('İptal'),
              ),
              ElevatedButton(
                onPressed: () {
                  widget.state.updateProfile(
                    fullName: nameCtrl.text.trim().isNotEmpty ? nameCtrl.text.trim() : user.fullName,
                    age: ageVal,
                    gender: genderVal,
                    smokingBaselineDaily: int.tryParse(smokeBaseCtrl.text) ?? user.smokingBaselineDaily,
                    smokingPackPrice: double.tryParse(smokePackCtrl.text) ?? user.smokingPackPrice,
                    alcoholBaselinePrice: double.tryParse(alcoholPriceCtrl.text) ?? user.alcoholBaselinePrice,
                  );
                  Navigator.of(ctx).pop();
                },
                child: const Text('Kaydet'),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showSmokingSettingsDialog(UserModel user) {
    final smokePackCtrl = TextEditingController(text: user.smokingPackPrice.toStringAsFixed(0));
    final smokeBaseCtrl = TextEditingController(text: user.smokingBaselineDaily.toString());

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) {
          final dailyDal = int.tryParse(smokeBaseCtrl.text) ?? user.smokingBaselineDaily;
          final packPrice = double.tryParse(smokePackCtrl.text) ?? user.smokingPackPrice;
          final pricePerCig = packPrice / 20.0;
          final dailyBudget = dailyDal * pricePerCig;
          final packs = dailyDal / 20.0;
          final packStr = packs == packs.roundToDouble() ? packs.toInt().toString() : packs.toStringAsFixed(1);

          return AlertDialog(
            title: const Row(
              children: [
                Icon(Icons.smoke_free_rounded, color: AppTheme.quitSmoking),
                SizedBox(width: 8),
                Text('Sigara ve Tasarruf Ayarları', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
              ],
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Tasarrufunuz, normalde günde içtiğiniz dal sayısından o gün içilen dal sayısı çıkarılarak hesaplanır.',
                    style: TextStyle(fontSize: 12.5, color: AppTheme.textSecondary),
                  ),
                  const SizedBox(height: 14),

                  TextField(
                    controller: smokeBaseCtrl,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Normalde Günlük İçilen Dal Sayısı',
                      helperText: 'Örn: 20 veya 30 dal',
                      prefixIcon: Icon(Icons.smoking_rooms_rounded),
                      suffixText: 'dal',
                    ),
                    onChanged: (_) => setDialogState(() {}),
                  ),
                  const SizedBox(height: 12),

                  TextField(
                    controller: smokePackCtrl,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: const InputDecoration(
                      labelText: '1 Paket Sigara Fiyatı (TL)',
                      helperText: '1 Paket = 20 dal',
                      prefixIcon: Icon(Icons.receipt_long_rounded),
                      suffixText: 'TL',
                    ),
                    onChanged: (_) => setDialogState(() {}),
                  ),
                  const SizedBox(height: 14),

                  // Canlı Hesaplama Önizleme Kartı
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppTheme.quitSmoking.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppTheme.quitSmoking.withValues(alpha: 0.25)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Hesaplama Özeti:',
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppTheme.quitSmoking),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          '• 1 dal sigara maliyeti: ${pricePerCig.toStringAsFixed(2)} TL',
                          style: const TextStyle(fontSize: 12, color: AppTheme.textPrimary),
                        ),
                        Text(
                          '• Normal günlük tüketim: $dailyDal dal ($packStr paket • ${dailyBudget.toStringAsFixed(2)} TL)',
                          style: const TextStyle(fontSize: 12, color: AppTheme.textPrimary),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '• Hiç içmediğiniz bir gün: +${dailyBudget.toStringAsFixed(2)} TL KÂR elde edersiniz!',
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppTheme.success),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(),
                child: const Text('İptal'),
              ),
              ElevatedButton(
                onPressed: () {
                  widget.state.updateProfile(
                    smokingBaselineDaily: int.tryParse(smokeBaseCtrl.text) ?? user.smokingBaselineDaily,
                    smokingPackPrice: double.tryParse(smokePackCtrl.text) ?? user.smokingPackPrice,
                  );
                  Navigator.of(ctx).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Sigara ve tasarruf ayarları güncellendi!')),
                  );
                },
                child: const Text('Kaydet'),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showAvatarPicker(BuildContext context) {
    final user = widget.state.currentUser;
    if (user == null) return;

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (ctx) => Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 460, maxHeight: 580),
          child: Material(
            color: Colors.transparent,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.12),
                    blurRadius: 24,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: AppTheme.primary.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.face_retouching_natural_rounded, color: AppTheme.primary, size: 20),
                      ),
                      const SizedBox(width: 10),
                      const Expanded(
                        child: Text(
                          'Gerçekçi Avatarını Seç',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close_rounded, size: 20),
                        onPressed: () => Navigator.of(ctx).pop(),
                        visualDensity: VisualDensity.compact,
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Konu bütünlüğüyle tasarlanmış sağlıklı yaşam ve alışkanlık karakterleri:',
                      style: TextStyle(fontSize: 12, color: AppTheme.textSecondary),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Flexible(
                    child: GridView.builder(
                      shrinkWrap: true,
                      itemCount: AvatarService.avatars.length,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        childAspectRatio: 0.82,
                      ),
                      itemBuilder: (ctx, index) {
                        final avatar = AvatarService.avatars.values.elementAt(index);
                        final isSelected = user.avatarId == avatar.id;

                        return InkWell(
                          onTap: () {
                            widget.state.updateProfile(avatarId: avatar.id);
                            Navigator.of(ctx).pop();
                          },
                          borderRadius: BorderRadius.circular(16),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppTheme.primary.withValues(alpha: 0.08)
                                  : AppTheme.surfaceMuted,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: isSelected ? AppTheme.primary : AppTheme.outlineVariant,
                                width: isSelected ? 2 : 1,
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                UserAvatarWidget(
                                  avatarId: avatar.id,
                                  radius: 26,
                                  showBadge: true,
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  avatar.label,
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                                    color: isSelected ? AppTheme.primary : AppTheme.textPrimary,
                                  ),
                                  textAlign: TextAlign.center,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  avatar.description.split('(').first.trim(),
                                  style: TextStyle(
                                    fontSize: 9,
                                    color: isSelected ? AppTheme.primary : AppTheme.textMuted,
                                  ),
                                  textAlign: TextAlign.center,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
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
            ),
          ),
        ),
      ),
    );
  }

  void _confirmLogout() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Hesaptan Çıkış Yap', style: TextStyle(fontWeight: FontWeight.bold)),
        content: const Text('Oturumunuz kapatılacaktır. Devam etmek istiyor musunuz?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Vazgeç'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              widget.onLogout();
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.error),
            child: const Text('Çıkış Yap'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = widget.state.currentUser;
    final unlockedBadges = widget.state.badges.where((b) => b.isUnlocked).toList();

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('Profil ve Başarılar'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 32),
        child: Column(
          children: [
            // Üst Bölüm: Kimlik ve Avatar (profilskill.md & avatarskill.md)
            Container(
              margin: const EdgeInsets.fromLTRB(16, 8, 16, 12),
              padding: const EdgeInsets.all(20),
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
                  if (user != null) ...[
                    UserAvatarWidget(
                      avatarId: user.avatarId,
                      radius: 46,
                      showBadge: true,
                      onTap: () => _showAvatarPicker(context),
                    ),
                    const SizedBox(height: 6),
                    InkWell(
                      onTap: () => _showAvatarPicker(context),
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppTheme.primary.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppTheme.primary.withValues(alpha: 0.2)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.auto_awesome_rounded, size: 13, color: AppTheme.primary),
                            const SizedBox(width: 4),
                            Text(
                              '${AvatarService.getAvatarData(user.avatarId).label} • Değiştir',
                              style: const TextStyle(
                                fontSize: 11.5,
                                fontWeight: FontWeight.w600,
                                color: AppTheme.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      user.fullName,
                      style: const TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      user.email,
                      style: const TextStyle(fontSize: 13, color: AppTheme.textMuted),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildProfileTag(
                          icon: Icons.cake_rounded,
                          label: '${user.age} Yaş',
                          color: AppTheme.primary,
                        ),
                        const SizedBox(width: 8),
                        _buildProfileTag(
                          icon: Icons.person_rounded,
                          label: user.gender == 'male'
                              ? 'Erkek'
                              : (user.gender == 'female' ? 'Kadın' : 'Belirtilmedi'),
                          color: AppTheme.fitness,
                        ),
                        const SizedBox(width: 8),
                        _buildProfileTag(
                          icon: Icons.shield_rounded,
                          label: AvatarService.getAvatarData(user.avatarId).label,
                          color: AppTheme.mindGames,
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    OutlinedButton.icon(
                      onPressed: () => _showEditProfileDialog(user),
                      icon: const Icon(Icons.edit_rounded, size: 16),
                      label: const Text('Profili ve Ayarları Düzenle'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      ),
                    ),
                  ],
                ],
              ),
            ),

            // Orta Bölüm 1: Rozet Vitrini (profilderozetsergilemeskill.md)
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppTheme.outlineVariant),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.workspace_premium_rounded,
                              color: Color(0xFFD97706), size: 22),
                          const SizedBox(width: 8),
                          const Text(
                            'Kazanılan Rozetler',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: AppTheme.textPrimary,
                            ),
                          ),
                        ],
                      ),
                      TextButton(
                        onPressed: _openBadgesModal,
                        child: const Text('Tümünü Gör →', style: TextStyle(fontWeight: FontWeight.w700)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  if (unlockedBadges.isEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 10.0),
                      child: Text(
                        'Henüz rozet kazanılmadı. Alışkanlıklarınızı düzenli yaparak rozetleri açın!',
                        style: TextStyle(fontSize: 13, color: AppTheme.textMuted),
                      ),
                    )
                  else
                    SizedBox(
                      height: 94,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: unlockedBadges.length,
                        itemBuilder: (context, index) {
                          final badge = unlockedBadges[index];
                          return Container(
                            width: 82,
                            margin: const EdgeInsets.only(right: 10),
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: badge.tierColor.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(color: badge.tierColor, width: 1.5),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(badge.icon, size: 28, color: badge.tierColor),
                                const SizedBox(height: 6),
                                Text(
                                  badge.title,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                    color: AppTheme.textPrimary,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                ],
              ),
            ),

            // Orta Bölüm 2: Genel Başarı Özeti Kartları (profilskill.md)
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppTheme.outlineVariant),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Genel Başarı Özeti',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(
                        child: _buildStatItem(
                          title: 'Tasarruf Edilen',
                          value: '${widget.state.totalMoneySaved.toStringAsFixed(0)} TL',
                          icon: Icons.savings_rounded,
                          color: AppTheme.quitSmoking,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _buildStatItem(
                          title: 'Yakılan Kalori',
                          value: '${widget.state.totalCaloriesBurned.toStringAsFixed(0)} kcal',
                          icon: Icons.local_fire_department_rounded,
                          color: AppTheme.fitness,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: _buildStatItem(
                          title: 'En Uzun Seri',
                          value: '${widget.state.maxStreakRecord} Gün',
                          icon: Icons.bolt_rounded,
                          color: const Color(0xFFEA580C),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _buildStatItem(
                          title: 'Tamamlanan',
                          value: '${widget.state.totalCompletedActivities} Aktivite',
                          icon: Icons.check_circle_rounded,
                          color: AppTheme.primary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Alt Bölüm: Ayarlar ve Hesap İşlemleri (profilskill.md)
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              child: Material(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: const BorderSide(color: AppTheme.outlineVariant),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Uygulama Ayarları',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Sigara ve Tasarruf Ayarları Tile
                  if (user != null) ...[
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppTheme.quitSmoking.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.smoke_free_rounded, color: AppTheme.quitSmoking, size: 22),
                      ),
                      title: const Text('Sigara ve Tasarruf Fiyat Ayarları', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
                      subtitle: Text(
                        'Normalde günde ${user.smokingBaselineDaily} dal (${(user.smokingBaselineDaily / 20.0).toStringAsFixed(1)} paket) • Paket: ${user.smokingPackPrice.toStringAsFixed(0)} TL',
                        style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary),
                      ),
                      trailing: ElevatedButton(
                        onPressed: () => _showSmokingSettingsDialog(user),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.quitSmoking,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                          textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
                        ),
                        child: const Text('Belirle'),
                      ),
                    ),
                    const Divider(height: 1, color: AppTheme.outlineVariant),
                    const SizedBox(height: 6),
                  ],

                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Günlük Hatırlatıcı Bildirimler', style: TextStyle(fontSize: 14)),
                    subtitle: const Text('Her akşam zinciri tamamlamanızı hatırlatır', style: TextStyle(fontSize: 12, color: AppTheme.textMuted)),
                    value: _notificationsEnabled,
                    activeThumbColor: AppTheme.primary,
                    onChanged: (val) => setState(() => _notificationsEnabled = val),
                  ),

                  const Divider(height: 1, color: AppTheme.outlineVariant),
                  const SizedBox(height: 8),

                  // Demo Data Reset / Load
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.refresh_rounded, color: AppTheme.primary),
                    title: const Text('Örnek Verileri Yeniden Yükle', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                    subtitle: const Text('Grafik ve takvim verilerini sıfırlayıp demo yükler', style: TextStyle(fontSize: 12, color: AppTheme.textMuted)),
                    trailing: OutlinedButton(
                      onPressed: () {
                        widget.state.loadSampleData();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Örnek veriler başarıyla yüklendi!')),
                        );
                      },
                      child: const Text('Yükle'),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Hesaptan Çıkış Yap Butonu (hesapcikis.md)
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _confirmLogout,
                      icon: const Icon(Icons.logout_rounded, size: 18),
                      label: const Text('Hesaptan Çıkış Yap'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.error,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileTag({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: color,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  title,
                  style: const TextStyle(fontSize: 11, color: AppTheme.textSecondary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
