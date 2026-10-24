import 'package:flutter/material.dart';

/// Palet warna Amadya Coffee & Eatery.
/// Semua warna dipusatkan di sini supaya desain konsisten di seluruh halaman.
class AppColors {
  AppColors._();

  // Primary: Hijau Army (natural, cozy, tenang)
  static const Color armyGreen = Color(0xFF4B5320);
  static const Color armyGreenDark = Color(0xFF353B16);
  static const Color armyGreenLight = Color(0xFF7A8450);

  // Background / Surface
  static const Color cream = Color(0xFFFDFBF7);
  static const Color bone = Color(0xFFFAFAFA);

  // Secondary / Text: Cokelat Tua
  static const Color brown = Color(0xFF5C4033);
  static const Color beanDark = Color(0xFF3B2A20);

  // Accent: Gold / Amber (rating, tombol aksi, ikon spesial)
  static const Color gold = Color(0xFFD4AF37);

  static const Color divider = Color(0xFFEDE6DA);
}

/// Helper kecil agar pemanggilan opasitas tidak bergantung versi Flutter
/// (withOpacity sudah deprecated di versi terbaru).
extension ColorOpacityX on Color {
  Color o(double opacity) => withAlpha((opacity.clamp(0.0, 1.0) * 255).round());
}

/// Gaya teks. Judul memakai font serif agar terkesan elegan ala kafe.
class AppText {
  AppText._();

  static const List<String> _serifFallback = ['Georgia', 'Times New Roman'];

  static const TextStyle heading = TextStyle(
    fontFamily: 'serif',
    fontFamilyFallback: _serifFallback,
    fontWeight: FontWeight.w700,
    color: AppColors.brown,
    height: 1.2,
  );

  static const TextStyle title = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w700,
    color: AppColors.brown,
  );

  static const TextStyle body = TextStyle(
    fontSize: 14,
    color: AppColors.brown,
    height: 1.45,
  );

  static TextStyle caption = TextStyle(
    fontSize: 12,
    color: AppColors.brown.o(0.65),
  );
}

class AppTheme {
  AppTheme._();

  static ThemeData get light {
    final scheme = ColorScheme.fromSeed(
      seedColor: AppColors.armyGreen,
      brightness: Brightness.light,
    ).copyWith(
      primary: AppColors.armyGreen,
      onPrimary: Colors.white,
      secondary: AppColors.gold,
      surface: AppColors.cream,
      onSurface: AppColors.brown,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: AppColors.cream,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.armyGreen,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.armyGreen,
          foregroundColor: Colors.white,
          minimumSize: const Size(0, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.armyGreenDark,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
