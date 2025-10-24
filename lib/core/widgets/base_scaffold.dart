import 'package:flutter/material.dart';
import 'package:hw/core/components/navbar/bottom_nav_bar.dart';

class BaseScaffold extends StatelessWidget {
  final Widget body;
  final int currentIndex;

  const BaseScaffold({
    super.key,
    required this.body,
    this.currentIndex = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: body,
      bottomNavigationBar: BottomNavBar(currentIndex: currentIndex),
    );
  }
}
