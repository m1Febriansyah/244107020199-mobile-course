import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/prefs.dart';

// ==========================================
// BAGIAN 1: PROVIDER & STATE MANAGEMENT
// ==========================================
final prefsRepositoryProvider = Provider((ref) => PrefsRepository());

final darkModeProvider =
    AsyncNotifierProvider<DarkModeNotifier, bool>(DarkModeNotifier.new);

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
// BAGIAN 2: ANTARMUKA (UI) SETTINGS PAGE
// ==========================================
class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final darkModeState = ref.watch(darkModeProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          // Menampilkan loading, error, atau switch toggle
          darkModeState.when(
            data: (isDark) => SwitchListTile(
              title: const Text('Dark Mode'),
              subtitle: const Text('Ubah tema aplikasi'),
              value: isDark,
              onChanged: (value) {
                ref.read(darkModeProvider.notifier).toggle();
              },
            ),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, stack) => ListTile(
              title: Text('Error: $err'),
            ),
          ),
          
          // Contoh tombol untuk mencatat waktu terakhir dibuka
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