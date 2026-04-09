import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sparioapp/Core/routing/app_route_const.dart';
import 'package:sparioapp/Core/routing/page_transitions.dart';
import 'package:sparioapp/Core/di/injection_container.dart';
import 'package:sparioapp/Core/widgets/status_bar_widget.dart';
import 'package:sparioapp/feature/user_feature/home/data/models/brand_model.dart';
import 'package:sparioapp/feature/user_feature/home/data/repo/home_repo.dart';
import 'package:sparioapp/feature/user_feature/home/presentation/view_model/get_brand_cars/get_brand_cars_cubit.dart';
import 'package:sparioapp/feature/user_feature/home/presentation/view/brand_cars_view.dart';
import 'package:sparioapp/feature/user_feature/home/presentation/view/car_year_selection_view.dart';
import 'package:sparioapp/feature/user_feature/home/presentation/view/filter_category_selection_view.dart';
import 'package:sparioapp/feature/user_feature/home/presentation/view/brands_view.dart';
import 'package:sparioapp/feature/user_feature/home/presentation/view/categories_view.dart';
import 'package:sparioapp/feature/user_feature/notifications/presentation/view/notifications_view.dart';
import 'package:sparioapp/feature/user_feature/home/presentation/view/user_home_view.dart';
import 'package:sparioapp/feature/user_feature/home/presentation/view_model/get_brands/get_brands_cubit.dart';
import 'package:sparioapp/feature/user_feature/home/presentation/view_model/get_categories/get_categories_cubit.dart';
import 'package:sparioapp/feature/user_feature/products/presentation/view/supplier_products_view.dart';
import 'package:sparioapp/feature/user_feature/products/presentation/view/add_edit_product_view.dart';
import 'package:sparioapp/feature/user_feature/products/presentation/view/product_details_view.dart';
import 'package:sparioapp/feature/user_feature/products/presentation/view/filtered_products_view.dart';
import 'package:sparioapp/feature/user_feature/products/presentation/view/price_comparison_view.dart';
import 'package:sparioapp/feature/user_feature/products/presentation/view_model/filtered_products_cubit/filtered_products_cubit.dart';
import 'package:sparioapp/feature/user_feature/products/presentation/view/search_products_view.dart';
import 'package:sparioapp/feature/user_feature/products/presentation/view_model/search_products_cubit/search_products_cubit.dart';
import 'package:sparioapp/feature/user_feature/products/domain/repositories/products_repo.dart';
import 'package:sparioapp/feature/user_feature/products/domain/entities/product_entity.dart';
import 'package:sparioapp/feature/user_feature/supplier_reports/presentation/view/supplier_report.dart';
import 'package:sparioapp/feature/user_feature/part_order/presentation/view/orders_history/supplier_orders_page.dart';
import 'package:sparioapp/feature/user_feature/part_order/presentation/view_model/get_user_orders_cubit.dart';
import 'package:sparioapp/feature/user_feature/part_order/data/models/part_order_model.dart';
import 'package:sparioapp/feature/user_feature/checkout/presentation/view/checkout_view.dart';
import 'package:sparioapp/feature/user_feature/part_order/presentation/view/orders_history/order_tracking_view.dart';
import 'package:sparioapp/feature/user_feature/ai_chat/presentation/view/ai_chat_view.dart';
import 'package:sparioapp/feature/user_feature/admin/presentation/view/admin_dashboard_view.dart';
import 'package:sparioapp/feature/user_feature/profile/presentation/view/profile_view.dart';
import 'package:sparioapp/feature/user_feature/profile/presentation/view_model/profile_cubit.dart';
import 'package:sparioapp/feature/Authantication/domain/entities/user_entity.dart';

import '../../feature/WelcomePages/Splash_Screen.dart';
import '../../feature/WelcomePages/first_page.dart';
import '../../feature/WelcomePages/second_page.dart';
import '../../feature/Authantication/Sign_In.dart';
import '../../feature/Authantication/Sign_Up.dart';
import '../../Pages/HomePage.dart';

