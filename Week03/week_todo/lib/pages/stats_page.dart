import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/stats_provider.dart';

// Menggunakan ConsumerWidget untuk mendapatkan akses ke parameter WidgetRef ref
class StatsPage extends ConsumerWidget {
  const StatsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ref.watch DIPANGGUL DI DALAM build() untuk berlangganan perubahan state AsyncValue
    final statsAsync = ref.watch(statsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Statistik Aplikasi'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              // ref.read DIPANGGUL DI DALAM callback untuk memicu action tanpa rebuild tidak perlu
              ref.read(statsProvider.notifier).refresh();
            },
          ),
        ],
      ),
      // Pattern matching .when() menangani ketiga kondisi AsyncValue secara deklaratif
      body: statsAsync.when(
        // Kondisi 1: Loading (menampilkan spinner)
        loading: () => const Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 12),
              Text('Memuat data statistik...'),
            ],
          ),
        ),
        // Kondisi 2: Error (menampilkan pesan error + tombol retry)
        error: (err, stack) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.error_outline, color: Colors.red, size: 48),
                const SizedBox(height: 12),
                Text(
                  err.toString().replaceAll('Exception: ', ''),
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 15),
                ),
                const SizedBox(height: 16),
                FilledButton.icon(
                  onPressed: () {
                    // ref.read di dalam callback tombol Coba Lagi
                    ref.read(statsProvider.notifier).refresh();
                  },
                  icon: const Icon(Icons.refresh),
                  label: const Text('Coba Lagi'),
                ),
              ],
            ),
          ),
        ),
        // Kondisi 3: Success (menampilkan ListView 3 item)
        data: (stats) => ListView.separated(
          padding: const EdgeInsets.all(16.0),
          itemCount: stats.length,
          separatorBuilder: (context, index) => const Divider(),
          itemBuilder: (context, index) {
            final item = stats[index];
            return ListTile(
              leading: CircleAvatar(
                child: Text('${index + 1}'),
              ),
              title: Text(item.label),
              trailing: Text(
                item.value,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}