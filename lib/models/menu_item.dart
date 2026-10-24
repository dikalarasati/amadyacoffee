import 'package:flutter/material.dart';

/// Kategori menu Amadya Coffee & Eatery.
/// Setiap kategori punya label dan ikon sehingga UI tidak perlu menulis ulang.
enum MenuCategory {
  coffee('Coffee', 'Coffee', Icons.coffee),
  nonCoffee('Non-Coffee', 'Non-Coffee', Icons.local_drink),
  mainCourse('Main Course', 'Makanan', Icons.restaurant),
  pastry('Pastry & Dessert', 'Pastry', Icons.bakery_dining);

  const MenuCategory(this.label, this.shortLabel, this.icon);

  /// Label lengkap (dipakai di chip filter dan detail).
  final String label;

  /// Label singkat (dipakai di tile kategori beranda).
  final String shortLabel;
  final IconData icon;

  /// Dipakai saat membaca data JSON dari API: "coffee" -> MenuCategory.coffee.
  static MenuCategory fromKey(String key) => MenuCategory.values.firstWhere(
        (c) => c.name == key,
        orElse: () => MenuCategory.coffee,
      );
}

/// Pilihan ukuran / porsi beserta tambahan harga.
class PortionSize {
  final String label;
  final int extraPrice;

  const PortionSize(this.label, [this.extraPrice = 0]);

  factory PortionSize.fromJson(Map<String, dynamic> json) => PortionSize(
        json['label'] as String,
        (json['extra_price'] as num?)?.toInt() ?? 0,
      );

  Map<String, dynamic> toJson() => {'label': label, 'extra_price': extraPrice};
}

/// Model data satu menu.
/// Nama field di fromJson/toJson sengaja dibuat snake_case agar cocok dengan
/// konvensi JSON API sehingga transisi dari data dummy ke server mudah.
class MenuItem {
  final String id;
  final String name;
  final MenuCategory category;
  final int price; // harga dasar (ukuran terkecil), satuan Rupiah
  final String description; // deskripsi rasa
  final List<String> ingredients; // komposisi
  final List<PortionSize> sizes; // pilihan ukuran / porsi
  final double rating;
  final int reviewCount;
  final bool isBestSeller;

  /// URL / path gambar. Jika kosong atau gagal dimuat, UI menampilkan
  /// ilustrasi default bermotif biji kopi.
  final String imageUrl;

  const MenuItem({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.description,
    required this.ingredients,
    required this.sizes,
    required this.rating,
    required this.reviewCount,
    this.isBestSeller = false,
    this.imageUrl = '',
  });

  /// Harga untuk ukuran tertentu.
  int priceFor(PortionSize size) => price + size.extraPrice;

  factory MenuItem.fromJson(Map<String, dynamic> json) => MenuItem(
        id: json['id'] as String,
        name: json['name'] as String,
        category: MenuCategory.fromKey(json['category'] as String),
        price: (json['price'] as num).toInt(),
        description: json['description'] as String,
        ingredients: List<String>.from(json['ingredients'] as List),
        sizes: (json['sizes'] as List)
            .map((e) => PortionSize.fromJson(e as Map<String, dynamic>))
            .toList(),
        rating: (json['rating'] as num).toDouble(),
        reviewCount: (json['review_count'] as num).toInt(),
        isBestSeller: json['is_best_seller'] as bool? ?? false,
        imageUrl: json['image_url'] as String? ?? '',
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'category': category.name,
        'price': price,
        'description': description,
        'ingredients': ingredients,
        'sizes': sizes.map((s) => s.toJson()).toList(),
        'rating': rating,
        'review_count': reviewCount,
        'is_best_seller': isBestSeller,
        'image_url': imageUrl,
      };
}
