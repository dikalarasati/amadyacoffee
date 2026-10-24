import 'package:flutter/material.dart';

import '../services/cart_controller.dart';
import '../theme/app_theme.dart';

/// Judul section + tombol aksi opsional ("Lihat semua").
class SectionHeader extends StatelessWidget {
  final String title;
  final String? actionLabel;
  final VoidCallback? onAction;

  const SectionHeader({
    super.key,
    required this.title,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
      child: Row(
        children: [
          Expanded(
            child: Text(title, style: AppText.heading.copyWith(fontSize: 20)),
          ),
          if (actionLabel != null)
            TextButton(
              onPressed: onAction,
              style: TextButton.styleFrom(foregroundColor: AppColors.armyGreen),
              child: Text(
                actionLabel!,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
        ],
      ),
    );
  }
}

/// Lencana rating bintang (aksen gold).
class RatingBadge extends StatelessWidget {
  final double rating;
  final int? reviewCount;
  final double size;

  const RatingBadge({
    super.key,
    required this.rating,
    this.reviewCount,
    this.size = 13,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.star_rounded, color: AppColors.gold, size: size + 3),
        const SizedBox(width: 2),
        Text(
          rating.toStringAsFixed(1),
          style: TextStyle(
            fontSize: size,
            fontWeight: FontWeight.w700,
            color: AppColors.brown,
          ),
        ),
        if (reviewCount != null)
          Text(
            ' ($reviewCount)',
            style: TextStyle(fontSize: size - 1, color: AppColors.brown.o(0.6)),
          ),
      ],
    );
  }
}

/// Ikon keranjang dengan lencana jumlah item. Otomatis ter-update
/// karena mendengarkan [CartController].
class CartBadgeIcon extends StatelessWidget {
  final Color color;
  final IconData icon;

  const CartBadgeIcon({
    super.key,
    this.color = Colors.white,
    this.icon = Icons.shopping_bag_outlined,
  });

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: CartController.instance,
      builder: (context, _) {
        final qty = CartController.instance.totalQty;
        return Stack(
          clipBehavior: Clip.none,
          children: [
            Icon(icon, color: color),
            if (qty > 0)
              Positioned(
                right: -8,
                top: -8,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                  decoration: BoxDecoration(
                    color: AppColors.gold,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    '$qty',
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      color: AppColors.beanDark,
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}

/// Tampilan kosong (hasil pencarian kosong / keranjang kosong).
class EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;
  final Widget? action;

  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
    this.action,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(
                color: AppColors.armyGreen.o(0.10),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 44, color: AppColors.armyGreen),
            ),
            const SizedBox(height: 16),
            Text(title, style: AppText.heading.copyWith(fontSize: 20)),
            const SizedBox(height: 6),
            Text(
              message,
              textAlign: TextAlign.center,
              style: AppText.body.copyWith(color: AppColors.brown.o(0.7)),
            ),
            if (action != null) ...[const SizedBox(height: 18), action!],
          ],
        ),
      ),
    );
  }
}
