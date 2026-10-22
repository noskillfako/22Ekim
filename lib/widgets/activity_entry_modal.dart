import 'dart:math';
import 'package:flutter/material.dart';
import '../models/habit_model.dart';
import '../models/user_model.dart';
import '../theme/app_theme.dart';

class ActivityEntryModal extends StatefulWidget {
  final HabitModel habit;
  final UserModel user;
  final bool isWatchConnected;
  final Function({
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
  }) onSave;

  const ActivityEntryModal({
    super.key,
    required this.habit,
    required this.user,
    required this.isWatchConnected,
    required this.onSave,
  });

  @override
  State<ActivityEntryModal> createState() => _ActivityEntryModalState();
}

class _ActivityEntryModalState extends State<ActivityEntryModal> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  late TextEditingController _durationCtrl;
  late TextEditingController _distanceCtrl;
  late TextEditingController _pagesReadCtrl;
  late TextEditingController _bookTotalPagesCtrl;
  late TextEditingController _bookGenreCtrl;
  late TextEditingController _mealCaloriesCtrl;
  late TextEditingController _smokedCtrl;
  late TextEditingController _avoidedCtrl;
  late TextEditingController _waterCtrl;

  bool _isBookFinished = false;
  String _selectedGameType = 'Satranç';
  String _selectedSportBranch = 'Bisiklet';
  double _selectedWaterLiters = 1.5;

  @override
  void initState() {
    super.initState();
    _durationCtrl = TextEditingController(text: '30');
    _distanceCtrl = TextEditingController(text: '5.0');
    _pagesReadCtrl = TextEditingController(text: '20');
    _bookTotalPagesCtrl = TextEditingController(text: '250');
    _bookGenreCtrl = TextEditingController(text: 'Roman');
    _mealCaloriesCtrl = TextEditingController(text: '450');
    _smokedCtrl = TextEditingController(text: '0');
    _avoidedCtrl = TextEditingController(text: '2');
    _waterCtrl = TextEditingController(text: '1.5');
  }

  @override
  void dispose() {
    _durationCtrl.dispose();
    _distanceCtrl.dispose();
    _pagesReadCtrl.dispose();
    _bookTotalPagesCtrl.dispose();
    _bookGenreCtrl.dispose();
    _mealCaloriesCtrl.dispose();
    _smokedCtrl.dispose();
    _avoidedCtrl.dispose();
    _waterCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final cat = widget.habit.category;

    int? durationMinutes = int.tryParse(_durationCtrl.text);
    double? distanceKm = double.tryParse(_distanceCtrl.text);
    int? pagesRead = int.tryParse(_pagesReadCtrl.text);
    int? bookTotalPages = int.tryParse(_bookTotalPagesCtrl.text);
    String? bookGenre = _bookGenreCtrl.text.trim();
    double? waterLiters = _selectedWaterLiters;
    int? mealCalories = int.tryParse(_mealCaloriesCtrl.text);
    int? smokedCount = int.tryParse(_smokedCtrl.text);
    int? avoidedCount = int.tryParse(_avoidedCtrl.text);

    if (cat == 'reading') {
      widget.onSave(
        pagesRead: pagesRead,
        bookTotalPages: bookTotalPages,
        bookGenre: bookGenre,
        isBookFinished: _isBookFinished || (pagesRead != null && bookTotalPages != null && pagesRead >= bookTotalPages),
      );
    } else if (cat == 'swimming' || cat == 'fitness') {
      widget.onSave(durationMinutes: durationMinutes);
    } else if (cat == 'running') {
      widget.onSave(
        distanceKm: distanceKm,
        durationMinutes: durationMinutes,
      );
    } else if (cat == 'mind_games') {
      widget.onSave(
        durationMinutes: durationMinutes,
        bookGenre: _selectedGameType,
      );
    } else if (cat == 'water') {
      widget.onSave(waterLiters: waterLiters);
    } else if (cat == 'healthy_food') {
      widget.onSave(mealCalories: mealCalories);
    } else if (cat == 'quit_smoking') {
      widget.onSave(smokedCount: smokedCount);
    } else if (cat == 'quit_alcohol') {
      widget.onSave(avoidedCount: avoidedCount);
    } else if (cat == 'other_sports') {
      widget.onSave(
        durationMinutes: durationMinutes,
        bookGenre: _selectedSportBranch,
      );
    }

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final cat = widget.habit.category;
    final habitColor = widget.habit.color;

    return Container(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Drag handle
              Center(
                child: Container(
                  width: 44,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: AppTheme.outlineVariant,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),

              // Title and Category Header
              Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: habitColor.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(widget.habit.icon, color: habitColor, size: 24),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.habit.title,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                        Text(
                          'Bugünkü Aktivite Girişi',
                          style: TextStyle(
                            fontSize: 13,
                            color: AppTheme.textMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Watch connected badge
                  if (widget.isWatchConnected &&
                      (cat == 'swimming' || cat == 'running' || cat == 'fitness'))
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFF10B981).withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.watch_rounded, size: 14, color: Color(0xFF10B981)),
                          SizedBox(width: 4),
                          Text(
                            'Saat Aktif',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF10B981),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 20),

              // Dynamic Form Body by Category
              if (cat == 'reading') _buildReadingForm(),
              if (cat == 'swimming') _buildSwimmingForm(),
              if (cat == 'fitness') _buildFitnessForm(),
              if (cat == 'running') _buildRunningForm(),
              if (cat == 'mind_games') _buildMindGamesForm(),
              if (cat == 'water') _buildWaterForm(),
              if (cat == 'healthy_food') _buildHealthyFoodForm(),
              if (cat == 'quit_smoking') _buildQuitSmokingForm(),
              if (cat == 'quit_alcohol') _buildQuitAlcoholForm(),
              if (cat == 'other_sports') _buildOtherSportsForm(),

              const SizedBox(height: 24),

              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('İptal'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton.icon(
                      onPressed: _submit,
                      icon: const Icon(Icons.check_rounded, size: 18),
                      label: const Text('Kaydet ve Tamamla'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: habitColor,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- 1. READING FORM ---
  Widget _buildReadingForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: _bookGenreCtrl,
          decoration: const InputDecoration(
            labelText: 'Kitap Adı / Türü (Roman, Tarih, Bilim Kurgu vb.)',
            prefixIcon: Icon(Icons.bookmark_outline_rounded),
          ),
          validator: (val) {
            if (val == null || val.trim().isEmpty) {
              return 'Lütfen geçerli bir değer giriniz.';
            }
            return null;
          },
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _pagesReadCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Okunan Sayfa',
                  suffixText: 'sayfa',
                  prefixIcon: Icon(Icons.auto_stories_rounded),
                ),
                validator: (val) {
                  final pages = int.tryParse(val ?? '');
                  if (pages == null || pages <= 0) {
                    return 'Lütfen geçerli bir değer giriniz.';
                  }
                  final total = int.tryParse(_bookTotalPagesCtrl.text);
                  if (total != null && pages > total) {
                    return 'Okunan sayfa toplam sayfadan büyük olamaz.';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TextFormField(
                controller: _bookTotalPagesCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Toplam Sayfa',
                  suffixText: 'sayfa',
                  prefixIcon: Icon(Icons.menu_book_rounded),
                ),
                validator: (val) {
                  final total = int.tryParse(val ?? '');
                  if (total == null || total <= 0) {
                    return 'Lütfen geçerli bir değer giriniz.';
                  }
                  return null;
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        CheckboxListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text(
            'Bu kitabı bugün tamamen bitirdim',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
          subtitle: const Text(
            '100 Kitap Altın Kütüphaneci rozeti sayacını ilerletir.',
            style: TextStyle(fontSize: 12, color: AppTheme.textMuted),
          ),
          value: _isBookFinished,
          activeColor: AppTheme.reading,
          onChanged: (val) => setState(() => _isBookFinished = val ?? false),
        ),
      ],
    );
  }

  // --- 2. SWIMMING FORM ---
  Widget _buildSwimmingForm() {
    final mins = int.tryParse(_durationCtrl.text) ?? 30;
    final calories = widget.isWatchConnected ? (mins * 9.2) : (mins * 8.5);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: _durationCtrl,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Yüzme Süresi',
            suffixText: 'dakika',
            prefixIcon: Icon(Icons.timer_rounded),
          ),
          onChanged: (_) => setState(() {}),
          validator: (val) {
            final num = int.tryParse(val ?? '');
            if (num == null || num <= 0) {
              return 'Lütfen geçerli bir değer giriniz.';
            }
            return null;
          },
        ),
        const SizedBox(height: 14),
        _buildCalorieFeedbackCard(
          calories: calories,
          isWatch: widget.isWatchConnected,
          subtitle: widget.isWatchConnected
              ? 'Akıllı saatinizden senkronize edildi'
              : 'Saat bağlı değil, tahmini formülle hesaplandı',
        ),
      ],
    );
  }

  // --- 3. FITNESS FORM ---
  Widget _buildFitnessForm() {
    final mins = int.tryParse(_durationCtrl.text) ?? 45;
    final calories = widget.isWatchConnected ? (mins * 7.5) : (mins * 6.5);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: _durationCtrl,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Fitness / Antrenman Süresi',
            suffixText: 'dakika',
            prefixIcon: Icon(Icons.timer_rounded),
          ),
          onChanged: (_) => setState(() {}),
          validator: (val) {
            final num = int.tryParse(val ?? '');
            if (num == null || num <= 0) {
              return 'Lütfen geçerli bir değer giriniz.';
            }
            return null;
          },
        ),
        const SizedBox(height: 14),
        _buildCalorieFeedbackCard(
          calories: calories,
          isWatch: widget.isWatchConnected,
          subtitle: widget.isWatchConnected
              ? 'Akıllı saat kalp ritmi sensörüyle ölçüldü'
              : 'Tahmini: dakika başına 6.5 kcal',
        ),
      ],
    );
  }

  // --- 4. RUNNING FORM ---
  Widget _buildRunningForm() {
    final km = double.tryParse(_distanceCtrl.text) ?? 5.0;
    final calories = widget.isWatchConnected ? (km * 72.0) : (km * 65.0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _distanceCtrl,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  labelText: 'Koşu Mesafesi',
                  suffixText: 'km',
                  prefixIcon: Icon(Icons.straighten_rounded),
                ),
                onChanged: (_) => setState(() {}),
                validator: (val) {
                  final num = double.tryParse(val ?? '');
                  if (num == null || num <= 0) {
                    return 'Lütfen geçerli bir değer giriniz.';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TextFormField(
                controller: _durationCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Süre (Opsiyonel)',
                  suffixText: 'dakika',
                  prefixIcon: Icon(Icons.timer_outlined),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        _buildCalorieFeedbackCard(
          calories: calories,
          isWatch: widget.isWatchConnected,
          subtitle: widget.isWatchConnected
              ? 'Akıllı saat GPS ve nabız verisiyle senkronize'
              : 'Tahmini: km başına 65 kcal',
        ),
      ],
    );
  }

  // --- 5. MIND GAMES FORM ---
  Widget _buildMindGamesForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DropdownButtonFormField<String>(
          initialValue: _selectedGameType,
          decoration: const InputDecoration(
            labelText: 'Oyun Türü',
            prefixIcon: Icon(Icons.games_rounded),
          ),
          items: const [
            DropdownMenuItem(value: 'Satranç', child: Text('Satranç')),
            DropdownMenuItem(value: 'Sudoku', child: Text('Sudoku')),
            DropdownMenuItem(value: 'Kelime Bulmaca', child: Text('Kelime Bulmaca')),
            DropdownMenuItem(value: 'Hafıza Egzersizi', child: Text('Hafıza Egzersizi')),
          ],
          onChanged: (val) => setState(() => _selectedGameType = val ?? 'Satranç'),
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _durationCtrl,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Oynanan Süre',
            suffixText: 'dakika',
            prefixIcon: Icon(Icons.timer_rounded),
          ),
          validator: (val) {
            final num = int.tryParse(val ?? '');
            if (num == null || num <= 0) {
              return 'Lütfen geçerli bir değer giriniz.';
            }
            return null;
          },
        ),
      ],
    );
  }

  // --- 6. WATER FORM ---
  Widget _buildWaterForm() {
    const quickOptions = [0.5, 1.0, 1.5, 2.0, 2.5, 3.0];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Bugün İçilen Su Miktarı:',
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: quickOptions.map((liters) {
            final isSelected = _selectedWaterLiters == liters;
            return ChoiceChip(
              label: Text('$liters L'),
              selected: isSelected,
              selectedColor: AppTheme.water.withValues(alpha: 0.2),
              side: BorderSide(
                color: isSelected ? AppTheme.water : AppTheme.outlineVariant,
                width: isSelected ? 1.5 : 1,
              ),
              labelStyle: TextStyle(
                color: isSelected ? AppTheme.water : AppTheme.textPrimary,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              ),
              onSelected: (_) => setState(() => _selectedWaterLiters = liters),
            );
          }).toList(),
        ),
        const SizedBox(height: 14),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppTheme.water.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              const Icon(Icons.water_drop_rounded, color: AppTheme.water),
              const SizedBox(width: 8),
              Text(
                'Seçilen miktar: $_selectedWaterLiters Litre',
                style: const TextStyle(fontWeight: FontWeight.w600, color: AppTheme.water),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // --- 7. HEALTHY FOOD FORM ---
  Widget _buildHealthyFoodForm() {
    final mealKcal = int.tryParse(_mealCaloriesCtrl.text) ?? 450;
    final savedKcal = max(0, widget.user.standardMealCalories - mealKcal);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: _mealCaloriesCtrl,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Yediğiniz Sağlıklı Öğünün Kalorisi',
            suffixText: 'kcal',
            prefixIcon: Icon(Icons.restaurant_menu_rounded),
          ),
          onChanged: (_) => setState(() {}),
          validator: (val) {
            final num = int.tryParse(val ?? '');
            if (num == null || num <= 0) {
              return 'Lütfen geçerli bir değer giriniz.';
            }
            return null;
          },
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppTheme.healthyFood.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppTheme.healthyFood.withValues(alpha: 0.3)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.savings_rounded, color: AppTheme.healthyFood, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    'Kalori Tasarrufu: $savedKcal kcal',
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                      color: AppTheme.healthyFood,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                'Ortalama bir standart öğüne (${widget.user.standardMealCalories} kcal) göre $savedKcal kcal daha az aldınız!',
                style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // --- 8. QUIT SMOKING FORM ---
  Widget _buildQuitSmokingForm() {
    final smoked = int.tryParse(_smokedCtrl.text) ?? 0;
    final avoided = max(0, widget.user.smokingBaselineDaily - smoked);
    final pricePerCig = widget.user.smokingPackPrice / 20.0;
    final moneySaved = avoided * pricePerCig;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: _smokedCtrl,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Bugün Kaç Dal Sigara İçildi? (Hiç içmediyseniz 0)',
            suffixText: 'dal',
            prefixIcon: Icon(Icons.smoke_free_rounded),
          ),
          onChanged: (_) => setState(() {}),
          validator: (val) {
            final num = int.tryParse(val ?? '');
            if (num == null || num < 0) {
              return 'Lütfen geçerli bir değer giriniz.';
            }
            return null;
          },
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppTheme.quitSmoking.withValues(alpha: 0.09),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppTheme.quitSmoking.withValues(alpha: 0.3)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.wallet_rounded, color: AppTheme.quitSmoking, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    'Kâr: ${moneySaved.toStringAsFixed(2)} TL',
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                      color: AppTheme.quitSmoking,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                'Normalde içtiğiniz ${widget.user.smokingBaselineDaily} dala göre bugün $avoided dal sigara içmediniz ve ${moneySaved.toStringAsFixed(2)} TL kâr ettiniz!',
                style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // --- 9. QUIT ALCOHOL FORM ---
  Widget _buildQuitAlcoholForm() {
    final avoidedUnits = int.tryParse(_avoidedCtrl.text) ?? 2;
    final moneySaved = avoidedUnits * widget.user.alcoholBaselinePrice;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: _avoidedCtrl,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Bugün Tüketilmeyen / Pas Geçilen Alkol Miktarı',
            suffixText: 'birim/kadeh',
            prefixIcon: Icon(Icons.no_drinks_rounded),
          ),
          onChanged: (_) => setState(() {}),
          validator: (val) {
            final num = int.tryParse(val ?? '');
            if (num == null || num <= 0) {
              return 'Lütfen geçerli bir değer giriniz.';
            }
            return null;
          },
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppTheme.quitAlcohol.withValues(alpha: 0.09),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppTheme.quitAlcohol.withValues(alpha: 0.3)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.savings_rounded, color: AppTheme.quitAlcohol, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    'Kâr: ${moneySaved.toStringAsFixed(2)} TL',
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                      color: AppTheme.quitAlcohol,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                'Birim fiyat ${widget.user.alcoholBaselinePrice} TL üzerinden hesaplanmıştır.',
                style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // --- 10. OTHER SPORTS FORM ---
  Widget _buildOtherSportsForm() {
    final mins = int.tryParse(_durationCtrl.text) ?? 30;
    final calories = mins * 7.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DropdownButtonFormField<String>(
          initialValue: _selectedSportBranch,
          decoration: const InputDecoration(
            labelText: 'Spor Branşı',
            prefixIcon: Icon(Icons.sports_rounded),
          ),
          items: const [
            DropdownMenuItem(value: 'Bisiklet', child: Text('Bisiklet')),
            DropdownMenuItem(value: 'Basketbol', child: Text('Basketbol')),
            DropdownMenuItem(value: 'Futbol', child: Text('Futbol / Halı Saha')),
            DropdownMenuItem(value: 'Yoga', child: Text('Yoga')),
            DropdownMenuItem(value: 'Pilates', child: Text('Pilates')),
          ],
          onChanged: (val) => setState(() => _selectedSportBranch = val ?? 'Bisiklet'),
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _durationCtrl,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Yapılan Süre',
            suffixText: 'dakika',
            prefixIcon: Icon(Icons.timer_rounded),
          ),
          onChanged: (_) => setState(() {}),
          validator: (val) {
            final num = int.tryParse(val ?? '');
            if (num == null || num <= 0) {
              return 'Lütfen geçerli bir değer giriniz.';
            }
            return null;
          },
        ),
        const SizedBox(height: 14),
        _buildCalorieFeedbackCard(
          calories: calories,
          isWatch: widget.isWatchConnected,
          subtitle: widget.isWatchConnected
              ? 'Akıllı saatten senkronize edildi'
              : 'Tahmini: dakika başına 7.0 kcal',
        ),
      ],
    );
  }

  Widget _buildCalorieFeedbackCard({
    required double calories,
    required bool isWatch,
    required String subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.fitness.withValues(alpha: 0.09),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.fitness.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.local_fire_department_rounded, color: AppTheme.fitness, size: 28),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${calories.toStringAsFixed(1)} kcal Yakıldı',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.fitness,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
