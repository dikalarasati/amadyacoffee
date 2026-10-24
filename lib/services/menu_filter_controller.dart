import 'package:flutter/foundation.dart';

import '../models/menu_item.dart';

/// Menyimpan filter (kategori + kata kunci) yang dipakai halaman Daftar Menu.
/// Beranda dapat mengubah filter ini (klik kategori / submit pencarian),
/// lalu berpindah tab ke Daftar Menu yang otomatis menampilkan hasilnya.
class MenuFilterController extends ChangeNotifier {
  MenuCategory? _category;
  String _query = '';

  MenuCategory? get category => _category;
  String get query => _query;

  void setCategory(MenuCategory? category) {
    _category = category;
    notifyListeners();
  }

  void setQuery(String query) {
    _query = query;
    notifyListeners();
  }

  /// Mengubah kategori dan kata kunci sekaligus (satu kali notifikasi).
  void apply({MenuCategory? category, String query = ''}) {
    _category = category;
    _query = query;
    notifyListeners();
  }
}
