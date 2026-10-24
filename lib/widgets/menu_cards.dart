import 'package:flutter/material.dart';

import '../models/menu_item.dart';
import '../theme/app_theme.dart';
import '../utils/format.dart';
import 'common_widgets.dart';
import 'menu_image.dart';

/// Dekorasi kartu putih bersudut membulat yang dipakai bersama.
BoxDecoration cardDecoration({double radius = 18}) => BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(radius),
      boxShadow: [
        BoxShadow(
          color: AppColors.brown.o(0.08),
          blurRadius: 14,
          offset: const Offset(0, 5),
        ),
      ],
    );

/// Kartu menu vertikal (gambar di atas). Dipakai pada Best Seller (beranda)
/// dan GridView di halaman Daftar Menu.
class MenuGridCard extends StatelessWidget {
  final MenuItem item;
  final VoidCallback onTap;

  const MenuGridCard({super.key, required this.item, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Ink(
          decoration: cardDecoration(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: MenuImage(
                        item: item,
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(18),
                        ),
                      ),
                    ),
                    if (item.isBestSeller)
                      Positioned(
                        top: 10,
                        left: 10,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.gold,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            'Best Seller',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                              color: AppColors.beanDark,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppText.title.copyWith(fontSize: 14),
                    ),
                    const SizedBox(height: 2),
                    Text(item.category.label,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppText.caption),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            formatRupiah(item.price),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w800,
                              color: AppColors.armyGreen,
                            ),
                          ),
                        ),
                        RatingBadge(rating: item.rating, size: 11),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Kartu menu horizontal (gambar di kiri). Dipakai pada mode ListView.
class MenuListTile extends StatelessWidget {
  final MenuItem item;
  final VoidCallback onTap;

  const MenuListTile({super.key, required this.item, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Ink(
          padding: const EdgeInsets.all(10),
          decoration: cardDecoration(),
          child: Row(
            children: [
              SizedBox(
                width: 88,
                height: 88,
                child: MenuImage(
                  item: item,
                  borderRadius: BorderRadius.circular(14),
                  iconSize: 30,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppText.title,
                    ),
                    const SizedBox(height: 2),
                    Text(item.category.label, style: AppText.caption),
                    const SizedBox(height: 4),
                    RatingBadge(
                      rating: item.rating,
                      reviewCount: item.reviewCount,
                      size: 12,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      formatRupiah(item.price),
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: AppColors.armyGreen,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 36,
                height: 36,
                decoration: const BoxDecoration(
                  color: AppColors.armyGreen,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.arrow_forward_rounded,
                    color: Colors.white, size: 20),
              ),
              const SizedBox(width: 4),
            ],
          ),
        ),
      ),
    );
  }
}
