import 'package:flutter/material.dart';
import '../models/habit_model.dart';
import '../theme/app_theme.dart';

class HabitTemplate {
  final String title;
  final String category;
  final String colorHex;
  final IconData icon;
  final String description;

  const HabitTemplate({
    required this.title,
    required this.category,
    required this.colorHex,
    required this.icon,
    required this.description,
  });
}

class AddHabitModal extends StatefulWidget {
  final List<HabitModel> existingHabits;
  final Function({
    required String title,
    required String category,
    required String colorHex,
    int? smokingBaseline,
    double? smokingPackPrice,
    double? alcoholPrice,
  }) onAddHabit;

  const AddHabitModal({
    super.key,
    required this.existingHabits,
    required this.onAddHabit,
  });

  @override
  State<AddHabitModal> createState() => _AddHabitModalState();
}

class _AddHabitModalState extends State<AddHabitModal> {
  final TextEditingController _searchCtrl = TextEditingController();
  String _searchQuery = '';

  static const List<HabitTemplate> _allTemplates = [
    HabitTemplate(
      title: 'Kitap Okuma',
      category: 'reading',
      colorHex: '#FFB300',
      icon: Icons.menu_book_rounded,
      description: 'Zihninizi besleyin, 100 kitap hedefine ulaşın.',
    ),
    HabitTemplate(
      title: 'Yüzme',
      category: 'swimming',
      colorHex: '#2196F3',
      icon: Icons.pool_rounded,
      description: 'Tüm kasları çalıştırın ve suyun direncini hissedin.',
    ),
    HabitTemplate(
      title: 'Koşu',
      category: 'running',
      colorHex: '#4CAF50',
      icon: Icons.directions_run_rounded,
      description: 'Her gün düzenli koşarak kondisyon kazanın.',
    ),
    HabitTemplate(
      title: 'Fitness',
      category: 'fitness',
      colorHex: '#FF5722',
      icon: Icons.fitness_center_rounded,
      description: 'Güç, esneklik ve kardiyo antrenmanları yapın.',
    ),
    HabitTemplate(
      title: 'Su İçme',
      category: 'water',
      colorHex: '#03A9F4',
      icon: Icons.water_drop_rounded,
      description: 'Vücudunuzun hidrasyonunu zirvede tutun.',
    ),
    HabitTemplate(
      title: 'Zeka Oyunları',
      category: 'mind_games',
      colorHex: '#9C27B0',
      icon: Icons.psychology_rounded,
      description: 'Satranç, sudoku ve bulmaca ile zekanızı keskinleştirin.',
    ),
    HabitTemplate(
      title: 'Sağlıklı Beslenme',
      category: 'healthy_food',
      colorHex: '#8BC34A',
      icon: Icons.restaurant_rounded,
      description: 'Öğün kalorilerini kontrol ederek kalori tasarrufu yapın.',
    ),
    HabitTemplate(
      title: 'Sigara Bırakma',
      category: 'quit_smoking',
      colorHex: '#E91E63',
      icon: Icons.smoke_free_rounded,
      description: 'Ciğerlerinizi ve cüzdanınızı koruyun, para biriktirin.',
    ),
    HabitTemplate(
      title: 'Alkol Bırakma',
      category: 'quit_alcohol',
      colorHex: '#E91E63',
      icon: Icons.no_drinks_rounded,
      description: 'Alkolü hayatınızdan çıkararak tasarruf ve sağlık kazanın.',
    ),
    HabitTemplate(
      title: 'Diğer Spor Faaliyetleri',
      category: 'other_sports',
      colorHex: '#3F51B5',
      icon: Icons.sports_rounded,
      description: 'Bisiklet, yoga, pilates veya halı saha maçları.',
    ),
  ];

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  void _onSelectTemplate(HabitTemplate template) {
    if (template.category == 'quit_smoking') {
      _showSmokingSetupDialog(template);
    } else if (template.category == 'quit_alcohol') {
      _showAlcoholSetupDialog(template);
    } else {
      widget.onAddHabit(
        title: template.title,
        category: template.category,
        colorHex: template.colorHex,
      );
      Navigator.of(context).pop();
    }
  }

