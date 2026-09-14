import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Model data immutable untuk menampung item statistik
class StatItem {
  final String label;
  final String value;

  const StatItem(this.label, this.value);
}

// AsyncNotifier mengelola state asinkron (List<StatItem>) menggunakan AsyncValue
class StatsNotifier extends AsyncNotifier<List<StatItem>> {
  final Random _random = Random();

  @override
  Future<List<StatItem>> build() async {
    // Fungsi build otomatis dipanggil saat provider pertama kali dibaca/di-watch
    return await _fetchStats();
  }

  // Method privat untuk mensimulasikan pemanggilan API / database
  Future<List<StatItem>> _fetchStats() async {
    // Simulasi network latency selama 2 detik
    await Future.delayed(const Duration(seconds: 2));

    // Simulasi kegagalan acak 30%
    if (_random.nextDouble() < 0.3) {
      throw Exception('Gagal memuat data statistik dari server (Error 30%)');
    }

    // Mengembalikan 3 item statistik jika berhasil
    return const [
      StatItem('Pengguna Aktif', '2,450'),
      StatItem('Total Transaksi', '1,120'),
      StatItem('Tingkat Keberhasilan', '98.5%'),
    ];
  }

  // Method untuk memuat ulang data secara manual
  Future<void> refresh() async {
    // Mengubah state menjadi loading secara eksplisit
    state = const AsyncLoading();
    // AsyncValue.guard menangkap exception otomatis dan mengubahnya menjadi AsyncError
    state = await AsyncValue.guard(() => _fetchStats());
  }
}

// Deklarasi NotifierProvider dengan tipe eksplisit
final statsProvider =
    AsyncNotifierProvider<StatsNotifier, List<StatItem>>(StatsNotifier.new);