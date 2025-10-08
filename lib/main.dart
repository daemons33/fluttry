import 'package:flutter/material.dart';
import 'services/api_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login Node + Flutter',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;
  String? errorMessage;

  Future<void> _login() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final response = await ApiService.login(
        emailController.text,
        passwordController.text,
      );

      if (response['token'] != null) {
        // si login exitoso → ir a otra pantalla
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => const HomePage(),
          ),
        );
      } else {
        setState(() => errorMessage = 'Credenciales incorrectas');
      }
    } catch (e) {
      setState(() => errorMessage = e.toString());
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login con Node.js')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Correo'),
            ),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(labelText: 'Contraseña'),
              obscureText: true,
            ),
            const SizedBox(height: 16),
            if (errorMessage != null)
              Text(errorMessage!, style: const TextStyle(color: Colors.red)),
            const SizedBox(height: 16),
            isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
              onPressed: _login,
              child: const Text('Iniciar sesión'),
            ),
          ],
        ),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? responseText;
  bool loading = false;

  Future<void> getTramites() async {
    setState(() => loading = true);
    try {
      final res = await ApiService.getTramites();
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
              onPressed: getTramites,
              child: const Text('GET a trámites'),
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