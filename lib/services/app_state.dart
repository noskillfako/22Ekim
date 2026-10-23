import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';
import '../models/habit_model.dart';
import '../models/activity_log_model.dart';
import '../models/badge_model.dart';
import '../models/notification_model.dart';
import 'avatar_service.dart';

class DayAdvanceResult {
  final DateTime previousDate;
  final DateTime newDate;
  final List<HabitModel> missedHabits;
  final List<HabitModel> preservedHabits;

  const DayAdvanceResult({
    required this.previousDate,
    required this.newDate,
    required this.missedHabits,
    required this.preservedHabits,
  });
}

class AppState extends ChangeNotifier {
  UserModel? _currentUser;
  List<HabitModel> _habits = [];
  List<ActivityLogModel> _activityLogs = [];
  List<BadgeModel> _badges = [];

  // Simulated Time / Time Travel (Demo Mode)
  DateTime? _simulatedDateTime;

  // In-App Notifications (Streak Alerts & Reminders)
  List<AppNotificationModel> _notifications = [];

  // Smart Watch Simulation State (watchskill.md)
  bool _isWatchConnected = false;
  int _simulatedHeartRate = 72;
  double _simulatedActiveCaloriesBurned = 385.0;
  int _simulatedSteps = 6420;
  DateTime? _lastWatchSync;
  Timer? _watchTimer;

  bool _isLoading = true;

  UserModel? get currentUser => _currentUser;
  List<HabitModel> get habits => List.unmodifiable(_habits);
  List<ActivityLogModel> get activityLogs => List.unmodifiable(_activityLogs);
  List<BadgeModel> get badges => List.unmodifiable(_badges);
  bool get isWatchConnected => _isWatchConnected;
  int get simulatedHeartRate => _simulatedHeartRate;
  double get simulatedActiveCaloriesBurned => _simulatedActiveCaloriesBurned;
  int get simulatedSteps => _simulatedSteps;
  DateTime? get lastWatchSync => _lastWatchSync;
  bool get isLoading => _isLoading;
  bool get isLoggedIn => _currentUser != null;

  // Time Travel Getters
  DateTime get currentDateTime => _simulatedDateTime ?? DateTime.now();
  bool get isSimulatedTime => _simulatedDateTime != null;

  // Notification Getters
  List<AppNotificationModel> get notifications => List.unmodifiable(_notifications);
  int get unreadNotificationsCount => _notifications.where((n) => !n.isRead).length;

  AppState() {
    _init();
  }

  Future<void> _init() async {
    _isLoading = true;
    notifyListeners();
    await _loadFromPrefs();
    _isLoading = false;
    notifyListeners();
  }

  // --- Date Helpers ---
  String get todayString {
    return _formatDate(currentDateTime);
  }

  String get yesterdayString {
    final yesterday = currentDateTime.subtract(const Duration(days: 1));
    return _formatDate(yesterday);
  }

  String _formatDate(DateTime date) {
    final y = date.year.toString().padLeft(4, '0');
    final m = date.month.toString().padLeft(2, '0');
    final d = date.day.toString().padLeft(2, '0');
    return '$y-$m-$d';
  }

  // --- TIME TRAVEL & DEMO SIMULATOR SKILL ---

  Future<DayAdvanceResult> advanceDay({int days = 1}) async {
    final oldDate = currentDateTime;
    final oldDateString = todayString;
    final newDate = oldDate.add(Duration(days: days));
    _simulatedDateTime = newDate;

    final newDateString = todayString;
    final yesterdayDateString = yesterdayString;

    final List<HabitModel> missedHabits = [];
    final List<HabitModel> preservedHabits = [];

    // Alışkanlıkların dün yapılıp yapılmadığını denetle
    for (int i = 0; i < _habits.length; i++) {
      final h = _habits[i];
      // Eğer +1 gün geçildiyse dün = oldDateString; birden fazla gün geçildiyse dün = yesterdayDateString
      final bool completedYesterday = (days == 1)
          ? (h.lastCompletedDate == oldDateString)
          : (h.lastCompletedDate == yesterdayDateString);

      if (completedYesterday) {
        preservedHabits.add(h);
      } else {
        // Dün yapılmadı!
        final prevStreak = h.currentStreak;
        missedHabits.add(h);
        _habits[i] = h.copyWith(currentStreak: 0);

        // Bildirim oluştur
        final notifId = 'notif_${DateTime.now().millisecondsSinceEpoch}_${h.id}';
        final notifTitle = prevStreak > 0
            ? '💔 Seri Bozuldu: ${h.title}'
            : '⚠️ Alışkanlık Yapılmadı: ${h.title}';
        final notifMsg = prevStreak > 0
            ? 'Dün "${h.title}" hedefini tamamlamadığın için $prevStreak günlük serin sıfırlandı. Bugün yeni bir seri başlatabilirsin!'
            : 'Dün "${h.title}" hedefini tamamlamadın. Bugün zinciri kırmadan devam et!';

        _notifications.insert(
          0,
          AppNotificationModel(
            id: notifId,
            title: notifTitle,
            message: notifMsg,
            timestamp: newDate,
            dateString: newDateString,
            category: h.category,
            isStreakBroken: prevStreak > 0,
            isRead: false,
          ),
        );
      }
    }

    // Hiç kaçırılan yoksa tebrik bildirimi ekle
    if (missedHabits.isEmpty && preservedHabits.isNotEmpty) {
      final notifId = 'notif_${DateTime.now().millisecondsSinceEpoch}_congrats';
      _notifications.insert(
        0,
        AppNotificationModel(
          id: notifId,
          title: '🌟 Mükemmel Disiplin! Tüm Zincirler Korundu',
          message: 'Dünkü tüm alışkanlıklarını eksiksiz tamamladın. Serilerin başarıyla yeni güne aktarıldı, bugün de devam et!',
          timestamp: newDate,
          dateString: newDateString,
          category: 'streak_shield',
          isStreakBroken: false,
          isRead: false,
        ),
      );
    }

    _evaluateBadges();
    await _saveToPrefs();
    notifyListeners();

    return DayAdvanceResult(
      previousDate: oldDate,
      newDate: newDate,
      missedHabits: missedHabits,
      preservedHabits: preservedHabits,
    );
  }

  Future<void> setSimulatedDateTime(DateTime newDateTime) async {
    final oldDateString = todayString;
    _simulatedDateTime = newDateTime;
    final newDateString = todayString;

    if (newDateString != oldDateString) {
      _checkStreakIntegrity();
    }
    _evaluateBadges();
    await _saveToPrefs();
    notifyListeners();
  }

