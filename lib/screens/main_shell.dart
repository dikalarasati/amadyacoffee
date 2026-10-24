import 'package:flutter/material.dart';

import '../services/cart_controller.dart';
import '../services/menu_filter_controller.dart';
import '../theme/app_theme.dart';
import '../widgets/common_widgets.dart';
import 'cart_page.dart';
import 'home_page.dart';
import 'menu_list_page.dart';
import '../models/menu_item.dart';

/// Indeks tab aktif. Dibuat global agar halaman lain (mis. Detail) dapat
/// berpindah tab, contoh: bottomNavIndex.value = NavTab.cart.
final ValueNotifier<int> bottomNavIndex = ValueNotifier<int>(NavTab.home);

class NavTab {
  NavTab._();
  static const int home = 0;
  static const int menu = 1;
  static const int cart = 2;
}

/// Kerangka utama aplikasi: BottomNavigationBar + 3 tab.
/// Halaman ke-4 (Detail Menu) dibuka dengan Navigator.push di atas kerangka ini.
class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  final MenuFilterController _filter = MenuFilterController();

  @override
  void dispose() {
    _filter.dispose();
    super.dispose();
  }

  void _goToMenu({MenuCategory? category, String query = ''}) {
    _filter.apply(category: category, query: query);
    bottomNavIndex.value = NavTab.menu;
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: bottomNavIndex,
      builder: (context, index, _) {
        return Scaffold(
          // IndexedStack menjaga state tiap tab (scroll, input) saat berpindah.
          body: IndexedStack(
            index: index,
            children: [
              HomePage(
                onCategoryTap: (c) => _goToMenu(category: c),
                onSearch: (q) => _goToMenu(query: q),
                onSeeAll: () => _goToMenu(),
                onOpenCart: () => bottomNavIndex.value = NavTab.cart,
              ),
              MenuListPage(filter: _filter),
              CartPage(
                onBrowseMenu: () => _goToMenu(),
                onOrderDone: () => bottomNavIndex.value = NavTab.home,
              ),
            ],
          ),
          bottomNavigationBar: Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: AppColors.brown.o(0.10),
                  blurRadius: 16,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: BottomNavigationBar(
              currentIndex: index,
              onTap: (i) => bottomNavIndex.value = i,
              type: BottomNavigationBarType.fixed,
              backgroundColor: Colors.white,
              selectedItemColor: AppColors.armyGreen,
              unselectedItemColor: AppColors.brown.o(0.55),
              selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w700),
              items: [
                const BottomNavigationBarItem(
                  icon: Icon(Icons.home_outlined),
                  activeIcon: Icon(Icons.home_rounded),
                  label: 'Beranda',
                ),
                const BottomNavigationBarItem(
                  icon: Icon(Icons.restaurant_menu_outlined),
                  activeIcon: Icon(Icons.restaurant_menu_rounded),
                  label: 'Menu',
                ),
                BottomNavigationBarItem(
                  icon: CartBadgeIcon(
                    color: AppColors.brown.o(0.55),
                    icon: Icons.shopping_bag_outlined,
                  ),
                  activeIcon: const CartBadgeIcon(
                    color: AppColors.armyGreen,
                    icon: Icons.shopping_bag_rounded,
                  ),
                  label: 'Keranjang',
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// Dipakai halaman Detail untuk kembali ke root lalu membuka tab Keranjang.
void openCartFromAnywhere(BuildContext context) {
  Navigator.of(context).popUntil((route) => route.isFirst);
  bottomNavIndex.value = NavTab.cart;
}

/// Jumlah item di keranjang (helper untuk widget lain).
int get cartItemCount => CartController.instance.totalQty;