  void _showSmokingSetupDialog(HabitTemplate template) {
    final baselineCtrl = TextEditingController(text: '20');
    final packPriceCtrl = TextEditingController(text: '75');

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.smoke_free_rounded, color: AppTheme.quitSmoking),
            SizedBox(width: 8),
            Text('Sigara Bırakma Ayarları', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Tasarruf miktarınızı tam hesaplayabilmemiz için temel bilgileri girin:',
              style: TextStyle(fontSize: 13, color: AppTheme.textSecondary),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: baselineCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Normalde günde içtiğiniz dal sayısı',
                suffixText: 'dal',
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: packPriceCtrl,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: '1 Paket Sigara Fiyatı (TL)',
                suffixText: 'TL',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('İptal'),
          ),
          ElevatedButton(
            onPressed: () {
              final baseline = int.tryParse(baselineCtrl.text) ?? 20;
              final price = double.tryParse(packPriceCtrl.text) ?? 75.0;
              Navigator.of(ctx).pop(); // close dialog
              widget.onAddHabit(
                title: template.title,
                category: template.category,
                colorHex: template.colorHex,
                smokingBaseline: baseline,
                smokingPackPrice: price,
              );
              Navigator.of(context).pop(); // close modal
            },
            child: const Text('Başlat ve Ekle'),
          ),
        ],
      ),
    );
  }

  void _showAlcoholSetupDialog(HabitTemplate template) {
    final costCtrl = TextEditingController(text: '120');

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.no_drinks_rounded, color: AppTheme.quitAlcohol),
            SizedBox(width: 8),
            Text('Alkol Bırakma Ayarı', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              '1 birim/kadeh alkol için ortalama harcamanız kaç TL?',
              style: TextStyle(fontSize: 13, color: AppTheme.textSecondary),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: costCtrl,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'Ortalama 1 Birim Alkol Maliyeti',
                suffixText: 'TL',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('İptal'),
          ),
          ElevatedButton(
            onPressed: () {
              final price = double.tryParse(costCtrl.text) ?? 120.0;
              Navigator.of(ctx).pop();
              widget.onAddHabit(
                title: template.title,
                category: template.category,
                colorHex: template.colorHex,
                alcoholPrice: price,
              );
              Navigator.of(context).pop();
            },
            child: const Text('Başlat ve Ekle'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Filter out templates user already has
    final existingCategories = widget.existingHabits.map((h) => h.category).toSet();
    final availableTemplates = _allTemplates.where((t) {
      final matchesSearch = t.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          t.description.toLowerCase().contains(_searchQuery.toLowerCase());
      final notAdded = !existingCategories.contains(t.category);
      return matchesSearch && notAdded;
    }).toList();

    return Container(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.82,
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
              margin: const EdgeInsets.only(bottom: 16),
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
                  color: AppTheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.add_task_rounded, color: AppTheme.primary, size: 22),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Yeni Alışkanlık Ekle',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    Text(
                      'Listenizde olmayan bir alışkanlık seçin',
                      style: TextStyle(fontSize: 13, color: AppTheme.textMuted),
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
          const SizedBox(height: 16),

          // Search Bar (aliskanlikeklemeskill.md)
          TextField(
            controller: _searchCtrl,
            decoration: InputDecoration(
              hintText: 'Alışkanlık ara... (Örn: Yüzme, Kitap, Su)',
              prefixIcon: const Icon(Icons.search_rounded, color: AppTheme.textMuted),
              suffixIcon: _searchQuery.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear_rounded, size: 18),
                      onPressed: () {
                        setState(() {
                          _searchCtrl.clear();
                          _searchQuery = '';
                        });
                      },
                    )
                  : null,
            ),
            onChanged: (val) {
              setState(() {
                _searchQuery = val.trim();
              });
            },
          ),
          const SizedBox(height: 16),

          // Templates List
          Expanded(
            child: availableTemplates.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.check_circle_outline_rounded,
                              size: 48, color: AppTheme.success.withValues(alpha: 0.5)),
                          const SizedBox(height: 12),
                          Text(
                            _searchQuery.isEmpty
                                ? 'Harika! Tüm hazır alışkanlıkları zaten listenize eklediniz.'
                                : '"$_searchQuery" ile eşleşen yeni alışkanlık bulunamadı.',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: AppTheme.textSecondary,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : ListView.builder(
                    itemCount: availableTemplates.length,
                    itemBuilder: (context, index) {
                      final template = availableTemplates[index];
                      final Color color = Color(int.parse('FF${template.colorHex.replaceAll('#', '')}', radix: 16));

                      return Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppTheme.outlineVariant),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.02),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Material(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                          leading: Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: color.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(template.icon, color: color, size: 24),
                          ),
                          title: Text(
                            template.title,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: AppTheme.textPrimary,
                            ),
                          ),
                          subtitle: Text(
                            template.description,
                            style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          trailing: ElevatedButton(
                            onPressed: () => _onSelectTemplate(template),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: color,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            ),
                            child: const Text('Ekle', style: TextStyle(fontSize: 13)),
                          ),
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
