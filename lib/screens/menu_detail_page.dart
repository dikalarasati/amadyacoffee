import 'package:flutter/material.dart';

import '../models/menu_item.dart';
import '../services/cart_controller.dart';
import '../theme/app_theme.dart';
import '../utils/format.dart';
import '../widgets/common_widgets.dart';
import '../widgets/menu_image.dart';
import 'main_shell.dart';

/// HALAMAN 3 - DETAIL MENU
/// Data menu diterima lewat konstruktor (passing data dari Navigator.push).
class MenuDetailPage extends StatefulWidget {
  final MenuItem item;

  const MenuDetailPage({super.key, required this.item});

  @override
  State<MenuDetailPage> createState() => _MenuDetailPageState();
}

class _MenuDetailPageState extends State<MenuDetailPage> {
  late PortionSize _selectedSize = widget.item.sizes.first;
  int _qty = 1;

  int get _unitPrice => widget.item.priceFor(_selectedSize);
  int get _total => _unitPrice * _qty;

  void _addToCart() {
    CartController.instance.add(widget.item, _selectedSize, qty: _qty);
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text('${_qty}x ${widget.item.name} ditambahkan ke pesanan'),
          action: SnackBarAction(
            label: 'LIHAT',
            textColor: AppColors.gold,
            onPressed: () => openCartFromAnywhere(context),
          ),
        ),
      );
    setState(() => _qty = 1);
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.item;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 280,
            backgroundColor: AppColors.armyGreen,
            foregroundColor: Colors.white,
            actions: [
              IconButton(
                onPressed: () => openCartFromAnywhere(context),
                icon: const CartBadgeIcon(),
              ),
              const SizedBox(width: 8),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: MenuImage(item: item, iconSize: 72),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              // Menimpa sedikit area gambar agar sudut atas membulat.
              transform: Matrix4.translationValues(0, -24, 0),
              decoration: const BoxDecoration(
                color: AppColors.cream,
                borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
              ),
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTitleBlock(item),
                  const SizedBox(height: 20),
                  _label('Deskripsi Rasa'),
                  Text(item.description, style: AppText.body),
                  const SizedBox(height: 20),
                  _label('Komposisi'),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: item.ingredients
                        .map((e) => Chip(
                              label: Text(e),
                              labelStyle: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: AppColors.brown,
                              ),
                              backgroundColor: Colors.white,
                              side: const BorderSide(color: AppColors.divider),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ))
                        .toList(),
                  ),
                  const SizedBox(height: 20),
                  _label('Ukuran / Porsi'),
                  _buildSizeSelector(item),
                  const SizedBox(height: 20),
                  _label('Jumlah'),
                  _buildQtyStepper(),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  Widget _buildTitleBlock(MenuItem item) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.armyGreen.o(0.12),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(item.category.icon, size: 14, color: AppColors.armyGreen),
              const SizedBox(width: 6),
              Text(
                item.category.label,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppColors.armyGreen,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Text(item.name, style: AppText.heading.copyWith(fontSize: 26)),
        const SizedBox(height: 8),
        Row(
          children: [
            RatingBadge(rating: item.rating, reviewCount: item.reviewCount, size: 13),
            if (item.isBestSeller) ...[
              const SizedBox(width: 10),
              const Icon(Icons.local_fire_department_rounded,
                  color: AppColors.gold, size: 18),
              const Text(
                'Best Seller',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppColors.brown,
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: 10),
        Text(
          formatRupiah(_unitPrice),
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w800,
            color: AppColors.armyGreen,
          ),
        ),
      ],
    );
  }

  Widget _label(String text) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Text(text, style: AppText.title),
      );

  Widget _buildSizeSelector(MenuItem item) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: item.sizes.map((size) {
        final selected = size == _selectedSize;
        return ChoiceChip(
          label: Text(
            size.extraPrice == 0
                ? size.label
                : '${size.label}  (+${formatRupiah(size.extraPrice)})',
          ),
          selected: selected,
          showCheckmark: false,
          onSelected: (_) => setState(() => _selectedSize = size),
          selectedColor: AppColors.armyGreen,
          backgroundColor: Colors.white,
          side: BorderSide(color: selected ? AppColors.armyGreen : AppColors.divider),
          labelStyle: TextStyle(
            fontWeight: FontWeight.w700,
            color: selected ? Colors.white : AppColors.brown,
          ),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        );
      }).toList(),
    );
  }

  Widget _buildQtyStepper() {
    Widget btn(IconData icon, VoidCallback? onTap) => InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: onTap == null ? AppColors.divider : AppColors.armyGreen,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: Colors.white, size: 20),
          ),
        );

    return Row(
      children: [
        btn(Icons.remove_rounded, _qty > 1 ? () => setState(() => _qty--) : null),
        SizedBox(
          width: 56,
          child: Center(
            child: Text('$_qty', style: AppText.heading.copyWith(fontSize: 20)),
          ),
        ),
        btn(Icons.add_rounded, () => setState(() => _qty++)),
      ],
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: AppColors.brown.o(0.10),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Total', style: AppText.caption),
                Text(
                  formatRupiah(_total),
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: AppColors.armyGreen,
                  ),
                ),
              ],
            ),
            const SizedBox(width: 20),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: _addToCart,
                icon: const Icon(Icons.add_shopping_cart_rounded),
                label: const Text('Tambah ke Pesanan'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
