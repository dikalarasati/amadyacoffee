import 'package:flutter/foundation.dart';

import '../models/menu_item.dart';

/// Satu baris pesanan: menu + ukuran yang dipilih + jumlah.
class CartLine {
  final MenuItem item;
  final PortionSize size;
  int qty;

  CartLine({required this.item, required this.size, this.qty = 1});

  int get unitPrice => item.priceFor(size);
  int get subtotal => unitPrice * qty;

  /// Menu yang sama dengan ukuran berbeda dianggap baris yang berbeda.
  String get key => '${item.id}|${size.label}';
}

/// State keranjang yang dipakai bersama oleh semua halaman.
/// Memakai ChangeNotifier bawaan Flutter (tanpa package tambahan);
/// widget cukup dibungkus ListenableBuilder.
class CartController extends ChangeNotifier {
  CartController._();
  static final CartController instance = CartController._();

  static const double taxRate = 0.10; // PPN / pajak restoran 10%

  final List<CartLine> _lines = [];

  List<CartLine> get lines => List.unmodifiable(_lines);
  bool get isEmpty => _lines.isEmpty;

  int get totalQty => _lines.fold(0, (sum, l) => sum + l.qty);
  int get subtotal => _lines.fold(0, (sum, l) => sum + l.subtotal);
  int get tax => (subtotal * taxRate).round();
  int get total => subtotal + tax;

  void add(MenuItem item, PortionSize size, {int qty = 1}) {
    final candidate = CartLine(item: item, size: size, qty: qty);
    final index = _lines.indexWhere((l) => l.key == candidate.key);
    if (index >= 0) {
      _lines[index].qty += qty;
    } else {
      _lines.add(candidate);
    }
    notifyListeners();
  }

  void increment(CartLine line) {
    line.qty++;
    notifyListeners();
  }

  void decrement(CartLine line) {
    if (line.qty > 1) {
      line.qty--;
    } else {
      _lines.remove(line);
    }
    notifyListeners();
  }

  void remove(CartLine line) {
    _lines.remove(line);
    notifyListeners();
  }

  void clear() {
    _lines.clear();
    notifyListeners();
  }
}
