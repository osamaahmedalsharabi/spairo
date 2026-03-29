import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sparioapp/Core/di/injection_container.dart';
import 'package:sparioapp/Widgets/CurvedBottomNavigationBar.dart';
import 'package:sparioapp/Widgets/custom_alert_dialog_widget.dart';
import 'package:sparioapp/feature/Authantication/data/datasources/auth_local_data_source.dart';
import 'package:sparioapp/feature/user_feature/home/presentation/view_model/get_brands/get_brands_cubit.dart';
import 'package:sparioapp/feature/user_feature/home/presentation/view_model/get_categories/get_categories_cubit.dart';
import 'package:sparioapp/feature/user_feature/part_order/presentation/view/part_order_view.dart';
import 'package:sparioapp/feature/user_feature/products/presentation/view_model/products_cubit.dart';
import 'widgets/drawer_widget.dart';
import 'widgets/home_app_bar_widget.dart';
import 'widgets/home_search_section.dart';
import 'widgets/home_brands_section.dart';
import 'widgets/home_categories_section.dart';
import 'widgets/home_recommendations_section.dart';
import 'widgets/contact_management_bottom_sheet.dart';
import 'package:sparioapp/feature/user_feature/experts/presentation/view/experts_view.dart';
import 'package:sparioapp/feature/user_feature/part_order/presentation/view/orders_history/orders_history_view.dart';
import 'package:sparioapp/feature/user_feature/favorites/presentation/view/favorites_view.dart';

class UserHomeView extends StatefulWidget {
  const UserHomeView({super.key});

  @override
  State<UserHomeView> createState() => _UserHomeViewState();
}

class _UserHomeViewState extends State<UserHomeView> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const _HomeContent(),
    const ExpertsView(),
    const OrdersHistoryView(),
    const FavoritesView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      drawer: const DrawerWidget(),
      appBar: HomeAppBarWidget(), // Show AppBar only on Home
      body: _pages[_selectedIndex],
      bottomNavigationBar: CurvedBottomNavigationBar(
        currentIndex: _selectedIndex,
        onItemSelected: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        onFabTapped: () async {
          final authLocalDS = sl.get<AuthLocalDataSource>();
          final user = await authLocalDS.getUser();
          if (user == null) {
            CustomAlertDialogWidget.show(
              context: context,
              title: "تنبيه",
              content: "يجب تسجيل الدخول للوصول إلى هذه الميزة",
              primaryButtonText: "الغاء",
              secondaryButtonText: "تسجيل الدخول",
              icon: Icons.info_outline,
              onSecondaryPressed: () {
                Navigator.pop(context);
                context.push("/login");
              },
            );
          } else if (!user.isActive) {
            CustomAlertDialogWidget.show(
              context: context,
              title: "تنبيه",
              content:
                  "سوف يتم مراجعة حسابك قريبا لكي تتمكن من استخدام الميزة او يمكنك التواصل مع إدارة التطبيق",
              primaryButtonText: "حسنا",
              secondaryButtonText: "تواصل مع الإدارة",
              icon: Icons.info_outline,
              onSecondaryPressed: () {
                Navigator.pop(context);
                showContactManagementBottomSheet(context);
              },
            );
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return const PartOrderView();
                },
              ),
            );
          }
        },
      ),
    );
  }
}

class _HomeContent extends StatelessWidget {
  const _HomeContent();

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        BlocProvider.of<GetBrandsCubit>(context).getBrands();

        if (context.mounted) {
          BlocProvider.of<GetCategoriesCubit>(context).getCategories();
        }
        if (context.mounted) {
          BlocProvider.of<ProductsCubit>(context).getAllProducts();
        }
      },
      child: SingleChildScrollView(
        child: Column(
          children: const [
            SizedBox(height: 16),
            HomeSearchSection(),
            SizedBox(height: 24),
            HomeBrandsSection(),
            SizedBox(height: 24),
            HomeCategoriesSection(),
            SizedBox(height: 24),
            HomeRecommendationsSection(),
            SizedBox(height: 120),
          ],
        ),
      ),
    );
  }
}