  Future<void> resetToRealTime() async {
    _simulatedDateTime = null;
    _checkStreakIntegrity();
    _evaluateBadges();
    await _saveToPrefs();
    notifyListeners();
  }

  // --- NOTIFICATION MANAGEMENT ---

  Future<void> markNotificationAsRead(String id) async {
    final idx = _notifications.indexWhere((n) => n.id == id);
    if (idx != -1) {
      _notifications[idx] = _notifications[idx].copyWith(isRead: true);
      await _saveToPrefs();
      notifyListeners();
    }
  }

  Future<void> markAllNotificationsAsRead() async {
    _notifications = _notifications.map((n) => n.copyWith(isRead: true)).toList();
    await _saveToPrefs();
    notifyListeners();
  }

  Future<void> deleteNotification(String id) async {
    _notifications.removeWhere((n) => n.id == id);
    await _saveToPrefs();
    notifyListeners();
  }

  Future<void> clearNotifications() async {
    _notifications.clear();
    await _saveToPrefs();
    notifyListeners();
  }

  // --- AUTH SKILLS (authskill.md, hesapgirisskill.md, hesapcikis.md) ---

  Future<void> register({
    required String fullName,
    required String email,
    required String password,
    required int age,
    required String gender,
  }) async {
    final avatarId = AvatarService.getAvatarId(age, gender);
    final user = UserModel(
      uid: 'user_${DateTime.now().millisecondsSinceEpoch}',
      email: email,
      fullName: fullName,
      age: age,
      gender: gender,
      avatarId: avatarId,
      isWatchConnected: false,
      smokingBaselineDaily: 20,
      smokingPackPrice: 75.0,
      alcoholBaselinePrice: 120.0,
      standardMealCalories: 800,
    );

    _currentUser = user;
    _badges = _createInitialBadges();
    _habits = _createInitialDefaultHabits(user.uid);
    _activityLogs = _createSampleActivityLogs(user.uid, _habits);
    _checkStreakIntegrity();
    _evaluateBadges();
    await _saveToPrefs();
    notifyListeners();
  }

