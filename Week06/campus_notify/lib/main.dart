import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

// 1. PASTIKAN KETIGA IMPORT INI ADA
import 'pages/login_page.dart';
import 'pages/home_page.dart';
import 'pages/announcement_page.dart';
import 'providers/auth_provider.dart';

void main() {
  runApp(const ProviderScope(child: MainApp()));
}

class MainApp extends ConsumerWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = GoRouter(
      redirect: (context, state) {
        final loggedIn = ref.read(authStateProvider).value ?? false;
        final goingLogin = state.matchedLocation == '/login';
        if (!loggedIn && !goingLogin) return '/login';
        if (loggedIn && goingLogin) return '/';
        return null;
      },
      routes: [
        GoRoute(path: '/login', builder: (_, __) => const LoginPage()),
        
        // 2. HAPUS KATA "const" DI DEPAN HomePage() (jika masih error, hapus juga pada LoginPage)
        GoRoute(path: '/', builder: (_, __) => HomePage()), 
        
        GoRoute(
          path: '/pengumuman/:id',
          builder: (_, s) => AnnouncementPage(id: s.pathParameters['id'] ?? ''),
        ),
      ],
    );

    return MaterialApp.router(
      routerConfig: router,
    );
  }
}