import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:week_todo/providers/stats_provider.dart';

void main() {
  group('StatsNotifier Unit Test', () {
    test('Inisialisasi awal berstatus AsyncLoading sebelum proses asinkron selesai', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      // Memastikan state awal adalah AsyncLoading
      expect(container.read(statsProvider), isA<AsyncLoading<List<StatItem>>>());
    });

    test('State berubah menjadi AsyncData atau AsyncError setelah proses build selesai', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      // PENTING: Pasang listener agar provider tetap aktif di memori
      container.listen(statsProvider, (previous, next) {});

      // Tunggu hingga proses delay 2 detik / fetch selesai
      try {
        await container.read(statsProvider.future);
      } catch (_) {
        // Abaikan exception jika kena simulasi error 30%
      }

      final state = container.read(statsProvider);
      
      // Memastikan state akhir valid (memiliki data ATAU berisi error)
      expect(state.hasValue || state.hasError, isTrue);
    });

    test('Memanggil refresh() mengubah state ke AsyncLoading terlebih dahulu', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      // Pasang listener aktif
      container.listen(statsProvider, (previous, next) {});

      // Selesaikan build awal
      try {
        await container.read(statsProvider.future);
      } catch (_) {}

      final notifier = container.read(statsProvider.notifier);
      final refreshFuture = notifier.refresh();

      // Memastikan state langsung berubah ke AsyncLoading saat refresh dipanggil
      expect(container.read(statsProvider), isA<AsyncLoading<List<StatItem>>>());

      try {
        await refreshFuture;
      } catch (_) {}

      // Setelah selesai refresh, indikator loading harus hilang
      expect(container.read(statsProvider).isLoading, isFalse);
    });
  });
}