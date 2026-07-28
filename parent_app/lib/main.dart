import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme.dart';
import 'views/login_screen.dart';
import 'views/home_dashboard.dart';
import 'views/location_screen.dart';
import 'views/screen_mirror_screen.dart';
import 'views/remote_camera_screen.dart';
import 'views/remote_audio_screen.dart';
import 'views/app_usage_screen.dart';
import 'views/screen_time_screen.dart';
import 'views/ai_insights_screen.dart';
import 'views/subscription_screen.dart';
import 'views/pair_child_screen.dart';
import 'views/profile_screen.dart';
import 'views/settings_screen.dart';

void main() {
  runApp(const ProviderScope(child: GuardianXParentApp()));
}

class GuardianXParentApp extends StatelessWidget {
  const GuardianXParentApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GuardianX AI Parent',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: const MainNavigationFrame(),
    );
  }
}

class MainNavigationFrame extends StatefulWidget {
  const MainNavigationFrame({super.key});

  @override
  State<MainNavigationFrame> createState() => _MainNavigationFrameState();
}

class _MainNavigationFrameState extends State<MainNavigationFrame> {
  bool _isLoggedIn = true;
  int _currentIndex = 0;

  void _navigateToTab(int index) {
    setState(() => _currentIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    if (!_isLoggedIn) {
      return LoginView(onLoginSuccess: () => setState(() => _isLoggedIn = true));
    }

    final List<Widget> views = [
      HomeDashboardView(onNavigateTab: _navigateToTab),
      const LocationView(),
      const ScreenMirrorView(),
      const RemoteCameraView(),
      const RemoteAudioView(),
      const AppUsageView(),
      const ScreenTimeView(),
      const AIInsightsView(),
      const SubscriptionView(),
      ProfileView(onLogout: () => setState(() => _isLoggedIn = false)),
      const PairChildView(),
      const SettingsView(),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex < views.length ? _currentIndex : 0,
        children: views,
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: AppTheme.cardDarkBackground,
          border: Border(top: BorderSide(color: Color(0x336C5CE7))),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex < 5 ? _currentIndex : 0,
          onTap: (index) => setState(() => _currentIndex = index),
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.transparent,
          selectedItemColor: AppTheme.accentBlue,
          unselectedItemColor: AppTheme.textSecondary,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.dashboard_rounded), label: 'Dashboard'),
            BottomNavigationBarItem(icon: Icon(Icons.location_on_rounded), label: 'Location'),
            BottomNavigationBarItem(icon: Icon(Icons.screen_share_rounded), label: 'Mirror'),
            BottomNavigationBarItem(icon: Icon(Icons.camera_alt_rounded), label: 'Camera'),
            BottomNavigationBarItem(icon: Icon(Icons.psychology_rounded), label: 'AI Insights'),
          ],
        ),
      ),
    );
  }
}
