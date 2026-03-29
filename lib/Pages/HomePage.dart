// HomePage.dart
import 'package:flutter/material.dart';
import 'package:sparioapp/Core/Theme/app_colors.dart';
import 'package:sparioapp/Pages/ExpertsPage.dart';
import 'package:sparioapp/Pages/MyOrders.dart';
import 'package:sparioapp/Pages/Profile.dart';
import 'package:sparioapp/Widgets/CustomSearchBar.dart';
import 'package:sparioapp/Widgets/Drawar.dart';
import '../Services/BottomSheetResults.dart';
import '../Widgets/AdsSlider.dart';
import '../Widgets/CompaniesList.dart';
import '../Widgets/directProduct.dart';
import '../Widgets/SuggsetProductList.dart';
import '../Widgets/CurvedBottomNavigationBar.dart';
import 'OrdersPartCarPage.dart';
import '../Pages/FavoritePage.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final controller = TextEditingController();
  int _selectedIndex = 0;

  List<Map<String, String>> favorites = [];

  // مثال بيانات منتجات
  final List<Map<String, String>> _products = [
    {"name": "Toyota Brake Pads", "image": "assets/1.JPG"},
    {"name": "BMW Oil Filter", "image": "assets/1.JPG"},
    {"name": "Mercedes Air Filter", "image": "assets/1.JPG"},
  ];

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();

    _pages = [
      ListView(
        padding: const EdgeInsets.all(12),
        children: [
          // البحث
          CustomSearch(
            hintText: "Search ...",
            controller: controller,
            onChanged: (value) {
              if (value.isNotEmpty) {
                final results = _products
                    .where(
                      (p) => p["name"]!.toLowerCase().contains(
                        value.toLowerCase(),
                      ),
                    )
                    .toList();
                SearchResultsBottomSheet.show(context, results);
              }
            },
            onSubmitted: (value) {
              if (value.isNotEmpty) {
                final results = _products
                    .where(
                      (p) => p["name"]!.toLowerCase().contains(
                        value.toLowerCase(),
                      ),
                    )
                    .toList();
                SearchResultsBottomSheet.show(context, results);
              }
            },
          ),
          const SizedBox(height: 20),
          const AdsSliderWidget(),
          const SizedBox(height: 20),
          const CompanyListWidget(),
          const SizedBox(height: 20),
          const DirectProductsListWidget(),
          const SizedBox(height: 20),
          // Suggested products with favorites
          SuggestedProductsListWidget(
            products: _products,
            favorites: favorites,
            onAddToFavorites: (product) {
              setState(() {
                if (!favorites.contains(product)) favorites.add(product);
              });
            },
          ),
          const SizedBox(height: 20),
        ],
      ),
      const ExpertCardDesign(),
      FavoritesPage(favorites: favorites), // dynamic favorites page
      const MyOrders(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      endDrawer: _selectedIndex == 0 ? HomeDrawer() : null,
      backgroundColor: AppColors.backgroundLight,

      appBar: _selectedIndex == 0
          ? AppBar(
              leadingWidth: 100,
              leading: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pushNamed(context, "/notification");
                    },
                    icon: const Icon(Icons.notifications),
                    color: Colors.black,
                    iconSize: 28,
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.qr_code_scanner),
                    color: Colors.orange,
                    iconSize: 28,
                  ),
                ],
              ),
              centerTitle: true,
              backgroundColor: AppColors.background,
              title: const Text("Spairo"),
            )
          : null,

      body: _pages[_selectedIndex],

      // bottomNavigationBar already includes the FAB, so we no longer need Scaffold's FAB
      bottomNavigationBar: CurvedBottomNavigationBar(
        currentIndex: _selectedIndex,
        onItemSelected: (index) => setState(() => _selectedIndex = index),
        onFabTapped: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) {
                return OrdersPartCarPage();
              },
            ),
          );
        },
      ),
    );
  }
}
