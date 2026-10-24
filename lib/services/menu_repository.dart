import '../data/dummy_menu.dart';
import '../models/menu_item.dart';

/// Satu-satunya pintu akses data menu bagi UI.
///
/// Saat ini sumber datanya adalah [dummyMenu]. Pada tahap pengembangan
/// berikutnya cukup ubah isi repository ini (misalnya memakai paket `http`)
/// tanpa menyentuh halaman-halaman UI:
///
/// ```dart
/// Future<List<MenuItem>> fetchMenu() async {
///   final res = await http.get(Uri.parse('$baseUrl/menu'));
///   final list = jsonDecode(res.body) as List;
///   return list.map((e) => MenuItem.fromJson(e)).toList();
/// }
/// ```
class MenuRepository {
  MenuRepository._();
  static final MenuRepository instance = MenuRepository._();

  List<MenuItem> get all => dummyMenu;

  /// Menu yang ditandai sebagai Best Seller.
  List<MenuItem> get bestSellers =>
      all.where((m) => m.isBestSeller).toList(growable: false);

  /// Filter berdasarkan kategori (opsional) dan kata kunci pencarian.
  List<MenuItem> search({MenuCategory? category, String query = ''}) {
    final q = query.trim().toLowerCase();
    return all.where((m) {
      final matchCategory = category == null || m.category == category;
      final matchQuery = q.isEmpty ||
          m.name.toLowerCase().contains(q) ||
          m.description.toLowerCase().contains(q) ||
          m.ingredients.any((i) => i.toLowerCase().contains(q));
      return matchCategory && matchQuery;
    }).toList(growable: false);
  }

  int countIn(MenuCategory category) =>
      all.where((m) => m.category == category).length;
}
