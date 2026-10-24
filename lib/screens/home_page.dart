import 'package:flutter/material.dart';

import '../models/menu_item.dart';
import '../services/menu_repository.dart';
import '../theme/app_theme.dart';
import '../widgets/coffee_bean_pattern.dart';
import '../widgets/common_widgets.dart';
import '../widgets/menu_cards.dart';
import 'menu_detail_page.dart';

/// HALAMAN 1 - BERANDA
/// Header sambutan + search bar, kategori menu, dan rekomendasi Best Seller.
class HomePage extends StatefulWidget {
  final ValueChanged<MenuCategory> onCategoryTap;
  final ValueChanged<String> onSearch;
  final VoidCallback onSeeAll;
  final VoidCallback onOpenCart;

  const HomePage({
    super.key,
    required this.onCategoryTap,
    required this.onSearch,
    required this.onSeeAll,
    required this.onOpenCart,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _submitSearch(String value) {
    widget.onSearch(value);
    _searchController.clear();
    FocusScope.of(context).unfocus();
  }

  void _openDetail(MenuItem item) {
    // Passing data antarhalaman: objek MenuItem dikirim lewat konstruktor.
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => MenuDetailPage(item: item)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bestSellers = MenuRepository.instance.bestSellers;

    return ListView(
      padding: EdgeInsets.zero,
      children: [
        _buildHeader(context),
        const SectionHeader(title: 'Kategori Menu'),
        _buildCategories(),
        SectionHeader(
          title: 'Best Seller',
          actionLabel: 'Lihat semua',
          onAction: widget.onSeeAll,
        ),
        SizedBox(
          height: 250,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
            itemCount: bestSellers.length,
            separatorBuilder: (_, __) => const SizedBox(width: 14),
            itemBuilder: (context, i) => SizedBox(
              width: 172,
              child: MenuGridCard(
                item: bestSellers[i],
                onTap: () => _openDetail(bestSellers[i]),
              ),
            ),
          ),
        ),
        const SizedBox(height: 24),
        _buildBanner(),
        const SizedBox(height: 28),
      ],
    );
  }

  // ----------------------------------------------------------- header
  Widget _buildHeader(BuildContext context) {
    const radius = BorderRadius.vertical(bottom: Radius.circular(32));
    return ClipRRect(
      borderRadius: radius,
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.armyGreenLight, AppColors.armyGreen, AppColors.armyGreenDark],
          ),
        ),
        // Motif biji kopi sebagai dekorasi latar header.
        child: CoffeeBeanPattern(
          beanColor: Colors.white.o(0.09),
          creaseColor: Colors.white.o(0.16),
          count: 16,
          seed: 21,
          child: SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: Colors.white.o(0.16),
                          shape: BoxShape.circle,
                        ),
                        child: const Center(child: CoffeeBeanIcon(size: 18)),
                      ),
                      const SizedBox(width: 10),
                      const Expanded(
                        child: Text(
                          'Amadya Coffee & Eatery',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                            letterSpacing: 0.3,
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: widget.onOpenCart,
                        borderRadius: BorderRadius.circular(22),
                        child: Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: Colors.white.o(0.16),
                            shape: BoxShape.circle,
                          ),
                          child: const Center(child: CartBadgeIcon()),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 22),
                  Text(
                    'Mau ngopi apa\nhari ini, Kak?',
                    style: AppText.heading.copyWith(
                      color: Colors.white,
                      fontSize: 30,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Pilih menu favoritmu, kami siapkan dengan hangat.',
                    style: TextStyle(color: Colors.white.o(0.8), fontSize: 13),
                  ),
                  const SizedBox(height: 18),
                  // Search bar
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.cream,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: TextField(
                      controller: _searchController,
                      textInputAction: TextInputAction.search,
                      onSubmitted: _submitSearch,
                      style: AppText.body,
                      decoration: InputDecoration(
                        hintText: 'Cari kopi, makanan, atau dessert...',
                        hintStyle: TextStyle(color: AppColors.brown.o(0.5), fontSize: 14),
                        prefixIcon: const Icon(Icons.search_rounded, color: AppColors.armyGreen),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.arrow_forward_rounded, color: AppColors.gold),
                          onPressed: () => _submitSearch(_searchController.text),
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(vertical: 15),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // -------------------------------------------------------- categories
  Widget _buildCategories() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Row(
        children: MenuCategory.values.map((c) {
          return Expanded(
            child: InkWell(
              onTap: () => widget.onCategoryTap(c),
              borderRadius: BorderRadius.circular(16),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Column(
                  children: [
                    Container(
                      width: 62,
                      height: 62,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppColors.divider),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.brown.o(0.07),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Icon(c.icon, color: AppColors.armyGreen, size: 28),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      c.shortLabel,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppColors.brown,
                      ),
                    ),
                    Text(
                      '${MenuRepository.instance.countIn(c)} menu',
                      style: AppText.caption.copyWith(fontSize: 10),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  // ------------------------------------------------------------ banner
  Widget _buildBanner() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: InkWell(
        onTap: widget.onSeeAll,
        borderRadius: BorderRadius.circular(22),
        child: Ink(
          decoration: BoxDecoration(
            color: AppColors.brown,
            borderRadius: BorderRadius.circular(22),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(22),
            child: CoffeeBeanPattern(
              beanColor: Colors.white.o(0.07),
              creaseColor: Colors.white.o(0.14),
              count: 10,
              seed: 3,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Belum tahu mau pesan apa?',
                            style: AppText.heading.copyWith(
                              color: Colors.white,
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Jelajahi seluruh menu kopi, makanan, dan dessert kami.',
                            style: TextStyle(color: Colors.white.o(0.8), fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      width: 44,
                      height: 44,
                      decoration: const BoxDecoration(
                        color: AppColors.gold,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.arrow_forward_rounded, color: AppColors.beanDark),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
