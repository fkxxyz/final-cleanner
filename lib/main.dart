import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'l10n/app_localizations.dart';
import 'providers/locale_provider.dart';
import 'ui/pages/app_shell.dart';
import 'ui/pages/disclaimer_page.dart';

void main() {
  runApp(const ProviderScope(child: FinalCleannerApp()));
}

class FinalCleannerApp extends ConsumerStatefulWidget {
  const FinalCleannerApp({super.key});

  @override
  ConsumerState<FinalCleannerApp> createState() => _FinalCleannerAppState();
}

class _FinalCleannerAppState extends ConsumerState<FinalCleannerApp> {
  bool? _disclaimerAgreed;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _checkDisclaimerStatus();
  }

  Future<void> _checkDisclaimerStatus() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final agreed = prefs.getBool('disclaimer_agreed') ?? false;
      setState(() {
        _disclaimerAgreed = agreed;
        _loading = false;
      });
    } catch (e) {
      // On error, show disclaimer (safe default)
      setState(() {
        _disclaimerAgreed = false;
        _loading = false;
      });
    }
  }

  Future<void> _handleAgree() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('disclaimer_agreed', true);
      setState(() {
        _disclaimerAgreed = true;
      });
    } catch (e) {
      // If save fails, still allow access (user agreed)
      setState(() {
        _disclaimerAgreed = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final locale = ref.watch(localeProvider);

    return MaterialApp(
      title: 'Final Cleanner',
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: locale,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: _loading
          ? const Scaffold(body: Center(child: CircularProgressIndicator()))
          : (_disclaimerAgreed == true
                ? const AppShell()
                : DisclaimerPage(onAgree: _handleAgree)),
    );
  }
}
