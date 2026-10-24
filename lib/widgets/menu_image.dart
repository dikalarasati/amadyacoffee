import 'package:flutter/material.dart';

import '../models/menu_item.dart';
import '../theme/app_theme.dart';
import 'coffee_bean_pattern.dart';

/// Gambar menu.
/// - Jika [MenuItem.imageUrl] terisi, gambar dimuat dari jaringan.
/// - Jika kosong / gagal dimuat, tampil ilustrasi gradasi bermotif biji kopi
///   dengan ikon kategori, sehingga aplikasi tetap rapi tanpa aset gambar.
class MenuImage extends StatelessWidget {
  final MenuItem item;
  final BorderRadius borderRadius;
  final double iconSize;

  const MenuImage({
    super.key,
    required this.item,
    this.borderRadius = BorderRadius.zero,
    this.iconSize = 44,
  });

  /// Warna gradasi berbeda per kategori agar mudah dibedakan.
  List<Color> get _gradient {
    switch (item.category) {
      case MenuCategory.coffee:
        return const [Color(0xFF6F4E37), Color(0xFF3B2A20)];
      case MenuCategory.nonCoffee:
        return const [AppColors.armyGreenLight, AppColors.armyGreenDark];
      case MenuCategory.mainCourse:
        return const [Color(0xFFB07A3F), Color(0xFF6B4423)];
      case MenuCategory.pastry:
        return const [Color(0xFFC9A66B), Color(0xFF8A6A3C)];
    }
  }

  Widget _fallback() {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: _gradient,
        ),
      ),
      child: CoffeeBeanPattern(
        beanColor: Colors.white.o(0.10),
        creaseColor: Colors.white.o(0.18),
        count: 10,
        seed: item.id.hashCode,
        minSize: 12,
        maxSize: 28,
        child: Center(
          child: Container(
            padding: EdgeInsets.all(iconSize * 0.3),
            decoration: BoxDecoration(
              color: Colors.white.o(0.16),
              shape: BoxShape.circle,
            ),
            child: Icon(item.category.icon, color: Colors.white, size: iconSize),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius,
      child: SizedBox.expand(
        child: item.imageUrl.isEmpty
            ? _fallback()
            : Image.network(
                item.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => _fallback(),
              ),
      ),
    );
  }
}
