import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'pages/settings_page.dart';

void main() {
  // ProviderScope wajib ada agar Riverpod bisa berjalan
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Pantau state dark mode
    final darkModeState = ref.watch(darkModeProvider);

    return MaterialApp(
      title: 'Offline Notes',
      // Atur tema berdasarkan value dari SharedPreferences
      themeMode: darkModeState.when(
        data: (isDark) => isDark ? ThemeMode.dark : ThemeMode.light,
        loading: () => ThemeMode.system,
        error: (_, __) => ThemeMode.light,
      ),
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      darkTheme: ThemeData.dark(useMaterial3: true),
      home: const SettingsPage(), 
    );
  }
}