import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';
import 'scan_page.dart';
import 'whitelist_page.dart';
import 'settings_page.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _currentIndex = 0;

  final _pages = const [ScanPage(), WhitelistPage(), SettingsPage()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _pages),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (i) => setState(() => _currentIndex = i),
        destinations: [
          NavigationDestination(icon: Icon(Icons.search), label: AppLocalizations.of(context)!.navScan),
          NavigationDestination(icon: Icon(Icons.list_alt), label: AppLocalizations.of(context)!.navWhitelist),
          NavigationDestination(icon: Icon(Icons.settings), label: AppLocalizations.of(context)!.navSettings),
        ],
      ),
    );
  }
}
