import 'package:flutter/material.dart';

import 'screens/main_shell.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const AmadyaApp());
}

/// Root aplikasi Amadya Coffee & Eatery.
class AmadyaApp extends StatelessWidget {
  const AmadyaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Amadya Coffee & Eatery',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      // MainShell berisi BottomNavigationBar (Beranda, Menu, Keranjang).
      // Halaman Detail dibuka dengan Navigator.push dari halaman mana pun.
      home: const MainShell(),
    );
  }
}
