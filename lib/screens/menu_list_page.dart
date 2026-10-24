import 'package:flutter/material.dart';

import '../models/menu_item.dart';
import '../services/menu_filter_controller.dart';
import '../services/menu_repository.dart';
import '../theme/app_theme.dart';
import '../widgets/coffee_bean_pattern.dart';
import '../widgets/common_widgets.dart';
import '../widgets/menu_cards.dart';
import 'menu_detail_page.dart';

/// HALAMAN 2 - DAFTAR MENU
/// Menampilkan seluruh menu dengan filter kategori + pencarian.
/// Tampilan dapat dialihkan antara GridView.builder dan ListView.builder.
class MenuListPage extends StatefulWidget {
  final MenuFilterController filter;

  const MenuListPage({super.key, required this.filter});

  @override
  State<MenuListPage> createState() => _MenuListPageState();
}

class _MenuListPageState extends State<MenuListPage> {
  final TextEditingController _searchController = TextEditingController();
  bool _isGrid = true;

  @override
  void initState() {
    super.initState();
    widget.filter.addListener(_syncFromFilter);
    _searchController.text = widget.filter.query;
  }

  @override
  void dispose() {
    widget.filter.removeListener(_syncFromFilter);
    _searchController.dispose();
    super.dispose();
  }

  /// Dipanggil saat filter diubah dari luar (mis. dari Beranda).
  void _syncFromFilter() {
    if (_searchController.text != widget.filter.query) {
      _searchController.text = widget.filter.query;
    }
    setState(() {});
  }

  void _openDetail(MenuItem item) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => MenuDetailPage(item: item)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final items = MenuRepository.instance.search(
      category: widget.filter.category,
      query: widget.filter.query,
    );

    return Column(
      children: [
        _buildHeader(context),
        _buildCategoryChips(),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 8),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text('${items.length} menu ditemukan', style: AppText.caption),
          ),
        ),
        Expanded(
          child: items.isEmpty
              ? EmptyState(
                  icon: Icons.search_off_rounded,
                  title: 'Menu tidak ditemukan',
                  message: 'Coba kata kunci lain atau pilih kategori yang berbeda.',
                  action: OutlinedButton(
                    onPressed: () => widget.filter.apply(),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.armyGreen,
                      side: const BorderSide(color: AppColors.armyGreen),
                    ),
                    child: const Text('Reset filter'),
                  ),
                )
              : (_isGrid ? _buildGrid(items) : _buildList(items)),
        ),
      ],
    );
  }

  // ----------------------------------------------------------- header
  Widget _buildHeader(BuildContext context) {
    const radius = BorderRadius.vertical(bottom: Radius.circular(28));
    return ClipRRect(
      borderRadius: radius,
      child: Container(
        width: double.infinity,
        color: AppColors.armyGreen,
        child: CoffeeBeanPattern(
          beanColor: Colors.white.o(0.08),
          creaseColor: Colors.white.o(0.15),
          count: 10,
          seed: 11,
          child: SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 14, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Daftar Menu',
                          style: AppText.heading.copyWith(color: Colors.white, fontSize: 24),
                        ),
                      ),
                      // Tombol pengalih tampilan Grid <-> List
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white.o(0.16),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            _viewToggle(Icons.grid_view_rounded, true),
                            _viewToggle(Icons.view_list_rounded, false),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.cream,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: TextField(
                      controller: _searchController,
                      onChanged: widget.filter.setQuery,
                      style: AppText.body,
                      decoration: InputDecoration(
                        hintText: 'Cari nama menu atau bahan...',
                        hintStyle: TextStyle(color: AppColors.brown.o(0.5), fontSize: 14),
                        prefixIcon: const Icon(Icons.search_rounded, color: AppColors.armyGreen),
                        suffixIcon: widget.filter.query.isEmpty
                            ? null
                            : IconButton(
                                icon: const Icon(Icons.close_rounded, color: AppColors.brown),
                                onPressed: () => widget.filter.setQuery(''),
                              ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(vertical: 14),
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

  Widget _viewToggle(IconData icon, bool gridMode) {
    final active = _isGrid == gridMode;
    return InkWell(
      onTap: () => setState(() => _isGrid = gridMode),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(9),
        decoration: BoxDecoration(
          color: active ? AppColors.gold : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          icon,
          size: 20,
          color: active ? AppColors.beanDark : Colors.white,
        ),
      ),
    );
  }

  // ---------------------------------------------------- category chips
  Widget _buildCategoryChips() {
    final selected = widget.filter.category;
    return SizedBox(
      height: 58,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        children: [
          _chip(
            label: 'Semua',
            icon: Icons.apps_rounded,
            isSelected: selected == null,
            onTap: () => widget.filter.setCategory(null),
          ),
          for (final c in MenuCategory.values)
            _chip(
              label: c.label,
              icon: c.icon,
              isSelected: selected == c,
              onTap: () => widget.filter.setCategory(c),
            ),
        ],
      ),
    );
  }

  Widget _chip({
    required String label,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        avatar: Icon(
          icon,
          size: 18,
          color: isSelected ? Colors.white : AppColors.armyGreen,
        ),
        label: Text(label),
        selected: isSelected,
        showCheckmark: false,
        onSelected: (_) => onTap(),
        selectedColor: AppColors.armyGreen,
        backgroundColor: Colors.white,
        side: BorderSide(color: isSelected ? AppColors.armyGreen : AppColors.divider),
        labelStyle: TextStyle(
          fontWeight: FontWeight.w700,
          color: isSelected ? Colors.white : AppColors.brown,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
    );
  }

  // -------------------------------------------------------- grid / list
  /// GridView.builder responsif: jumlah kolom menyesuaikan lebar layar
  /// berkat maxCrossAxisExtent (HP = 2 kolom, tablet = 3-5 kolom).
  Widget _buildGrid(List<MenuItem> items) {
    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 210,
        mainAxisSpacing: 14,
        crossAxisSpacing: 14,
        childAspectRatio: 0.72,
      ),
      itemCount: items.length,
      itemBuilder: (context, i) => MenuGridCard(
        item: items[i],
        onTap: () => _openDetail(items[i]),
      ),
    );
  }

  Widget _buildList(List<MenuItem> items) {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
      itemCount: items.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, i) => MenuListTile(
        item: items[i],
        onTap: () => _openDetail(items[i]),
      ),
    );
  }
}