class AppRouter {
  static final router = GoRouter(
    initialLocation: '/${AppRouteConst.splash}',
    routes: [
      GoRoute(
        path: '/${AppRouteConst.splash}',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          transitionsBuilder: PageTransitions.slideFromLeft,
          transitionDuration: const Duration(milliseconds: 500),
          child: StatusBarWidget(child: const SplashPage()),
        ),
      ),
      GoRoute(
        path: '/${AppRouteConst.welcome1}',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          transitionsBuilder: PageTransitions.slideFromLeft,
          transitionDuration: const Duration(milliseconds: 500),
          child: StatusBarWidget(child: const WelcomeFirstPage()),
        ),
      ),
      GoRoute(
        path: '/${AppRouteConst.welcome2}',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          transitionsBuilder: PageTransitions.slideFromLeft,
          transitionDuration: const Duration(milliseconds: 500),
          child: StatusBarWidget(child: const WelcomeLastPage()),
        ),
      ),
      GoRoute(
        path: '/${AppRouteConst.login}',
        name: AppRouteConst.login,
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          transitionsBuilder: PageTransitions.slideFromLeft,
          transitionDuration: const Duration(milliseconds: 500),
          child: StatusBarWidget(child: LoginPage()),
        ),
      ),
      GoRoute(
        path: '/${AppRouteConst.register}',
        name: AppRouteConst.register,
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          transitionsBuilder: PageTransitions.slideFromLeft,
          transitionDuration: const Duration(milliseconds: 500),
          child: StatusBarWidget(child: RegisterPage()),
        ),
      ),
      GoRoute(
        path: '/${AppRouteConst.home}',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          transitionsBuilder: PageTransitions.slideFromLeft,
          transitionDuration: const Duration(milliseconds: 500),
          child: StatusBarWidget(child: HomePage()),
        ),
      ),
      GoRoute(
        path: '/${AppRouteConst.admin}',
        name: AppRouteConst.admin,
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          transitionsBuilder: PageTransitions.slideFromLeft,
          transitionDuration: const Duration(milliseconds: 500),
          child: StatusBarWidget(
            child: Scaffold(
              appBar: AppBar(title: const Text('لوحة تحكم الإدارة')),
              body: const Center(child: Text('صفحة الإدارة قيد التطوير')),
            ),
          ),
        ),
      ),
      GoRoute(
        path: '/${AppRouteConst.notification}',
        name: AppRouteConst.notification,
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          transitionsBuilder: PageTransitions.slideFromLeft,
          transitionDuration: const Duration(milliseconds: 500),
          child: const StatusBarWidget(child: NotificationsView()),
        ),
      ),
      GoRoute(
        path: '/${AppRouteConst.userHome}',
        name: AppRouteConst.userHome,
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          transitionsBuilder: PageTransitions.slideFromLeft,
          transitionDuration: const Duration(milliseconds: 500),
          child: StatusBarWidget(child: UserHomeView()),
        ),
      ),
      GoRoute(
        path: '/${AppRouteConst.profile}',
        name: AppRouteConst.profile,
        pageBuilder: (context, state) {
          final user = state.extra as UserEntity;
          return CustomTransitionPage(
            key: state.pageKey,
            transitionsBuilder: PageTransitions.slideFromLeft,
            transitionDuration: const Duration(milliseconds: 500),
            child: BlocProvider(
              create: (context) => sl.get<ProfileCubit>(),
              child: StatusBarWidget(child: ProfileView(user: user)),
            ),
          );
        },
      ),
      GoRoute(
        path: '/${AppRouteConst.brandsView}',
        name: AppRouteConst.brandsView,
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          transitionsBuilder: PageTransitions.slideFromLeft,
          transitionDuration: const Duration(milliseconds: 500),
          child: StatusBarWidget(child: BrandsView()),
        ),
      ),
      GoRoute(
        path: '/${AppRouteConst.categoriesView}',
        name: AppRouteConst.categoriesView,
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          transitionsBuilder: PageTransitions.slideFromLeft,
          transitionDuration: const Duration(milliseconds: 500),
          child: StatusBarWidget(child: const CategoriesView()),
        ),
      ),
      GoRoute(
        path: '/${AppRouteConst.brandCarsView}',
        name: AppRouteConst.brandCarsView,
        pageBuilder: (context, state) {
          final brand = state.extra as BrandModel;
          return CustomTransitionPage(
            key: state.pageKey,
            transitionsBuilder: PageTransitions.slideFromLeft,
            transitionDuration: const Duration(milliseconds: 500),
            child: BlocProvider(
              create: (context) =>
                  GetBrandCarsCubit(sl.get<HomeRepoImpl>())
                    ..getBrandCars(brand.id),
              child: StatusBarWidget(child: const BrandCarsView()),
            ),
          );
        },
      ),
      GoRoute(
        path: '/${AppRouteConst.carYearSelectionView}',
        name: AppRouteConst.carYearSelectionView,
        pageBuilder: (context, state) {
          final extra = state.extra as Map<String, dynamic>;
          final brandName = extra['brandName'] as String;
          final carName = extra['carName'] as String;
          return CustomTransitionPage(
            key: state.pageKey,
            transitionsBuilder: PageTransitions.slideFromLeft,
            transitionDuration: const Duration(milliseconds: 500),
            child: StatusBarWidget(
              child: CarYearSelectionView(
                brandName: brandName,
                carName: carName,
              ),
            ),
          );
        },
      ),
      GoRoute(
        path: '/${AppRouteConst.filterCategorySelectionView}',
        name: AppRouteConst.filterCategorySelectionView,
        pageBuilder: (context, state) {
          final extra = state.extra as Map<String, dynamic>;
          final brandName = extra['brandName'] as String;
          final carName = extra['carName'] as String;
          final year = extra['year'] as String;
          return CustomTransitionPage(
            key: state.pageKey,
            transitionsBuilder: PageTransitions.slideFromLeft,
            transitionDuration: const Duration(milliseconds: 500),
            child: BlocProvider(
              create: (context) =>
                  sl.get<GetCategoriesCubit>()..getCategories(),
              child: StatusBarWidget(
                child: FilterCategorySelectionView(
                  brandName: brandName,
                  carName: carName,
                  year: year,
                ),
              ),
            ),
          );
        },
      ),
      GoRoute(
        path: '/${AppRouteConst.supplierProducts}',
        name: AppRouteConst.supplierProducts,
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          transitionsBuilder: PageTransitions.slideFromLeft,
          transitionDuration: const Duration(milliseconds: 500),
          child: StatusBarWidget(child: const SupplierProductsView()),
        ),
      ),
      GoRoute(
        path: '/${AppRouteConst.addEditProduct}',
        name: AppRouteConst.addEditProduct,
        pageBuilder: (context, state) {
          final product = state.extra as ProductEntity?;
          return CustomTransitionPage(
            key: state.pageKey,
            transitionsBuilder: PageTransitions.slideFromLeft,
            transitionDuration: const Duration(milliseconds: 500),
            child: StatusBarWidget(
              child: AddOrEditProductView(product: product),
            ),
          );
        },
      ),
      GoRoute(
        path: '/${AppRouteConst.productDetails}',
        name: AppRouteConst.productDetails,
        pageBuilder: (context, state) {
          final product = state.extra as ProductEntity;
          return CustomTransitionPage(
            key: state.pageKey,
            transitionsBuilder: PageTransitions.slideFromLeft,
            transitionDuration: const Duration(milliseconds: 500),
            child: StatusBarWidget(child: ProductDetailsView(product: product)),
          );
        },
      ),
      GoRoute(
        path: '/${AppRouteConst.supplierReport}',
        name: AppRouteConst.supplierReport,
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          transitionsBuilder: PageTransitions.slideFromLeft,
          transitionDuration: const Duration(milliseconds: 500),
          child: StatusBarWidget(child: const SupplierReport()),
        ),
      ),
      GoRoute(
        path: '/${AppRouteConst.supplierSentOrders}',
        name: AppRouteConst.supplierSentOrders,
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          transitionsBuilder: PageTransitions.slideFromLeft,
          transitionDuration: const Duration(milliseconds: 500),
          child: StatusBarWidget(
            child: SupplierOrdersPage(mode: OrdersMode.sent),
          ),
        ),
      ),
      GoRoute(
        path: '/${AppRouteConst.supplierIncomingOrders}',
        name: AppRouteConst.supplierIncomingOrders,
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          transitionsBuilder: PageTransitions.slideFromLeft,
          transitionDuration: const Duration(milliseconds: 500),
          child: StatusBarWidget(
            child: SupplierOrdersPage(mode: OrdersMode.incoming),
          ),
        ),
      ),
      GoRoute(
        path: '/${AppRouteConst.checkout}',
        name: AppRouteConst.checkout,
        pageBuilder: (context, state) {
          final order = state.extra as PartOrderModel;
          return CustomTransitionPage(
            key: state.pageKey,
            transitionsBuilder: PageTransitions.slideFromLeft,
            transitionDuration: const Duration(milliseconds: 500),
            child: StatusBarWidget(child: CheckoutView(order: order)),
          );
        },
      ),
      GoRoute(
        path: '/${AppRouteConst.orderTracking}',
        name: AppRouteConst.orderTracking,
        pageBuilder: (context, state) {
          final order = state.extra as PartOrderModel;
          return CustomTransitionPage(
            key: state.pageKey,
            transitionsBuilder: PageTransitions.slideFromLeft,
            transitionDuration: const Duration(milliseconds: 500),
            child: StatusBarWidget(child: OrderTrackingView(order: order)),
          );
        },
      ),
      GoRoute(
        path: '/${AppRouteConst.aiChat}',
        name: AppRouteConst.aiChat,
        pageBuilder: (context, state) {
          return CustomTransitionPage(
            key: state.pageKey,
            transitionsBuilder: PageTransitions.slideFromLeft,
            transitionDuration: const Duration(milliseconds: 500),
            child: const StatusBarWidget(child: AiChatView()),
          );
        },
      ),
      GoRoute(
        path: '/${AppRouteConst.adminDashboard}',
        name: AppRouteConst.adminDashboard,
        pageBuilder: (context, state) {
          return CustomTransitionPage(
            key: state.pageKey,
            transitionsBuilder: PageTransitions.slideFromLeft,
            transitionDuration: const Duration(milliseconds: 500),
            child: const StatusBarWidget(child: AdminDashboardView()),
          );
        },
      ),
      GoRoute(
        path: '/${AppRouteConst.priceComparisonView}',
        name: AppRouteConst.priceComparisonView,
        pageBuilder: (context, state) {
          final product = state.extra as ProductEntity;
          return CustomTransitionPage(
            key: state.pageKey,
            transitionsBuilder: PageTransitions.slideFromLeft,
            transitionDuration: const Duration(milliseconds: 500),
            child: BlocProvider(
              create: (context) =>
                  FilteredProductsCubit(sl.get<ProductsRepo>())
                    ..getProductsByMultipleFilters(
                      carName: product.carName,
                      year: product.modelYear,
                      categoryName: product.categoryName,
                    ),
              child: StatusBarWidget(
                child: PriceComparisonView(
                  categoryName: product.categoryName,
                  excludeProductId: product.id,
                ),
              ),
            ),
          );
        },
      ),
      GoRoute(
        path: '/${AppRouteConst.filteredProductsView}',
        name: AppRouteConst.filteredProductsView,
        pageBuilder: (context, state) {
          final extra = state.extra as Map<String, dynamic>;
          final title = extra['title'] as String;
          final filterType = extra['filterType'] as String;
          final filterValue = extra['filterValue']?.toString() ?? '';
          final excludeProductId = extra['excludeProductId'] as String?;

          return CustomTransitionPage(
            key: state.pageKey,
            transitionsBuilder: PageTransitions.slideFromLeft,
            transitionDuration: const Duration(milliseconds: 500),
            child: BlocProvider(
              create: (context) {
                final cubit = FilteredProductsCubit(sl.get<ProductsRepo>());
                if (filterType == 'compatible') {
                  cubit.getCompatibleParts(
                    carName: extra['carName'],
                    year: extra['year'],
                  );
                } else if (filterType == 'multi') {
                  cubit.getProductsByMultipleFilters(
                    carName: extra['carName'],
                    year: extra['year'],
                    categoryName: extra['categoryName'],
                  );
                } else if (filterType == 'brand') {
                  cubit.getProductsByBrand(filterValue);
                } else if (filterType == 'category') {
                  cubit.getProductsByCategory(filterValue);
                } else if (filterType == 'car') {
                  cubit.getProductsByCar(filterValue);
                } else if (filterType == 'supplier') {
                  cubit.getProductsBySupplier(filterValue);
                } else if (filterType == 'all') {
                  cubit.getAllProducts();
                }
                return cubit;
              },
              child: StatusBarWidget(
                child: FilteredProductsView(
                  title: title,
                  excludeProductId: excludeProductId,
                ),
              ),
            ),
          );
        },
      ),
      GoRoute(
        path: '/${AppRouteConst.searchProducts}',
        name: AppRouteConst.searchProducts,
        pageBuilder: (context, state) {
          final extra = state.extra;
          String? initialQuery;
          List<String>? initialIds;

          if (extra is String) {
            initialQuery = extra;
          } else if (extra is Map<String, dynamic>) {
            initialQuery = extra['query'] as String?;
            initialIds = extra['matchedIds'] as List<String>?;
          }
          return CustomTransitionPage(
            key: state.pageKey,
            transitionsBuilder: PageTransitions.slideFromLeft,
            transitionDuration: const Duration(milliseconds: 500),
            child: MultiBlocProvider(
              providers: [
                BlocProvider(
                  create: (context) =>
                      SearchProductsCubit(sl.get<ProductsRepo>())..initSearch(),
                ),
                BlocProvider(
                  create: (context) => sl.get<GetBrandsCubit>()..getBrands(),
                ),
                BlocProvider(
                  create: (context) =>
                      sl.get<GetCategoriesCubit>()..getCategories(),
                ),
                BlocProvider(create: (context) => sl.get<GetBrandCarsCubit>()),
              ],
              child: StatusBarWidget(
                child: SearchProductsView(
                  initialQuery: initialQuery,
                  initialIds: initialIds,
                ),
              ),
            ),
          );
        },
      ),
    ],
  );
}
