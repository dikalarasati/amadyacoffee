import '../models/menu_item.dart';

/// Ukuran standar per jenis menu, dipakai ulang supaya data tidak berulang.
const List<PortionSize> _drinkSizes = [
  PortionSize('Regular (12 oz)'),
  PortionSize('Large (16 oz)', 6000),
];

const List<PortionSize> _foodSizes = [
  PortionSize('Porsi Normal'),
  PortionSize('Porsi Jumbo', 10000),
];

const List<PortionSize> _pastrySizes = [
  PortionSize('1 Potong'),
  PortionSize('Sharing (2 Potong)', 18000),
];

/// DATA DUMMY menu Amadya Coffee & Eatery.
///
/// Struktur sudah mengikuti model [MenuItem] (termasuk toJson/fromJson),
/// sehingga pada tahap berikutnya list ini dapat diganti dengan hasil
/// permintaan HTTP ke API tanpa mengubah kode UI.
/// Nilai [imageUrl] sengaja dikosongkan: UI otomatis menampilkan
/// ilustrasi bermotif biji kopi. Isi dengan URL / path gambar jika ada.
const List<MenuItem> dummyMenu = [
  // ----------------------------- COFFEE -----------------------------
  MenuItem(
    id: 'cf-01',
    name: 'Kopi Susu Amadya',
    category: MenuCategory.coffee,
    price: 22000,
    description:
        'Signature kami. Espresso berpadu susu segar dan gula aren, manis '
        'lembut dengan aroma karamel yang hangat.',
    ingredients: ['Espresso', 'Susu segar', 'Gula aren', 'Es batu'],
    sizes: _drinkSizes,
    rating: 4.9,
    reviewCount: 312,
    isBestSeller: true,
  ),
  MenuItem(
    id: 'cf-02',
    name: 'Caffe Latte',
    category: MenuCategory.coffee,
    price: 26000,
    description:
        'Perpaduan espresso dan susu steamed yang creamy dengan lapisan '
        'foam tipis. Rasa kopinya lembut dan seimbang.',
    ingredients: ['Espresso', 'Susu steamed', 'Milk foam'],
    sizes: _drinkSizes,
    rating: 4.7,
    reviewCount: 188,
    isBestSeller: true,
  ),
  MenuItem(
    id: 'cf-03',
    name: 'Americano',
    category: MenuCategory.coffee,
    price: 20000,
    description:
        'Espresso yang diseduh dengan air panas. Body ringan, pahit bersih, '
        'cocok untuk penikmat kopi hitam.',
    ingredients: ['Espresso', 'Air panas'],
    sizes: _drinkSizes,
    rating: 4.5,
    reviewCount: 96,
  ),
  MenuItem(
    id: 'cf-04',
    name: 'Cappuccino',
    category: MenuCategory.coffee,
    price: 25000,
    description:
        'Espresso dengan susu dan foam tebal. Rasa kopi lebih tegas dengan '
        'tekstur lembut di setiap tegukan.',
    ingredients: ['Espresso', 'Susu steamed', 'Foam tebal', 'Bubuk kakao'],
    sizes: _drinkSizes,
    rating: 4.6,
    reviewCount: 141,
  ),
  MenuItem(
    id: 'cf-05',
    name: 'Caramel Macchiato',
    category: MenuCategory.coffee,
    price: 30000,
    description:
        'Susu vanila dingin dengan shot espresso di atasnya dan siraman '
        'saus karamel. Manis, gurih, dan wangi.',
    ingredients: ['Espresso', 'Susu', 'Sirup vanila', 'Saus karamel'],
    sizes: _drinkSizes,
    rating: 4.8,
    reviewCount: 205,
    isBestSeller: true,
  ),
  // --------------------------- NON-COFFEE ---------------------------
  MenuItem(
    id: 'nc-01',
    name: 'Matcha Latte',
    category: MenuCategory.nonCoffee,
    price: 27000,
    description:
        'Matcha premium dikocok dengan susu segar. Rasa earthy yang creamy '
        'dan menenangkan, tanpa pahit berlebih.',
    ingredients: ['Bubuk matcha', 'Susu segar', 'Gula cair'],
    sizes: _drinkSizes,
    rating: 4.7,
    reviewCount: 167,
    isBestSeller: true,
  ),
  MenuItem(
    id: 'nc-02',
    name: 'Chocolate Signature',
    category: MenuCategory.nonCoffee,
    price: 25000,
    description:
        'Cokelat pekat dengan susu dan sedikit garam laut. Hangat, '
        'legit, dan mengenyangkan.',
    ingredients: ['Dark chocolate', 'Susu', 'Garam laut', 'Whipped cream'],
    sizes: _drinkSizes,
    rating: 4.6,
    reviewCount: 120,
  ),
  MenuItem(
    id: 'nc-03',
    name: 'Lychee Tea',
    category: MenuCategory.nonCoffee,
    price: 22000,
    description:
        'Teh dingin beraroma bunga dengan buah leci. Segar, ringan, dan '
        'pas untuk siang yang terik.',
    ingredients: ['Teh hitam', 'Buah leci', 'Sirup leci', 'Es batu'],
    sizes: _drinkSizes,
    rating: 4.4,
    reviewCount: 74,
  ),
  MenuItem(
    id: 'nc-04',
    name: 'Red Velvet Latte',
    category: MenuCategory.nonCoffee,
    price: 27000,
    description:
        'Minuman susu rasa red velvet dengan krim keju tipis. Manis lembut '
        'dengan sentuhan asam yang khas.',
    ingredients: ['Bubuk red velvet', 'Susu', 'Cream cheese foam'],
    sizes: _drinkSizes,
    rating: 4.5,
    reviewCount: 88,
  ),
  // -------------------------- MAIN COURSE ---------------------------
  MenuItem(
    id: 'mc-01',
    name: 'Nasi Goreng Amadya',
    category: MenuCategory.mainCourse,
    price: 32000,
    description:
        'Nasi goreng bumbu rempah dengan ayam suwir, telur mata sapi, '
        'acar, dan kerupuk. Gurih dan sedikit pedas.',
    ingredients: ['Nasi', 'Ayam suwir', 'Telur', 'Bumbu rempah', 'Acar'],
    sizes: _foodSizes,
    rating: 4.8,
    reviewCount: 233,
    isBestSeller: true,
  ),
  MenuItem(
    id: 'mc-02',
    name: 'Chicken Katsu Rice',
    category: MenuCategory.mainCourse,
    price: 35000,
    description:
        'Ayam fillet berbalut tepung panko renyah, disajikan dengan nasi '
        'hangat, saus katsu, dan salad segar.',
    ingredients: ['Ayam fillet', 'Tepung panko', 'Nasi', 'Saus katsu', 'Salad'],
    sizes: _foodSizes,
    rating: 4.7,
    reviewCount: 176,
  ),
  MenuItem(
    id: 'mc-03',
    name: 'Spaghetti Aglio Olio',
    category: MenuCategory.mainCourse,
    price: 34000,
    description:
        'Spaghetti dengan bawang putih, cabai, dan minyak zaitun. '
        'Sederhana, harum, dan sedikit pedas.',
    ingredients: ['Spaghetti', 'Bawang putih', 'Cabai', 'Olive oil', 'Parsley'],
    sizes: _foodSizes,
    rating: 4.5,
    reviewCount: 82,
  ),
  MenuItem(
    id: 'mc-04',
    name: 'Chicken Sandwich',
    category: MenuCategory.mainCourse,
    price: 30000,
    description:
        'Roti panggang isi ayam panggang, selada, tomat, dan saus mayo '
        'mustard. Cocok untuk makan ringan.',
    ingredients: ['Roti sourdough', 'Ayam panggang', 'Selada', 'Tomat', 'Mayo'],
    sizes: _foodSizes,
    rating: 4.4,
    reviewCount: 64,
  ),
  // ------------------------ PASTRY & DESSERT ------------------------
  MenuItem(
    id: 'ps-01',
    name: 'Butter Croissant',
    category: MenuCategory.pastry,
    price: 20000,
    description:
        'Croissant berlapis dengan kulit renyah dan bagian dalam yang '
        'lembut beraroma mentega. Nikmat bersama kopi.',
    ingredients: ['Tepung', 'Butter', 'Ragi', 'Garam'],
    sizes: _pastrySizes,
    rating: 4.6,
    reviewCount: 109,
  ),
  MenuItem(
    id: 'ps-02',
    name: 'Tiramisu Cake',
    category: MenuCategory.pastry,
    price: 32000,
    description:
        'Kue lapis dengan krim mascarpone dan sponge yang dicelup kopi, '
        'ditaburi kakao. Manis dan sedikit pahit.',
    ingredients: ['Mascarpone', 'Ladyfinger', 'Espresso', 'Bubuk kakao'],
    sizes: _pastrySizes,
    rating: 4.9,
    reviewCount: 198,
    isBestSeller: true,
  ),
  MenuItem(
    id: 'ps-03',
    name: 'Banana Choco Toast',
    category: MenuCategory.pastry,
    price: 24000,
    description:
        'Roti tebal panggang dengan pisang, saus cokelat, dan taburan '
        'kacang. Hangat dan mengenyangkan.',
    ingredients: ['Roti tebal', 'Pisang', 'Saus cokelat', 'Kacang cincang'],
    sizes: _pastrySizes,
    rating: 4.5,
    reviewCount: 71,
  ),
  MenuItem(
    id: 'ps-04',
    name: 'Cheesecake Blueberry',
    category: MenuCategory.pastry,
    price: 30000,
    description:
        'Cheesecake lembut di atas dasar biskuit dengan saus blueberry '
        'segar. Creamy dengan sentuhan asam manis.',
    ingredients: ['Cream cheese', 'Biskuit', 'Blueberry', 'Gula'],
    sizes: _pastrySizes,
    rating: 4.7,
    reviewCount: 95,
  ),
];
