import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

// Import file-file dari struktur folder Praktikum 1, 2, & 3
// Sesuaikan path jika ada perbedaan
import 'messaging/push_service.dart';
import 'providers/auth_provider.dart';
import 'pages/login_page.dart';
import 'pages/home_page.dart';
import 'pages/announcement_page.dart';

/// Konfigurasi GoRouter yang dibungkus dalam Provider (Gabungan Praktikum 1 & 3)
final routerProvider = Provider<GoRouter>((ref) {
  final router = GoRouter(
    initialLocation: '/',
    // Redirect logic dari Praktikum 1
    redirect: (context, state) {
      // Karena AuthNotifier menggunakan AsyncNotifier, kita cek value-nya
      final loggedIn = ref.read(authStateProvider).value ?? false;
      final goingLogin = state.matchedLocation == '/login';
      
      if (!loggedIn && !goingLogin) return '/login';
      if (loggedIn && goingLogin) return '/';
      return null;
    },
    routes: [
      GoRoute(
        path: '/login', 
        builder: (_, __) => const LoginPage(),
      ),
      GoRoute(
        path: '/', 
        builder: (_, __) => const HomePage(),
      ),
      GoRoute(
        path: '/pengumuman/:id',
        builder: (_, state) => AnnouncementPage(
          id: state.pathParameters['id'] ?? '',
        ),
      ),
    ],
  );

  // Daftarkan listener FCM ke GoRouter dari Praktikum 3
  // Agar saat notifikasi diklik, aplikasi tahu harus navigasi ke mana
  listenForeground((route) => router.go(route));
  handleTerminated((route) => router.go(route));

  return router;
});

void main() async {
  // 1. Wajib dipanggil pertama kali agar framework Flutter siap
  WidgetsFlutterBinding.ensureInitialized();

  // 2. Inisialisasi Firebase (Praktikum 2)
  await Firebase.initializeApp();

  // 3. Daftarkan background handler FCM SEBELUM runApp (Praktikum 3)
  registerBackgroundHandler();

  // 4. Inisialisasi plugin Flutter Local Notifications (Praktikum 2)
  await initLocalNotifications();

  // 5. Jalankan aplikasi yang dibungkus ProviderScope agar Riverpod aktif
  runApp(const ProviderScope(child: CampusNotifyApp()));
}

/// Root Widget Aplikasi
class CampusNotifyApp extends ConsumerWidget {
  const CampusNotifyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Pantau dan ambil instance router dari provider
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      title: 'Campus Notify',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      // Gunakan routerConfig dari Riverpod (GoRouter)
      routerConfig: router, 
    );
  }
}