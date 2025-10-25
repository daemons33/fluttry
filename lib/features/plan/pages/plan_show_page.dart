import 'package:flutter/material.dart';

class PlanShowPage extends StatelessWidget {
  const PlanShowPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Planes de Acceso',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              const SizedBox(height: 20),
              const Text(
                'Tu Acceso ha Expirado',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A1A1A),
                  height: 1.2,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              const Text(
                'Para continuar practicando, por favor elige uno de los siguientes planes.',
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFF6B7280),
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),

              // 🔹 Plan Diario
              _buildPlanCard(
                title: 'Pase Diario',
                subtitle: 'Acceso por 24 horas',
                price: '\$4.99',
                isPopular: false,
                benefit: null,
                onPressed: () {
                  print('Pase Diario seleccionado');
                },
              ),
              const SizedBox(height: 16),

              // 🔹 Plan Semanal (Más Popular)
              _buildPlanCard(
                title: 'Acceso Semanal',
                subtitle: 'Acceso ilimitado por 7 días',
                price: '\$14.99',
                isPopular: true,
                benefit: 'Ahorro sobre el plan diario',
                onPressed: () {
                  print('Acceso Semanal seleccionado');
                },
              ),
              const SizedBox(height: 16),

              // 🔹 Plan Mensual
              _buildPlanCard(
                title: 'Plan Mensual',
                subtitle: 'Acceso ilimitado por 30 días',
                price: '\$39.99',
                isPopular: false,
                benefit: 'Mejor valor a largo plazo',
                onPressed: () {
                  print('Plan Mensual seleccionado');
                },
              ),
              const SizedBox(height: 32),

              // 🔐 Pagos seguros
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.lock_outline, size: 18, color: Colors.grey[600]),
                  const SizedBox(width: 8),
                  Text(
                    'Pagos 100% seguros',
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // 🔁 Reintentar login
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // vuelve al login
                },
                child: const Text(
                  '¿Fue un error? Intenta iniciar sesión de nuevo',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF0EA5E9),
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  /// 🔸 Tarjeta de plan reutilizable
  Widget _buildPlanCard({
    required String title,
    required String subtitle,
    required String price,
    required bool isPopular,
    String? benefit,
    required VoidCallback onPressed,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isPopular ? const Color(0xFF0EA5E9) : Colors.transparent,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1A1A1A),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            subtitle,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      price,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1A1A1A),
                      ),
                    ),
                  ],
                ),
                if (benefit != null) ...[
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const Icon(Icons.check_circle,
                          color: Color(0xFF0EA5E9), size: 20),
                      const SizedBox(width: 8),
                      Text(
                        benefit,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF1A1A1A),
                        ),
                      ),
                    ],
                  ),
                ],
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: onPressed,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isPopular
                          ? const Color(0xFF0EA5E9)
                          : const Color(0xFFE0F2FE),
                      foregroundColor: isPopular
                          ? Colors.white
                          : const Color(0xFF0EA5E9),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Seleccionar Plan',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // 🔹 Etiqueta "Más popular"
          if (isPopular)
            Positioned(
              top: 12,
              right: 12,
              child: Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFF0EA5E9),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'Más Popular',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