  Future<void> login({
    required String email,
    required String password,
    bool rememberMe = true,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString('current_user');

    if (userJson != null) {
      _currentUser = UserModel.fromJson(jsonDecode(userJson) as Map<String, dynamic>);
    } else {
      // Default initial mock user
      _currentUser = UserModel(
        uid: 'user_demo',
        email: email.isNotEmpty ? email : 'demo@habitchain.com',
        fullName: 'Demir Kaya',
        age: 26,
        gender: 'male',
        avatarId: AvatarService.getAvatarId(26, 'male'),
        isWatchConnected: false,
      );
    }

    _checkStreakIntegrity();
    _evaluateBadges();
    await _saveToPrefs();
    notifyListeners();
  }

  Future<void> logout() async {
    _currentUser = null;
    _isWatchConnected = false;
    _watchTimer?.cancel();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('current_user');
    notifyListeners();
  }

  Future<void> updateProfile({
    String? fullName,
    int? age,
    String? gender,
    String? avatarId,
    int? smokingBaselineDaily,
    double? smokingPackPrice,
    double? alcoholBaselinePrice,
    int? standardMealCalories,
  }) async {
    if (_currentUser == null) return;

    final newAge = age ?? _currentUser!.age;
    final newGender = gender ?? _currentUser!.gender;
    final newAvatarId = avatarId ??
        ((age != null || gender != null)
            ? AvatarService.getAvatarId(newAge, newGender)
            : _currentUser!.avatarId);

    _currentUser = _currentUser!.copyWith(
      fullName: fullName,
      age: newAge,
      gender: newGender,
      avatarId: newAvatarId,
      smokingBaselineDaily: smokingBaselineDaily,
      smokingPackPrice: smokingPackPrice,
      alcoholBaselinePrice: alcoholBaselinePrice,
      standardMealCalories: standardMealCalories,
    );

    await _saveToPrefs();
    notifyListeners();
  }

  // --- HABIT SKILLS (aliskanlikeklemeskill.md, aliskanlikcikarma.md, ilerlemeskill.md) ---

  Future<void> addHabit({
    required String title,
    required String category,
    required String colorHex,
    int? smokingBaseline,
    double? smokingPackPrice,
    double? alcoholPrice,
  }) async {
    if (_currentUser == null) return;

    // Check if category settings need to be updated
    if (category == 'quit_smoking' && (smokingBaseline != null || smokingPackPrice != null)) {
      _currentUser = _currentUser!.copyWith(
        smokingBaselineDaily: smokingBaseline ?? _currentUser!.smokingBaselineDaily,
        smokingPackPrice: smokingPackPrice ?? _currentUser!.smokingPackPrice,
      );
    }
    if (category == 'quit_alcohol' && alcoholPrice != null) {
      _currentUser = _currentUser!.copyWith(
        alcoholBaselinePrice: alcoholPrice,
      );
    }

    final newHabit = HabitModel(
      id: 'habit_${DateTime.now().millisecondsSinceEpoch}',
      userId: _currentUser!.uid,
      title: title,
      category: category,
      colorHex: colorHex,
      animationAsset: '',
      currentStreak: 0,
      longestStreak: 0,
      lastCompletedDate: null,
    );

    _habits.add(newHabit);
    await _saveToPrefs();
    notifyListeners();
  }

  Future<void> deleteHabit(String habitId) async {
    _habits.removeWhere((h) => h.id == habitId);
    _activityLogs.removeWhere((log) => log.habitId == habitId);
    _evaluateBadges();
    await _saveToPrefs();
    notifyListeners();
  }

  // --- ACTIVITY LOG SKILL (turunegoreaktiviteskill.md & tasarrufhesaplamaskill.md) ---

  Future<void> logActivity({
    required String habitId,
    required String category,
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
  }) async {
    if (_currentUser == null) return;

    final habitIndex = _habits.indexWhere((h) => h.id == habitId);
    if (habitIndex == -1) return;
    final habit = _habits[habitIndex];

    final date = todayString;

    // 1. Calculate Burned Calories
    double caloriesBurned = 0.0;
    if (category == 'swimming') {
      final mins = durationMinutes ?? 30;
      caloriesBurned = _isWatchConnected ? (mins * 9.2) : (mins * 8.5);
    } else if (category == 'fitness') {
      final mins = durationMinutes ?? 45;
      caloriesBurned = _isWatchConnected ? (mins * 7.5) : (mins * 6.5);
    } else if (category == 'running') {
      final km = distanceKm ?? 5.0;
      caloriesBurned = _isWatchConnected ? (km * 72.0) : (km * 65.0);
    } else if (category == 'other_sports') {
      final mins = durationMinutes ?? 30;
      caloriesBurned = mins * 7.0;
    }

    // 2. Calculate Savings (TL & Calories) (tasarrufhesaplamaskill.md)
    double? moneySavedTL;
    double? caloriesSaved;
    int calculatedAvoidedCount = avoidedCount ?? 0;

    if (category == 'quit_smoking') {
      final baseline = _currentUser!.smokingBaselineDaily;
      final smoked = smokedCount ?? 0;
      calculatedAvoidedCount = max(0, baseline - smoked);
      final pricePerCig = _currentUser!.smokingPackPrice / 20.0;
      moneySavedTL = calculatedAvoidedCount * pricePerCig;
    } else if (category == 'quit_alcohol') {
      final unitCost = _currentUser!.alcoholBaselinePrice;
      moneySavedTL = calculatedAvoidedCount * unitCost;
    } else if (category == 'healthy_food') {
      final standard = _currentUser!.standardMealCalories;
      final consumed = mealCalories ?? 500;
      caloriesSaved = max(0.0, (standard - consumed).toDouble());
    }

    // Auto mark finished if read pages == total pages
    bool bookFinished = isBookFinished ?? false;
    if (category == 'reading' && bookTotalPages != null && pagesRead != null) {
      if (pagesRead >= bookTotalPages) {
        bookFinished = true;
      }
    }

    final newLog = ActivityLogModel(
      id: 'log_${DateTime.now().millisecondsSinceEpoch}',
      habitId: habitId,
      category: category,
      date: date,
      durationMinutes: durationMinutes,
      distanceKm: distanceKm,
      pagesRead: pagesRead,
      bookTotalPages: bookTotalPages,
      bookGenre: bookGenre,
      isBookFinished: bookFinished,
      waterLiters: waterLiters,
      caloriesBurned: caloriesBurned > 0 ? caloriesBurned : null,
      mealCalories: mealCalories,
      caloriesSaved: caloriesSaved,
      smokedCount: smokedCount,
      avoidedCount: calculatedAvoidedCount > 0 ? calculatedAvoidedCount : null,
      moneySavedTL: moneySavedTL,
    );

    // Aynı gün aynı alışkanlık için mükerrer kayıt olmaması için eskiyi güncelle
    _activityLogs.removeWhere((l) => l.habitId == habitId && l.date == date);
    _activityLogs.add(newLog);

    // 3. Streak Engine (ilerlemeskill.md)
    int newStreak = habit.currentStreak;
    String? newLastCompletedDate = date;

    // Sigara Bırakma Kuralı: Eğer 1 dal dahi sigara içildiyse seri sıfırlanır (0 gün)!
    if (category == 'quit_smoking' && (smokedCount ?? 0) > 0) {
      newStreak = 0;
      newLastCompletedDate = null; // Seri bozuldu, bugün başarıyla tamamlanmadı
    } else {
      if (habit.lastCompletedDate == yesterdayString) {
        newStreak += 1;
      } else if (habit.lastCompletedDate == todayString) {
        // Zaten bugün yapılmıştı, seriyi koru
      } else {
        // İlk tamamlama veya kırılmış seriden sonraki ilk gün
        newStreak = 1;
      }
    }

    final newLongest = max(habit.longestStreak, newStreak);

    _habits[habitIndex] = habit.copyWith(
      currentStreak: newStreak,
      longestStreak: newLongest,
      lastCompletedDate: newLastCompletedDate,
    );

    // 4. Update Badges & Watch Stats
    if (_isWatchConnected && caloriesBurned > 0) {
      _simulatedActiveCaloriesBurned += caloriesBurned;
      _lastWatchSync = DateTime.now();
    }

    _evaluateBadges();
    await _saveToPrefs();
    notifyListeners();
  }

  // --- STREAK ENGINE & INTEGRITY (ilerlemeskill.md) ---

  int calculateHabitStreak(String habitId) {
    final habitIndex = _habits.indexWhere((h) => h.id == habitId);
    if (habitIndex == -1) return 0;
    final habit = _habits[habitIndex];

    final now = currentDateTime;
    int streak = 0;

    // Check today
    final todayStr = _formatDate(now);
    final todayLogs = _activityLogs.where((l) => l.habitId == habitId && l.date == todayStr).toList();
    final isDoneToday = todayLogs.isNotEmpty &&
        (habit.category != 'quit_smoking' || (todayLogs.first.smokedCount ?? 0) == 0);

    int startOffset = 0;
    if (!isDoneToday) {
      // If not done today, check if yesterday was done
      final yestStr = _formatDate(now.subtract(const Duration(days: 1)));
      final yestLogs = _activityLogs.where((l) => l.habitId == habitId && l.date == yestStr).toList();
      final isDoneYest = yestLogs.isNotEmpty &&
          (habit.category != 'quit_smoking' || (yestLogs.first.smokedCount ?? 0) == 0);

      if (!isDoneYest) {
        return 0; // Missed yesterday and not done today
      }
      startOffset = 1;
    }

    // Count consecutive days backward
    for (int i = startOffset; i < 365; i++) {
      final checkDate = _formatDate(now.subtract(Duration(days: i)));
      final dayLogs = _activityLogs.where((l) => l.habitId == habitId && l.date == checkDate).toList();
      final isDone = dayLogs.isNotEmpty &&
          (habit.category != 'quit_smoking' || (dayLogs.first.smokedCount ?? 0) == 0);

      if (isDone) {
        streak++;
      } else {
        break;
      }
    }

    return streak;
  }

  void _ensureStreakLogsConsistency() {
    final now = currentDateTime;

    for (int hIdx = 0; hIdx < _habits.length; hIdx++) {
      final habit = _habits[hIdx];
      int requiredStreak = habit.currentStreak;
      // Su alışkanlığında en az 10 günlük seriyi güvence altına al
      if (habit.id == 'habit_water' && requiredStreak < 10) {
        requiredStreak = 10;
        _habits[hIdx] = habit.copyWith(
          currentStreak: 10,
          longestStreak: max(habit.longestStreak, 14),
          lastCompletedDate: todayString,
        );
      }

      if (requiredStreak > 0) {
        final lastDate = habit.lastCompletedDate ?? todayString;
        final isTodayCompleted = lastDate == todayString;
        final startOffset = isTodayCompleted ? 0 : 1;

        for (int i = 0; i < requiredStreak; i++) {
          final targetDate = _formatDate(now.subtract(Duration(days: startOffset + i)));
          final existingLogIndex = _activityLogs.indexWhere(
            (l) => l.habitId == habit.id && l.date == targetDate,
          );

          if (existingLogIndex == -1) {
            _activityLogs.add(ActivityLogModel(
              id: 'sync_log_${habit.id}_$targetDate',
              habitId: habit.id,
              category: habit.category,
              date: targetDate,
              waterLiters: habit.category == 'water' ? (2.5 + ((i % 3) * 0.3)) : null,
              smokedCount: habit.category == 'quit_smoking' ? 0 : null,
              avoidedCount: habit.category == 'quit_smoking' ? 20 : null,
              moneySavedTL: habit.category == 'quit_smoking' ? 75.0 : null,
              distanceKm: habit.category == 'running' ? (4.5 + ((i % 3) * 0.5)) : null,
              durationMinutes: (habit.category == 'swimming' || habit.category == 'fitness') ? 45 : null,
              caloriesBurned: habit.category == 'running'
                  ? 320.0
                  : (habit.category == 'swimming' ? 380.0 : null),
              pagesRead: habit.category == 'reading' ? (25 + ((i % 3) * 5)) : null,
              bookGenre: habit.category == 'reading' ? 'Kişisel Gelişim' : null,
            ));
          }
        }
      }
    }
  }

  void _checkStreakIntegrity() {
    final today = todayString;
    final yesterday = yesterdayString;

    for (int i = 0; i < _habits.length; i++) {
      final h = _habits[i];
      if (h.lastCompletedDate != null &&
          h.lastCompletedDate != today &&
          h.lastCompletedDate != yesterday) {
        // More than 1 day missed: streak broken
        _habits[i] = h.copyWith(currentStreak: 0);
      }
    }
  }

  // --- SMART WATCH SKILL (watchskill.md) ---

  void toggleWatchConnection() {
    _isWatchConnected = !_isWatchConnected;
    if (_currentUser != null) {
      _currentUser = _currentUser!.copyWith(isWatchConnected: _isWatchConnected);
    }

    if (_isWatchConnected) {
      _lastWatchSync = DateTime.now();
      _startWatchSimulation();
    } else {
      _watchTimer?.cancel();
    }

    _saveToPrefs();
    notifyListeners();
  }

  void _startWatchSimulation() {
    _watchTimer?.cancel();
    _watchTimer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (!_isWatchConnected) {
        timer.cancel();
        return;
      }
      final rnd = Random();
      _simulatedHeartRate = 70 + rnd.nextInt(25);
      _simulatedActiveCaloriesBurned += (rnd.nextDouble() * 1.5);
      _simulatedSteps += (rnd.nextInt(6) + 1);
      _lastWatchSync = DateTime.now();
      notifyListeners();
    });
  }

  // --- BADGE EVALUATION MOTOR (rozetskill.md) ---

  void _evaluateBadges() {
    // 1. Reading Totals
    int totalBooksFinished = _activityLogs.where((l) => l.isBookFinished == true).length;
    double totalPagesRead = _activityLogs.fold(0.0, (acc, l) => acc + (l.pagesRead ?? 0));

    // 2. Swimming Totals
    double totalSwimMinutes = _activityLogs
        .where((l) => l.category == 'swimming')
        .fold(0.0, (acc, l) => acc + (l.durationMinutes ?? 0));

    // 3. Running Totals
    double totalRunKm = _activityLogs
        .where((l) => l.category == 'running')
        .fold(0.0, (acc, l) => acc + (l.distanceKm ?? 0.0));

    // 4. Water Totals
    double totalWaterLiters = _activityLogs
        .where((l) => l.category == 'water')
        .fold(0.0, (acc, l) => acc + (l.waterLiters ?? 0.0));

    // 5. Fitness Totals
    double totalFitnessMinutes = _activityLogs
        .where((l) => l.category == 'fitness')
        .fold(0.0, (acc, l) => acc + (l.durationMinutes ?? 0));

    // 6. Healthy Calories Saved
    double totalCaloriesSaved = _activityLogs
        .where((l) => l.category == 'healthy_food')
        .fold(0.0, (acc, l) => acc + (l.caloriesSaved ?? 0.0));

    // 7. Smoking Avoided
    double totalSmokingAvoided = _activityLogs
        .where((l) => l.category == 'quit_smoking')
        .fold(0.0, (acc, l) => acc + (l.avoidedCount ?? 0));

    // 8. Money Saved Total (Smoking + Alcohol)
    double totalMoneySaved = _activityLogs.fold(0.0, (acc, l) => acc + (l.moneySavedTL ?? 0.0));

    // 9. Streaks
    int maxStreakAcrossHabits = _habits.fold(0, (maxVal, h) => max(maxVal, h.longestStreak));

    // 10. Mind games
    double totalMindMinutes = _activityLogs
        .where((l) => l.category == 'mind_games')
        .fold(0.0, (acc, l) => acc + (l.durationMinutes ?? 0));

    final now = currentDateTime;

    for (int i = 0; i < _badges.length; i++) {
      final badge = _badges[i];
      double currentVal = 0.0;

      switch (badge.id) {
        case 'gold_librarian_100':
          currentVal = totalBooksFinished.toDouble();
          break;
        case 'bronze_reader_10':
          currentVal = totalBooksFinished.toDouble();
          break;
        case 'silver_bookworm_50':
          currentVal = totalBooksFinished.toDouble();
          break;
        case 'page_master_5000':
          currentVal = totalPagesRead;
          break;
        case 'blue_dolphin_500':
          currentVal = totalSwimMinutes;
          break;
        case 'poseidon_2000':
          currentVal = totalSwimMinutes;
          break;
        case 'marathoner_100':
          currentVal = totalRunKm;
          break;
        case 'source_of_life_100':
          currentVal = totalWaterLiters;
          break;
        case 'iron_will_1500':
          currentVal = totalFitnessMinutes;
          break;
        case 'calorie_hunter_10000':
          currentVal = totalCaloriesSaved;
          break;
        case 'clean_breath_500':
          currentVal = totalSmokingAvoided;
          break;
        case 'piggy_bank_master_5000':
          currentVal = totalMoneySaved;
          break;
        case 'chain_breaker_7':
          currentVal = maxStreakAcrossHabits.toDouble();
          break;
        case 'habit_master_30':
          currentVal = maxStreakAcrossHabits.toDouble();
          break;
        case 'mind_master_300':
          currentVal = totalMindMinutes;
          break;
      }

      final bool isUnlockedNow = currentVal >= badge.targetValue;
      final DateTime? unlockedTime = isUnlockedNow
          ? (badge.unlockedAt ?? now)
          : null;

      _badges[i] = badge.copyWith(
        currentValue: currentVal,
        isUnlocked: isUnlockedNow,
        unlockedAt: unlockedTime,
      );
    }
  }

  // --- STATS COMPUTATIONS (profilskill.md) ---

  double get totalMoneySaved =>
      _activityLogs.fold(0.0, (acc, l) => acc + (l.moneySavedTL ?? 0.0));

  double get totalCaloriesBurned =>
      _activityLogs.fold(0.0, (acc, l) => acc + (l.caloriesBurned ?? 0.0));

  double get totalCaloriesSaved =>
      _activityLogs.fold(0.0, (acc, l) => acc + (l.caloriesSaved ?? 0.0));

  int get maxStreakRecord =>
      _habits.fold(0, (maxVal, h) => max(maxVal, h.longestStreak));

  int get totalCompletedActivities => _activityLogs.length;

  int get unlockedBadgeCount => _badges.where((b) => b.isUnlocked).length;

  // --- CALENDAR LOG QUERY (takvimpointerskill.md) ---

  List<ActivityLogModel> getLogsForDate(String yyyyMmDd) {
    return _activityLogs.where((l) => l.date == yyyyMmDd).toList();
  }

  // --- RESET / LOAD DEMO DATA ---

  Future<void> loadSampleData() async {
    if (_currentUser == null) return;
    _habits = _createInitialDefaultHabits(_currentUser!.uid);
    _activityLogs = _createSampleActivityLogs(_currentUser!.uid, _habits);
    _badges = _createInitialBadges();
    _checkStreakIntegrity();
    _evaluateBadges();
    await _saveToPrefs();
    notifyListeners();
  }

  // --- LOCAL PERSISTENCE ---

  Future<void> _saveToPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      if (_currentUser != null) {
        await prefs.setString('current_user', jsonEncode(_currentUser!.toJson()));
      }
      final habitsJson = jsonEncode(_habits.map((h) => h.toJson()).toList());
      await prefs.setString('habits', habitsJson);

      final logsJson = jsonEncode(_activityLogs.map((l) => l.toJson()).toList());
      await prefs.setString('activity_logs', logsJson);

      final badgesJson = jsonEncode(_badges.map((b) => b.toJson()).toList());
      await prefs.setString('badges', badgesJson);

      if (_simulatedDateTime != null) {
        await prefs.setString('simulated_datetime', _simulatedDateTime!.toIso8601String());
      } else {
        await prefs.remove('simulated_datetime');
      }

      final notifsJson = jsonEncode(_notifications.map((n) => n.toJson()).toList());
      await prefs.setString('notifications', notifsJson);
    } catch (e) {
      debugPrint('Prefs Save Error: $e');
    }
  }

  Future<void> _loadFromPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userStr = prefs.getString('current_user');
      if (userStr != null) {
        _currentUser = UserModel.fromJson(jsonDecode(userStr) as Map<String, dynamic>);
      } else {
        // First boot default demo user
        _currentUser = UserModel(
          uid: 'user_demo',
          email: 'berat@habitchain.com',
          fullName: 'Demir Kaya',
          age: 26,
          gender: 'male',
          avatarId: AvatarService.getAvatarId(26, 'male'),
          isWatchConnected: false,
        );
      }

      final habitsStr = prefs.getString('habits');
      if (habitsStr != null) {
        final List list = jsonDecode(habitsStr) as List;
        _habits = list.map((item) => HabitModel.fromJson(item as Map<String, dynamic>)).toList();
      } else {
        _habits = _createInitialDefaultHabits(_currentUser!.uid);
      }

      final logsStr = prefs.getString('activity_logs');
      if (logsStr != null) {
        final List list = jsonDecode(logsStr) as List;
        _activityLogs = list.map((item) => ActivityLogModel.fromJson(item as Map<String, dynamic>)).toList();
      } else {
        _activityLogs = _createSampleActivityLogs(_currentUser!.uid, _habits);
      }

      final badgesStr = prefs.getString('badges');
      if (badgesStr != null) {
        final List list = jsonDecode(badgesStr) as List;
        _badges = list.map((item) => BadgeModel.fromJson(item as Map<String, dynamic>)).toList();
      } else {
        _badges = _createInitialBadges();
      }

      final simDateStr = prefs.getString('simulated_datetime');
      if (simDateStr != null) {
        _simulatedDateTime = DateTime.tryParse(simDateStr);
      }

      final notifsStr = prefs.getString('notifications');
      if (notifsStr != null) {
        final List list = jsonDecode(notifsStr) as List;
        _notifications = list.map((item) => AppNotificationModel.fromJson(item as Map<String, dynamic>)).toList();
      }

      _checkStreakIntegrity();
      _ensureStreakLogsConsistency();
      _evaluateBadges();
    } catch (e) {
      debugPrint('Prefs Load Error: $e');
      _currentUser = UserModel(
        uid: 'user_demo',
        email: 'berat@habitchain.com',
        fullName: 'Demir Kaya',
        age: 26,
        gender: 'male',
        avatarId: AvatarService.getAvatarId(26, 'male'),
      );
      _habits = _createInitialDefaultHabits(_currentUser!.uid);
      _badges = _createInitialBadges();
      _activityLogs = _createSampleActivityLogs(_currentUser!.uid, _habits);
      _ensureStreakLogsConsistency();
      _evaluateBadges();
    }
  }

  // --- INITIAL DATA SEEDERS ---

  List<HabitModel> _createInitialDefaultHabits(String userId) {
    return [
      HabitModel(
        id: 'habit_swim',
        userId: userId,
        title: 'Yüzme',
        category: 'swimming',
        colorHex: '#2196F3',
        animationAsset: '',
        currentStreak: 4,
        longestStreak: 7,
        lastCompletedDate: todayString,
      ),
      HabitModel(
        id: 'habit_run',
        userId: userId,
        title: 'Sabah Koşusu',
        category: 'running',
        colorHex: '#4CAF50',
        animationAsset: '',
        currentStreak: 5,
        longestStreak: 9,
        lastCompletedDate: todayString,
      ),
      HabitModel(
        id: 'habit_book',
        userId: userId,
        title: 'Kitap Okuma',
        category: 'reading',
        colorHex: '#FFB300',
        animationAsset: '',
        currentStreak: 3,
        longestStreak: 12,
        lastCompletedDate: yesterdayString,
      ),
      HabitModel(
        id: 'habit_water',
        userId: userId,
        title: 'Günlük Su Tüketimi',
        category: 'water',
        colorHex: '#03A9F4',
        animationAsset: '',
        currentStreak: 10,
        longestStreak: 14,
        lastCompletedDate: todayString,
      ),
      HabitModel(
        id: 'habit_smoke',
        userId: userId,
        title: 'Sigara Bırakma',
        category: 'quit_smoking',
        colorHex: '#E91E63',
        animationAsset: '',
        currentStreak: 11,
        longestStreak: 11,
        lastCompletedDate: todayString,
      ),
    ];
  }

  List<ActivityLogModel> _createSampleActivityLogs(String userId, List<HabitModel> habits) {
    final now = DateTime.now();
    final List<ActivityLogModel> sampleLogs = [];

    // --- DAY 0 (Bugün): 4'lü Usta Serisi (Yüzme + Koşu + Su + Sigara Bırakma) ---
    sampleLogs.add(ActivityLogModel(
      id: 'sample_d0_swim',
      habitId: 'habit_swim',
      category: 'swimming',
      date: _formatDate(now),
      durationMinutes: 45,
      caloriesBurned: 382.5,
    ));
    sampleLogs.add(ActivityLogModel(
      id: 'sample_d0_run',
      habitId: 'habit_run',
      category: 'running',
      date: _formatDate(now),
      distanceKm: 6.0,
      caloriesBurned: 390.0,
    ));
    sampleLogs.add(ActivityLogModel(
      id: 'sample_d0_water',
      habitId: 'habit_water',
      category: 'water',
      date: _formatDate(now),
      waterLiters: 2.5,
    ));
    sampleLogs.add(ActivityLogModel(
      id: 'sample_d0_smoke',
      habitId: 'habit_smoke',
      category: 'quit_smoking',
      date: _formatDate(now),
      smokedCount: 0,
      avoidedCount: 20,
      moneySavedTL: 75.0,
    ));

    // --- DAY 1 (Dün): Kitap + Koşu + Yüzme + Su + Sigara Bırakma ---
    final day1 = now.subtract(const Duration(days: 1));
    sampleLogs.add(ActivityLogModel(
      id: 'sample_d1_book',
      habitId: 'habit_book',
      category: 'reading',
      date: _formatDate(day1),
      pagesRead: 35,
      bookTotalPages: 280,
      bookGenre: 'Bilim Kurgu',
      isBookFinished: false,
    ));
    sampleLogs.add(ActivityLogModel(
      id: 'sample_d1_run',
      habitId: 'habit_run',
      category: 'running',
      date: _formatDate(day1),
      distanceKm: 5.0,
      caloriesBurned: 325.0,
    ));
    sampleLogs.add(ActivityLogModel(
      id: 'sample_d1_swim',
      habitId: 'habit_swim',
      category: 'swimming',
      date: _formatDate(day1),
      durationMinutes: 40,
      caloriesBurned: 340.0,
    ));
    sampleLogs.add(ActivityLogModel(
      id: 'sample_d1_water',
      habitId: 'habit_water',
      category: 'water',
      date: _formatDate(day1),
      waterLiters: 3.0,
    ));
    sampleLogs.add(ActivityLogModel(
      id: 'sample_d1_smoke',
      habitId: 'habit_smoke',
      category: 'quit_smoking',
      date: _formatDate(day1),
      smokedCount: 0,
      avoidedCount: 20,
      moneySavedTL: 75.0,
    ));

    // --- DAY 2 (2 gün önce): Yüzme + Koşu + Kitap + Su + Sigara Bırakma ---
    final day2 = now.subtract(const Duration(days: 2));
    sampleLogs.add(ActivityLogModel(
      id: 'sample_d2_swim',
      habitId: 'habit_swim',
      category: 'swimming',
      date: _formatDate(day2),
      durationMinutes: 50,
      caloriesBurned: 425.0,
    ));
    sampleLogs.add(ActivityLogModel(
      id: 'sample_d2_run',
      habitId: 'habit_run',
      category: 'running',
      date: _formatDate(day2),
      distanceKm: 4.5,
      caloriesBurned: 292.5,
    ));
    sampleLogs.add(ActivityLogModel(
      id: 'sample_d2_book',
      habitId: 'habit_book',
      category: 'reading',
      date: _formatDate(day2),
      pagesRead: 30,
      bookGenre: 'Kişisel Gelişim',
    ));
    sampleLogs.add(ActivityLogModel(
      id: 'sample_d2_water',
      habitId: 'habit_water',
      category: 'water',
      date: _formatDate(day2),
      waterLiters: 2.8,
    ));
    sampleLogs.add(ActivityLogModel(
      id: 'sample_d2_smoke',
      habitId: 'habit_smoke',
      category: 'quit_smoking',
      date: _formatDate(day2),
      smokedCount: 0,
      avoidedCount: 20,
      moneySavedTL: 75.0,
    ));

    // --- DAY 3 (3 gün önce): Koşu + Yüzme + Kitap + Su + Sigara Bırakma ---
    final day3 = now.subtract(const Duration(days: 3));
    sampleLogs.add(ActivityLogModel(
      id: 'sample_d3_run',
      habitId: 'habit_run',
      category: 'running',
      date: _formatDate(day3),
      distanceKm: 5.5,
      caloriesBurned: 357.5,
    ));
    sampleLogs.add(ActivityLogModel(
      id: 'sample_d3_swim',
      habitId: 'habit_swim',
      category: 'swimming',
      date: _formatDate(day3),
      durationMinutes: 45,
      caloriesBurned: 382.5,
    ));
    sampleLogs.add(ActivityLogModel(
      id: 'sample_d3_book',
      habitId: 'habit_book',
      category: 'reading',
      date: _formatDate(day3),
      pagesRead: 40,
      bookGenre: 'Psikoloji',
    ));
    sampleLogs.add(ActivityLogModel(
      id: 'sample_d3_water',
      habitId: 'habit_water',
      category: 'water',
      date: _formatDate(day3),
      waterLiters: 2.5,
    ));
    sampleLogs.add(ActivityLogModel(
      id: 'sample_d3_smoke',
      habitId: 'habit_smoke',
      category: 'quit_smoking',
      date: _formatDate(day3),
      smokedCount: 0,
      avoidedCount: 20,
      moneySavedTL: 75.0,
    ));

    // --- DAY 4 (4 gün önce): Koşu + Su + Sigara Bırakma (Koşu serisi 5. gün) ---
    final day4 = now.subtract(const Duration(days: 4));
    sampleLogs.add(ActivityLogModel(
      id: 'sample_d4_run',
      habitId: 'habit_run',
      category: 'running',
      date: _formatDate(day4),
      distanceKm: 4.5,
      caloriesBurned: 292.5,
    ));
    sampleLogs.add(ActivityLogModel(
      id: 'sample_d4_water',
      habitId: 'habit_water',
      category: 'water',
      date: _formatDate(day4),
      waterLiters: 3.0,
    ));
    sampleLogs.add(ActivityLogModel(
      id: 'sample_d4_smoke',
      habitId: 'habit_smoke',
      category: 'quit_smoking',
      date: _formatDate(day4),
      smokedCount: 0,
      avoidedCount: 20,
      moneySavedTL: 75.0,
    ));

    // --- DAY 5 (5 gün önce): Kitap + Su + Sigara Bırakma ---
    final day5 = now.subtract(const Duration(days: 5));
    sampleLogs.add(ActivityLogModel(
      id: 'sample_d5_book',
      habitId: 'habit_book',
      category: 'reading',
      date: _formatDate(day5),
      pagesRead: 50,
      bookTotalPages: 50,
      bookGenre: 'Roman',
      isBookFinished: true,
    ));
    sampleLogs.add(ActivityLogModel(
      id: 'sample_d5_water',
      habitId: 'habit_water',
      category: 'water',
      date: _formatDate(day5),
      waterLiters: 2.7,
    ));
    sampleLogs.add(ActivityLogModel(
      id: 'sample_d5_smoke',
      habitId: 'habit_smoke',
      category: 'quit_smoking',
      date: _formatDate(day5),
      smokedCount: 0,
      avoidedCount: 20,
      moneySavedTL: 75.0,
    ));

    // --- DAY 6 (6 gün önce): Koşu + Kitap + Su + Sigara Bırakma ---
    final day6 = now.subtract(const Duration(days: 6));
    sampleLogs.add(ActivityLogModel(
      id: 'sample_d6_run',
      habitId: 'habit_run',
      category: 'running',
      date: _formatDate(day6),
      distanceKm: 4.8,
      caloriesBurned: 312.0,
    ));
    sampleLogs.add(ActivityLogModel(
      id: 'sample_d6_book',
      habitId: 'habit_book',
      category: 'reading',
      date: _formatDate(day6),
      pagesRead: 40,
      bookTotalPages: 250,
      bookGenre: 'Felsefe',
    ));
    sampleLogs.add(ActivityLogModel(
      id: 'sample_d6_water',
      habitId: 'habit_water',
      category: 'water',
      date: _formatDate(day6),
      waterLiters: 2.5,
    ));
    sampleLogs.add(ActivityLogModel(
      id: 'sample_d6_smoke',
      habitId: 'habit_smoke',
      category: 'quit_smoking',
      date: _formatDate(day6),
      smokedCount: 0,
      avoidedCount: 20,
      moneySavedTL: 75.0,
    ));

    // --- DAY 7 (7 gün önce): Fitness + Su + Sigara Bırakma ---
    final day7 = now.subtract(const Duration(days: 7));
    sampleLogs.add(ActivityLogModel(
      id: 'sample_d7_fit',
      habitId: 'habit_fit',
      category: 'fitness',
      date: _formatDate(day7),
      durationMinutes: 45,
      caloriesBurned: 380.0,
    ));
    sampleLogs.add(ActivityLogModel(
      id: 'sample_d7_water',
      habitId: 'habit_water',
      category: 'water',
      date: _formatDate(day7),
      waterLiters: 3.2,
    ));
    sampleLogs.add(ActivityLogModel(
      id: 'sample_d7_smoke',
      habitId: 'habit_smoke',
      category: 'quit_smoking',
      date: _formatDate(day7),
      smokedCount: 0,
      avoidedCount: 20,
      moneySavedTL: 75.0,
    ));

    // --- DAY 8 (8 gün önce): Kitap + Zeka + Su + Sigara Bırakma ---
    final day8 = now.subtract(const Duration(days: 8));
    sampleLogs.add(ActivityLogModel(
      id: 'sample_d8_book',
      habitId: 'habit_book',
      category: 'reading',
      date: _formatDate(day8),
      pagesRead: 30,
      bookGenre: 'Bilim',
    ));
    sampleLogs.add(ActivityLogModel(
      id: 'sample_d8_mind',
      habitId: 'habit_mind',
      category: 'mind_games',
      date: _formatDate(day8),
      durationMinutes: 35,
      bookGenre: 'Satranç',
    ));
    sampleLogs.add(ActivityLogModel(
      id: 'sample_d8_water',
      habitId: 'habit_water',
      category: 'water',
      date: _formatDate(day8),
      waterLiters: 2.6,
    ));
    sampleLogs.add(ActivityLogModel(
      id: 'sample_d8_smoke',
      habitId: 'habit_smoke',
      category: 'quit_smoking',
      date: _formatDate(day8),
      smokedCount: 0,
      avoidedCount: 20,
      moneySavedTL: 75.0,
    ));

    // --- DAY 9 (9 gün önce): Koşu + Beslenme + Su + Sigara Bırakma (Su serisi 10. gün) ---
    final day9 = now.subtract(const Duration(days: 9));
    sampleLogs.add(ActivityLogModel(
      id: 'sample_d9_run',
      habitId: 'habit_run',
      category: 'running',
      date: _formatDate(day9),
      distanceKm: 5.0,
      caloriesBurned: 325.0,
    ));
    sampleLogs.add(ActivityLogModel(
      id: 'sample_d9_food',
      habitId: 'habit_food',
      category: 'healthy_food',
      date: _formatDate(day9),
      mealCalories: 450,
      caloriesSaved: 350.0,
    ));
    sampleLogs.add(ActivityLogModel(
      id: 'sample_d9_water',
      habitId: 'habit_water',
      category: 'water',
      date: _formatDate(day9),
      waterLiters: 2.8,
    ));
    sampleLogs.add(ActivityLogModel(
      id: 'sample_d9_smoke',
      habitId: 'habit_smoke',
      category: 'quit_smoking',
      date: _formatDate(day9),
      smokedCount: 0,
      avoidedCount: 20,
      moneySavedTL: 75.0,
    ));

    // --- DAY 10 (10 gün önce): Fitness + Su + Sigara Bırakma (Sigara serisi 11. gün) ---
    final day10 = now.subtract(const Duration(days: 10));
    sampleLogs.add(ActivityLogModel(
      id: 'sample_d10_fit',
      habitId: 'habit_fit',
      category: 'fitness',
      date: _formatDate(day10),
      durationMinutes: 40,
      caloriesBurned: 340.0,
    ));
    sampleLogs.add(ActivityLogModel(
      id: 'sample_d10_water',
      habitId: 'habit_water',
      category: 'water',
      date: _formatDate(day10),
      waterLiters: 3.0,
    ));
    sampleLogs.add(ActivityLogModel(
      id: 'sample_d10_smoke',
      habitId: 'habit_smoke',
      category: 'quit_smoking',
      date: _formatDate(day10),
      smokedCount: 0,
      avoidedCount: 20,
      moneySavedTL: 75.0,
    ));

    // --- DAY 11 (11 gün önce): Koşu + Fitness ---
    final day11 = now.subtract(const Duration(days: 11));
    sampleLogs.add(ActivityLogModel(
      id: 'sample_d11_run',
      habitId: 'habit_run',
      category: 'running',
      date: _formatDate(day11),
      distanceKm: 4.2,
      caloriesBurned: 273.0,
    ));

    // --- DAY 12 (12 gün önce): Yüzme + Su ---
    final day12 = now.subtract(const Duration(days: 12));
    sampleLogs.add(ActivityLogModel(
      id: 'sample_d12_swim',
      habitId: 'habit_swim',
      category: 'swimming',
      date: _formatDate(day12),
      durationMinutes: 45,
      caloriesBurned: 382.5,
    ));
    sampleLogs.add(ActivityLogModel(
      id: 'sample_d12_water',
      habitId: 'habit_water',
      category: 'water',
      date: _formatDate(day12),
      waterLiters: 2.5,
    ));

    // Earlier days: routine healthy living logs
    for (int i = 14; i <= 26; i += 3) {
      final pastDate = now.subtract(Duration(days: i));
      sampleLogs.add(ActivityLogModel(
        id: 'sample_past_$i',
        habitId: 'habit_water',
        category: 'water',
        date: _formatDate(pastDate),
        waterLiters: 2.5,
      ));
    }

    return sampleLogs;
  }

  List<BadgeModel> _createInitialBadges() {
    return [
      BadgeModel(
        id: 'gold_librarian_100',
        title: 'Altın Kütüphaneci',
        description: '100 adet kitap bitirerek tam bir kütüphane kurun.',
        category: 'reading',
        tier: 'gold',
        targetValue: 100,
        currentValue: 1,
        unit: 'Kitap',
      ),
      BadgeModel(
        id: 'bronze_reader_10',
        title: 'Bronz Okur',
        description: '10 adet kitap bitirin ve okuma serüveninizi başlatın.',
        category: 'reading',
        tier: 'bronze',
        targetValue: 10,
        currentValue: 1,
        unit: 'Kitap',
      ),
      BadgeModel(
        id: 'silver_bookworm_50',
        title: 'Gümüş Kitap Kurdu',
        description: '50 adet kitap bitirerek bilgi haznenizi büyütün.',
        category: 'reading',
        tier: 'silver',
        targetValue: 50,
        currentValue: 1,
        unit: 'Kitap',
      ),
      BadgeModel(
        id: 'page_master_5000',
        title: 'Sayfa Ustası',
        description: 'Toplam 5.000 sayfa kitap okuyun.',
        category: 'reading',
        tier: 'silver',
        targetValue: 5000,
        currentValue: 85,
        unit: 'Sayfa',
      ),
      BadgeModel(
        id: 'blue_dolphin_500',
        title: 'Mavi Yunus',
        description: 'Toplam 500 dakika yüzerek suyla bütünleşin.',
        category: 'swimming',
        tier: 'silver',
        targetValue: 500,
        currentValue: 135,
        unit: 'Dakika',
      ),
      BadgeModel(
        id: 'poseidon_2000',
        title: 'Poseidon',
        description: 'Toplam 2.000 dakika yüzerek dalgaların efendisi olun.',
        category: 'swimming',
        tier: 'gold',
        targetValue: 2000,
        currentValue: 135,
        unit: 'Dakika',
      ),
      BadgeModel(
        id: 'marathoner_100',
        title: 'Maratoncu',
        description: 'Toplam 100 km koşarak sınırlarınızı aşın.',
        category: 'running',
        tier: 'gold',
        targetValue: 100,
        currentValue: 16.0,
        unit: 'Km',
      ),
      BadgeModel(
        id: 'source_of_life_100',
        title: 'Hayat Kaynağı',
        description: 'Toplam 100 Litre su içerek vücudunuzu yenileyin.',
        category: 'water',
        tier: 'gold',
        targetValue: 100,
        currentValue: 28.5,
        unit: 'Litre',
      ),
      BadgeModel(
        id: 'iron_will_1500',
        title: 'Demir İrade',
        description: 'Toplam 1.500 dakika fitness egzersizi yapın.',
        category: 'fitness',
        tier: 'gold',
        targetValue: 1500,
        currentValue: 0,
        unit: 'Dakika',
      ),
      BadgeModel(
        id: 'calorie_hunter_10000',
        title: 'Kalori Avcısı',
        description: 'Sağlıklı öğünlerle 10.000 kcal kalori tasarrufu sağlayın.',
        category: 'healthy_food',
        tier: 'gold',
        targetValue: 10000,
        currentValue: 0,
        unit: 'kcal',
      ),
      BadgeModel(
        id: 'clean_breath_500',
        title: 'Temiz Nefes',
        description: 'Toplam 500 dal sigara içmeyerek ciğerlerinizi koruyun.',
        category: 'quit_smoking',
        tier: 'gold',
        targetValue: 500,
        currentValue: 220,
        unit: 'Dal',
      ),
      BadgeModel(
        id: 'piggy_bank_master_5000',
        title: 'Kumbara Ustası',
        description: 'Zararlı alışkanlıklardan vazgeçerek 5.000 TL biriktirin.',
        category: 'quit_smoking',
        tier: 'gold',
        targetValue: 5000,
        currentValue: 825.0,
        unit: 'TL',
      ),
      BadgeModel(
        id: 'chain_breaker_7',
        title: 'Zinciri Kırma',
        description: 'Herhangi bir alışkanlıkta 7 günlük kesintisiz seri yapın.',
        category: 'streak',
        tier: 'silver',
        targetValue: 7,
        currentValue: 14,
        unit: 'Gün',
        isUnlocked: true,
      ),
      BadgeModel(
        id: 'habit_master_30',
        title: 'Alışkanlık Efendisi',
        description: '30 günlük kesintisiz seri ile alışkanlığı hayat tarzı yapın.',
        category: 'streak',
        tier: 'gold',
        targetValue: 30,
        currentValue: 14,
        unit: 'Gün',
      ),
      BadgeModel(
        id: 'mind_master_300',
        title: 'Zeka Ustası',
        description: 'Satranç ve zeka oyunlarına 300 dakika ayırın.',
        category: 'mind_games',
        tier: 'silver',
        targetValue: 300,
        currentValue: 0,
        unit: 'Dakika',
      ),
    ];
  }

  @override
  void dispose() {
    _watchTimer?.cancel();
    super.dispose();
  }
}
