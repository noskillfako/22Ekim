import 'package:flutter/material.dart';
import '../services/app_state.dart';
import '../theme/app_theme.dart';
import 'home_screen.dart';
import 'calendar_screen.dart';
import 'smartwatch_screen.dart';
import 'profile_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  final AppState state;
  final VoidCallback onLogout;

  const MainNavigationScreen({
    super.key,
    required this.state,
    required this.onLogout,
  });

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = [
      HomeScreen(
        state: widget.state,
        onNavigateToProfile: () => setState(() => _currentIndex = 3),
      ),
      CalendarScreen(state: widget.state),
      SmartwatchScreen(state: widget.state),
      ProfileScreen(
        state: widget.state,
        onLogout: widget.onLogout,
      ),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: screens,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: const Border(
            top: BorderSide(color: AppTheme.outlineVariant, width: 1),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.check_box_outlined),
              activeIcon: Icon(Icons.check_box_rounded),
              label: 'Alışkanlıklarım',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today_outlined),
              activeIcon: Icon(Icons.calendar_month_rounded),
              label: 'Takvim',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.watch_outlined),
              activeIcon: Icon(Icons.watch_rounded),
              label: 'Akıllı Saat',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline_rounded),
              activeIcon: Icon(Icons.person_rounded),
              label: 'Profil & Rozet',
            ),
          ],
        ),
      ),
    );
  }
}
