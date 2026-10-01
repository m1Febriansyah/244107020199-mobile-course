import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/prefs.dart';

// ==========================================
// 1. PROVIDER SIMULASI OFFLINE (Aman dari error StateProvider)
// ==========================================
final forceOfflineProvider = NotifierProvider<ForceOfflineNotifier, bool>(ForceOfflineNotifier.new);

class ForceOfflineNotifier extends Notifier<bool> {
  @override
  bool build() => false;

  void toggle(bool value) {
    state = value;
  }
}

// ==========================================
// 2. PROVIDER DARK MODE
// ==========================================
final prefsRepositoryProvider = Provider((ref) => PrefsRepository());
final darkModeProvider = AsyncNotifierProvider<DarkModeNotifier, bool>(DarkModeNotifier.new);

class DarkModeNotifier extends AsyncNotifier<bool> {
  @override
  Future<bool> build() => ref.watch(prefsRepositoryProvider).getDarkMode();

  Future<void> toggle() async {
    final next = !(state.value ?? false);
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(prefsRepositoryProvider).setDarkMode(next);
      return next;
    });
  }
}

// ==========================================
// 3. UI SETTINGS PAGE
// ==========================================
class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final darkModeState = ref.watch(darkModeProvider);
    final isOffline = ref.watch(forceOfflineProvider); // Pantau status offline

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          // Pengaturan Dark Mode
          darkModeState.when(
            data: (isDark) => SwitchListTile(
              title: const Text('Dark Mode'),
              subtitle: const Text('Ubah tema aplikasi'),
              value: isDark,
              onChanged: (value) => ref.read(darkModeProvider.notifier).toggle(),
            ),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, stack) => ListTile(title: Text('Error: $err')),
          ),
          
          const Divider(),
          
          // Pengaturan Simulasi Offline
          SwitchListTile(
            title: const Text('Simulasi Offline (Force Offline)'),
            subtitle: const Text('Hentikan semua koneksi API'),
            secondary: Icon(isOffline ? Icons.wifi_off : Icons.wifi),
            value: isOffline,
            onChanged: (val) {
              ref.read(forceOfflineProvider.notifier).toggle(val);
            },
          ),

          const Divider(),

          // Catat waktu
          ListTile(
            title: const Text('Catat Waktu Buka'),
            trailing: const Icon(Icons.touch_app),
            onTap: () async {
              await ref.read(prefsRepositoryProvider).markOpenedNow();
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Waktu berhasil dicatat!')),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}