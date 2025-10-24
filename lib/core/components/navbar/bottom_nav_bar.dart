import 'package:flutter/material.dart';
import 'package:hw/core/routes/app_router.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;

  const BottomNavBar({super.key, required this.currentIndex});

  void _onItemTapped(BuildContext context, int index) {
    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, AppRouter.home);
        break;
      case 1:
        Navigator.pushReplacementNamed(context, '/cursos');
        break;
      case 2:
        Navigator.pushReplacementNamed(context, '/recompensas');
        break;
      case 3:
        Navigator.pushReplacementNamed(context, '/perfil');
        break;
      case 4:
        Navigator.pushReplacementNamed(context, '/mas');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: (i) => _onItemTapped(context, i),
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Colors.blueAccent,
      unselectedItemColor: Colors.grey,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Inicio'),
        BottomNavigationBarItem(icon: Icon(Icons.grid_view), label: 'Cursos'),
        BottomNavigationBarItem(icon: Icon(Icons.card_giftcard), label: 'Recompensas'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
        BottomNavigationBarItem(icon: Icon(Icons.more_horiz), label: 'Más'),
      ],
    );
  }
}
