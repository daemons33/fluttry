import 'package:flutter/material.dart';
import 'package:hw/features/auth/pages/login_page.dart';
import 'package:hw/features/auth/pages/register_page.dart';
import 'package:hw/features/home/pages/home_page.dart';
import 'package:hw/core/storage/secure_storage.dart';
import 'package:hw/core/widgets/base_scaffold.dart';

class AppRouter {
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';
  static const String initial = '/';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case initial:
        return MaterialPageRoute(builder: (_) => const _InitialRouteChecker());

      case login:
        return MaterialPageRoute(builder: (_) => const LoginPage());

      // case register:
      //   return MaterialPageRoute(builder: (_) => const RegisterPage());

      case home:
        return MaterialPageRoute(
          builder: (_) => const BaseScaffold(
            body: HomePage(),
            currentIndex: 0,
          ),
        );

      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('Ruta no encontrada')),
          ),
        );
    }
  }
}

class _InitialRouteChecker extends StatefulWidget {
  const _InitialRouteChecker({super.key});

  @override
  State<_InitialRouteChecker> createState() => _InitialRouteCheckerState();
}

class _InitialRouteCheckerState extends State<_InitialRouteChecker> {
  final _storage = SecureStorage();

  @override
  void initState() {
    super.initState();
    _checkToken();
  }

  Future<void> _checkToken() async {
    final token = await _storage.getToken();

    if (token != null && token.isNotEmpty) {
      Navigator.pushReplacementNamed(context, AppRouter.home);
    } else {
      Navigator.pushReplacementNamed(context, AppRouter.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
