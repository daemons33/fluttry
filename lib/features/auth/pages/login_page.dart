import 'package:flutter/material.dart';
import '../../home/pages/home_page.dart';
import '../../../data/services/api_service.dart';
import 'package:hw/features/auth/controllers/api_auth.dart';

// para saber el id del dispositivo
import 'package:device_info_plus/device_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'dart:io';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isLoading = false;
  String? errorMessage;
  bool _obscurePassword = true;

  Future<String> getDeviceId() async {
    final deviceInfo = DeviceInfoPlugin();

    if (Platform.isAndroid) {
      final androidInfo = await deviceInfo.androidInfo;
      return androidInfo.id ?? 'unknown_android';
    } else if (Platform.isIOS) {
      final iosInfo = await deviceInfo.iosInfo;
      return iosInfo.identifierForVendor ?? 'unknown_ios';
    } else {
      return 'unknown_device';
    }
  }

  Future<void> _login() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final deviceId = await getDeviceId();
      print("Dispositivo detectado: $deviceId");

      final response = await ApiAuthController.login(
        emailController.text,
        passwordController.text,
        deviceId,
      );

      if (response['token'] != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomePage()),
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
      backgroundColor: const Color(0xFFE8EAED),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 60),
                const Text(
                  'APRENDE DRA GRICA',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A1A1A),
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Ingresa para comenzar tu examen',
                  style: TextStyle(
                    fontSize: 18,
                    color: Color(0xFF6B7280),
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 60),

                // Correo electrónico
                const Text(
                  'Correo electrónico',
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFF1A1A1A),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  decoration: _inputDecoration(),
                  child: TextField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    style: const TextStyle(fontSize: 16, color: Color(0xFF1A1A1A)),
                    decoration: InputDecoration(
                      hintText: 'Ingresa tu correo',
                      prefixIcon: const Icon(Icons.email_outlined, color: Color(0xFF9CA3AF), size: 20),
                      border: _border(),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    ),
                  ),
                ),
                const SizedBox(height: 28),

                // Contraseña
                const Text(
                  'Contraseña',
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFF1A1A1A),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  decoration: _inputDecoration(),
                  child: TextField(
                    controller: passwordController,
                    obscureText: _obscurePassword,
                    style: const TextStyle(fontSize: 16, color: Color(0xFF1A1A1A)),
                    decoration: InputDecoration(
                      hintText: 'Ingresa tu contraseña',
                      prefixIcon: const Icon(Icons.lock_outline, color: Color(0xFF9CA3AF), size: 20),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                          color: const Color(0xFF9CA3AF),
                          size: 20,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                      border: _border(),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                if (errorMessage != null)
                  Center(
                    child: Text(
                      errorMessage!,
                      style: const TextStyle(color: Colors.red, fontSize: 16),
                    ),
                  ),

                const SizedBox(height: 16),

                // Botón Iniciar Sesión
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: isLoading ? null : _login,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0EA5E9),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                      'Iniciar Sesión',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // ¿Olvidaste tu contraseña?
                Center(
                  child: TextButton(
                    onPressed: () {
                      print('Recuperar contraseña');
                    },
                    child: const Text(
                      '¿Olvidaste tu contraseña?',
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFF0EA5E9),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // 🔹 Métodos para simplificar decoración visual
  BoxDecoration _inputDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 10,
          offset: const Offset(0, 2),
        ),
      ],
    );
  }

  OutlineInputBorder _border() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide.none,
    );
  }
}
