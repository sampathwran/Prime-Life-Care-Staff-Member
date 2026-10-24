import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/language_provider.dart';
import '../theme/app_theme.dart';
import 'home_duty_view.dart';
import 'vitals_logger_view.dart';
import 'daily_routine_view.dart';
import 'my_shifts_view.dart';
import 'profile_earnings_view.dart';

class MainNavigationWrapper extends StatefulWidget {
  const MainNavigationWrapper({super.key});

  @override
  State<MainNavigationWrapper> createState() => _MainNavigationWrapperState();
}

class _MainNavigationWrapperState extends State<MainNavigationWrapper> {
  int _currentIndex = 0;

  void _onSelectTab(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _onOpenProfile() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const ProfileEarningsView()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final langProvider = context.watch<LanguageProvider>();
    final strings = langProvider.strings;

    final List<Widget> pages = [
      HomeDutyView(
        onNavigateTab: _onSelectTab,
        onOpenProfile: _onOpenProfile,
      ),
      const VitalsLoggerView(),
      const DailyRoutineView(),
      const MyShiftsView(),
      const ProfileEarningsView(),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: pages,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            top: BorderSide(color: AppTheme.slate200, width: 1),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: NavigationBar(
          selectedIndex: _currentIndex.clamp(0, 3),
          onDestinationSelected: (idx) {
            setState(() {
              _currentIndex = idx;
            });
          },
          backgroundColor: Colors.white,
          indicatorColor: AppTheme.blueLight,
          elevation: 0,
          destinations: [
            NavigationDestination(
              icon: const Icon(Icons.home_outlined),
              selectedIcon: const Icon(Icons.home_rounded, color: AppTheme.primaryBlue),
              label: strings.navDutyHub,
            ),
            NavigationDestination(
              icon: const Icon(Icons.monitor_heart_outlined),
              selectedIcon: const Icon(Icons.monitor_heart_rounded, color: AppTheme.primaryBlue),
              label: strings.navVitals,
            ),
            NavigationDestination(
              icon: const Icon(Icons.checklist_rounded),
              selectedIcon: const Icon(Icons.checklist_rounded, color: AppTheme.primaryBlue),
              label: strings.navRoutine,
            ),
            NavigationDestination(
              icon: const Icon(Icons.calendar_month_outlined),
              selectedIcon: const Icon(Icons.calendar_month_rounded, color: AppTheme.primaryBlue),
              label: strings.navShifts,
            ),
          ],
        ),
      ),
    );
  }
}
