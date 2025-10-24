import 'package:flutter/material.dart';
import '../../auth/pages/login_page.dart';
import '../../home/controllers/api_home.dart';
import '../../../data/services/api_service.dart';
import '../controllers/api_home.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? responseText;
  bool loading = false;

  Future<void> getUsuarios() async {
    setState(() => loading = true);
    try {
      final res = await HomeController.getUsuarios();
      setState(() => responseText = res.toString());
    } catch (e) {
      setState(() => responseText = 'Error: $e');
    } finally {
      setState(() => loading = false);
    }
  }

  Future<void> signOut() async {
    setState(() => loading = true);
    try {
      await ApiService.signOut();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginPage()),
      );
    } catch (e) {
      setState(() => responseText = 'Error al cerrar sesión: $e');
    } finally {
      setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Menú Principal')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (loading) const CircularProgressIndicator(),
            if (responseText != null)
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(responseText!),
              ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/usuarios');
              },
              child: const Text('Ver Usuarios'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: signOut,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text('Salir'),
            ),
          ],
        ),
      ),
    );
  }
}
