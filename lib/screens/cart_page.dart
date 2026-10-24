import 'package:flutter/material.dart';

import '../services/cart_controller.dart';
import '../theme/app_theme.dart';
import '../utils/format.dart';
import '../widgets/coffee_bean_pattern.dart';
import '../widgets/common_widgets.dart';
import '../widgets/menu_cards.dart';
import '../widgets/menu_image.dart';

/// HALAMAN 4 - KERANJANG / RINGKASAN PESANAN
/// Menampilkan item yang dipilih, pengaturan jumlah, rincian biaya,
/// serta data pemesan (nama & nomor meja).
class CartPage extends StatefulWidget {
  final VoidCallback onBrowseMenu;
  final VoidCallback onOrderDone;

  const CartPage({
    super.key,
    required this.onBrowseMenu,
    required this.onOrderDone,
  });

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final CartController _cart = CartController.instance;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _tableController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _tableController.dispose();
    super.dispose();
  }

  void _checkout() {
    if (_nameController.text.trim().isEmpty ||
        _tableController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(content: Text('Isi nama pemesan dan nomor meja dulu ya, Kak.')),
        );
      return;
    }

    final name = _nameController.text.trim();
    final table = _tableController.text.trim();
    final total = _cart.total;

    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.cream,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
        icon: const Icon(Icons.check_circle_rounded, color: AppColors.armyGreen, size: 48),
        title: Text('Pesanan Diterima', style: AppText.heading.copyWith(fontSize: 20)),
        content: Text(
          'Terima kasih, $name!\nPesanan untuk meja $table sedang disiapkan.\n'
          'Total: ${formatRupiah(total)}',
          textAlign: TextAlign.center,
          style: AppText.body,
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              _cart.clear();
              _nameController.clear();
              _tableController.clear();
              widget.onOrderDone();
            },
            child: const Text('Oke'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _cart,
      builder: (context, _) {
        return Column(
          children: [
            _buildHeader(),
            Expanded(
              child: _cart.isEmpty
                  ? EmptyState(
                      icon: Icons.shopping_bag_outlined,
                      title: 'Keranjang masih kosong',
                      message: 'Yuk pilih kopi atau makanan favoritmu dulu.',
                      action: ElevatedButton(
                        onPressed: widget.onBrowseMenu,
                        child: const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12),
                          child: Text('Lihat Menu'),
                        ),
                      ),
                    )
                  : _buildContent(),
            ),
          ],
        );
      },
    );
  }

  Widget _buildHeader() {
    const radius = BorderRadius.vertical(bottom: Radius.circular(28));
    return ClipRRect(
      borderRadius: radius,
      child: Container(
        width: double.infinity,
        color: AppColors.armyGreen,
        child: CoffeeBeanPattern(
          beanColor: Colors.white.o(0.08),
          creaseColor: Colors.white.o(0.15),
          count: 9,
          seed: 5,
          child: SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 14, 20, 20),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Pesanan Saya',
                          style: AppText.heading.copyWith(color: Colors.white, fontSize: 24),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _cart.isEmpty
                              ? 'Belum ada item'
                              : '${_cart.totalQty} item dalam keranjang',
                          style: TextStyle(color: Colors.white.o(0.8), fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                  if (!_cart.isEmpty)
                    TextButton.icon(
                      onPressed: _cart.clear,
                      style: TextButton.styleFrom(foregroundColor: AppColors.gold),
                      icon: const Icon(Icons.delete_outline_rounded, size: 20),
                      label: const Text('Kosongkan'),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      children: [
        // Daftar item. Geser ke kiri untuk menghapus.
        for (final line in _cart.lines) ...[
          _buildLine(line),
          const SizedBox(height: 12),
        ],
        const SizedBox(height: 8),
        Text('Data Pemesan', style: AppText.title),
        const SizedBox(height: 10),
        _field(_nameController, 'Nama pemesan', Icons.person_outline_rounded),
        const SizedBox(height: 10),
        _field(
          _tableController,
          'Nomor meja',
          Icons.table_restaurant_outlined,
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 20),
        _buildSummary(),
        const SizedBox(height: 16),
        ElevatedButton.icon(
          onPressed: _checkout,
          icon: const Icon(Icons.check_rounded),
          label: Text('Pesan Sekarang  -  ${formatRupiah(_cart.total)}'),
        ),
      ],
    );
  }

  Widget _buildLine(CartLine line) {
    return Dismissible(
      key: ValueKey(line.key),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => _cart.remove(line),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 22),
        decoration: BoxDecoration(
          color: Colors.red.shade400,
          borderRadius: BorderRadius.circular(18),
        ),
        child: const Icon(Icons.delete_rounded, color: Colors.white),
      ),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: cardDecoration(),
        child: Row(
          children: [
            SizedBox(
              width: 70,
              height: 70,
              child: MenuImage(
                item: line.item,
                borderRadius: BorderRadius.circular(14),
                iconSize: 26,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    line.item.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppText.title,
                  ),
                  Text(line.size.label, style: AppText.caption),
                  const SizedBox(height: 4),
                  Text(
                    formatRupiah(line.subtotal),
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      color: AppColors.armyGreen,
                    ),
                  ),
                ],
              ),
            ),
            _qtyButton(Icons.remove_rounded, () => _cart.decrement(line)),
            SizedBox(
              width: 30,
              child: Center(
                child: Text(
                  '${line.qty}',
                  style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15),
                ),
              ),
            ),
            _qtyButton(Icons.add_rounded, () => _cart.increment(line)),
          ],
        ),
      ),
    );
  }

  Widget _qtyButton(IconData icon, VoidCallback onTap) => InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            color: AppColors.armyGreen.o(0.12),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, size: 18, color: AppColors.armyGreen),
        ),
      );

  Widget _field(
    TextEditingController controller,
    String hint,
    IconData icon, {
    TextInputType? keyboardType,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.divider),
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        style: AppText.body,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: AppColors.brown.o(0.5), fontSize: 14),
          prefixIcon: Icon(icon, color: AppColors.armyGreen),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 14),
        ),
      ),
    );
  }

  Widget _buildSummary() {
    Widget row(String label, String value, {bool bold = false}) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  style: AppText.body.copyWith(
                    fontWeight: bold ? FontWeight.w800 : FontWeight.w500,
                    fontSize: bold ? 16 : 14,
                  ),
                ),
              ),
              Text(
                value,
                style: TextStyle(
                  fontWeight: bold ? FontWeight.w800 : FontWeight.w600,
                  fontSize: bold ? 18 : 14,
                  color: bold ? AppColors.armyGreen : AppColors.brown,
                ),
              ),
            ],
          ),
        );

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: cardDecoration(),
      child: Column(
        children: [
          row('Subtotal', formatRupiah(_cart.subtotal)),
          row('Pajak (10%)', formatRupiah(_cart.tax)),
          const Divider(color: AppColors.divider, height: 18),
          row('Total Pembayaran', formatRupiah(_cart.total), bold: true),
        ],
      ),
    );
  }
}
