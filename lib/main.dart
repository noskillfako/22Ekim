import 'package:flutter/material.dart';
import 'screens/auth_screen.dart';
import 'screens/main_navigation_screen.dart';
import 'services/app_state.dart';
import 'theme/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Global Error Boundary (errorskill.md rule 4)
  ErrorWidget.builder = (FlutterErrorDetails details) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.error.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.warning_amber_rounded, size: 48, color: AppTheme.error),
              ),
              const SizedBox(height: 16),
              const Text(
                'Bir şeyler ters gitti',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Lütfen sayfayı yenileyin veya uygulamayı tekrar başlatın.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 13, color: AppTheme.textSecondary),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: () {
                  // Reload logic
                },
                icon: const Icon(Icons.refresh_rounded),
                label: const Text('Yenile'),
              ),
            ],
          ),
        ),
      ),
    );
  };

  runApp(const HabitChainApp());
}

class HabitChainApp extends StatefulWidget {
  const HabitChainApp({super.key});

  @override
  State<HabitChainApp> createState() => _HabitChainAppState();
}

class _HabitChainAppState extends State<HabitChainApp> {
  late final AppState _appState;

  @override
  void initState() {
    super.initState();
    _appState = AppState();
  }

  @override
  void dispose() {
    _appState.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HabitChain & Wellness Tracker',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: ListenableBuilder(
        listenable: _appState,
        builder: (context, _) {
          if (_appState.isLoading) {
            return const Scaffold(
              backgroundColor: AppTheme.background,
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }

          if (!_appState.isLoggedIn) {
            return AuthScreen(state: _appState);
          }

          return MainNavigationScreen(
            state: _appState,
            onLogout: () => _appState.logout(),
          );
        },
      ),
    );
  }
}
